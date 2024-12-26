import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/app_colors.dart';
import '../../../cubits/detail_order/detail_order_cubit.dart';
import '../../../data/menu_items_data.dart';
import '../../../models/misc/menu_item_model.dart';
import '../../../models/order/chat/chat_response_model.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/bubble_chat.dart';

class ChatPage extends StatefulWidget {
  final int userId;
  final String chatRoomCode;
  final String mitraName;
  final String imgPath;

  const ChatPage({
    super.key,
    required this.userId,
    required this.chatRoomCode,
    required this.mitraName,
    required this.imgPath,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chatInputController = TextEditingController();
  final _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_chatScrollController.hasClients) {
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenHeight = MediaQuery.sizeOf(context).height;

    if (context.read<DetailOrderCubit>().chatMessages.isEmpty) {
      context.read<DetailOrderCubit>().isIdle();
      context
          .read<DetailOrderCubit>()
          .fetchChatMessagesHistory(roomCode: widget.chatRoomCode);
    }

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android;
      if (notification != null && android != null) {
        if (notification.title!.trim().toLowerCase().contains('chat') &&
            notification.body!.trim().toLowerCase().contains('new message')) {
          final data = message.data;
          if (data.isNotEmpty && context.mounted) {
            final receivedChat = ChatResponseModel(
              senderId: int.parse(data['sender_id']),
              message: data['message'],
              createdAt: DateTime.parse(data['created_at']),
            );
            context.read<DetailOrderCubit>().receivingChat(receivedChat);
          }
        }
      }
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _appBar(textTheme),
        body: BlocConsumer<DetailOrderCubit, DetailOrderState>(
          listener: (context, state) {
            if (state is ErrorChat) {
              CustomDialog.showAlertDialog(
                context,
                'Peringatan!',
                state.message,
                null,
              );
            }
            if (state is ReceiveChat) {
              context.read<DetailOrderCubit>().chatMessages.add(state.response);
              context.read<DetailOrderCubit>().isIdle();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
            }
            if (state is MessagesLoaded) {
              context.read<DetailOrderCubit>().chatMessages = state.messages;
              context.read<DetailOrderCubit>().isIdle();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
            }
            if (state is ImageSelected) {
              _sendImageDialog(context, state);
            }
            if (state is SendMessageSuccess) {
              context.read<DetailOrderCubit>().chatMessages.add(
                    ChatResponseModel(
                      createdAt: state.response.data!.createdAt,
                      message: state.response.data!.message,
                      senderId: state.response.data!.senderId,
                    ),
                  );
              context.read<DetailOrderCubit>().isIdle();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  if (state is ChatLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 68),
                      child: _chatMessagesBuilder(),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _chatTextInput(screenHeight, textTheme),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Padding _chatTextInput(double screenHeight, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: _chatInputContainer(screenHeight, textTheme),
    );
  }

  ListView _chatMessagesBuilder() {
    return ListView.builder(
      controller: _chatScrollController,
      itemCount: context.watch<DetailOrderCubit>().chatMessages.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final chat = context.read<DetailOrderCubit>().chatMessages[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _bubbleChat(
            chat.message,
            sendTime: chat.createdAt!,
            senderId: chat.senderId!,
            userId: widget.userId,
          ),
        );
      },
    );
  }

  Future<dynamic> _sendImageDialog(BuildContext context, ImageSelected state) {
    return showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButton(
                onPressed: () => context.pop(),
              ),
              Image.file(
                File(state.image.path),
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    context.read<DetailOrderCubit>().sendMessage(
                          roomCode: widget.chatRoomCode,
                          textMessage: null,
                          image: state.image,
                        );
                    context.pop();
                  },
                  icon: const Icon(Icons.send_rounded),
                  style: const ButtonStyle(
                    iconColor: WidgetStatePropertyAll(
                      AppColors.lightTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _chatInputContainer(double screenHeight, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightTextColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: _pickImageBtn(context)),
          Expanded(
            flex: 10,
            child: TextFormField(
              controller: _chatInputController,
              keyboardType: TextInputType.text,
              scrollPhysics: const ClampingScrollPhysics(),
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                suffixIconColor: Colors.black,
                border: InputBorder.none,
                hintText: 'Ketik pesan',
                hintStyle: textTheme.bodyLarge?.copyWith(
                  color: AppColors.hintTextColor,
                  decoration: TextDecoration.none,
                ),
              ),
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.lightTextColor,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              onPressed: () {
                context.read<DetailOrderCubit>().sendMessage(
                      roomCode: widget.chatRoomCode,
                      textMessage: _chatInputController.text,
                      image: null,
                    );
                _chatInputController.text = '';
              },
              icon: const Icon(Icons.send_rounded),
              style: const ButtonStyle(
                iconColor: WidgetStatePropertyAll(
                  AppColors.lightTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuButton<MenuItemModel> _pickImageBtn(
    BuildContext context,
  ) {
    return PopupMenuButton<MenuItemModel>(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppColors.lightTextColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.transparent,
      tooltip: 'Ambil gambar',
      position: PopupMenuPosition.under,
      icon: const Icon(
        Icons.image_outlined,
        color: AppColors.lightTextColor,
      ),
      onSelected: (value) => _pickImageMenuFunction(context, value),
      itemBuilder: (context) => [...MenuItems.pickImageItems.map(_buildItem)],
    );
  }

  PopupMenuItem<MenuItemModel> _buildItem(MenuItemModel item) =>
      PopupMenuItem<MenuItemModel>(
        value: item,
        child: Row(
          children: [
            Icon(item.icon),
            const SizedBox(width: 10),
            Text(item.title),
          ],
        ),
      );

  void _pickImageMenuFunction(
    BuildContext context,
    MenuItemModel item,
  ) {
    switch (item) {
      case MenuItems.itemFromCamera:
        context.read<DetailOrderCubit>().cameraCapture();
        break;
      case MenuItems.itemFromGallery:
        context.read<DetailOrderCubit>().galleryImagePicker();
        break;
    }
  }

  Row _bubbleChat(
    String? message, {
    required DateTime sendTime,
    required int senderId,
    required int userId,
  }) {
    return Row(
      textDirection: senderId == userId ? TextDirection.rtl : TextDirection.ltr,
      children: [
        BubbleChat(
          sendTime: sendTime,
          senderId: senderId,
          userId: userId,
          message: message,
        ),
      ],
    );
  }

  AppBar _appBar(TextTheme textTheme) {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        widget.mitraName,
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: _mitraProfile(),
        )
      ],
    );
  }

  CircleAvatar _mitraProfile() {
    return CircleAvatar(
      maxRadius: 20,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        maxRadius: 16,
        backgroundImage: CachedNetworkImageProvider(widget.imgPath),
      ),
    );
  }
}
