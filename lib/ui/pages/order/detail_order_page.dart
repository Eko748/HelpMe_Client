import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:midtrans_snap/models.dart';
// import 'package:timelines/timelines.dart';

import '../../../blocs/manage_order/manage_order_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../cubits/detail_order/detail_order_cubit.dart';
import '../../../cubits/home/home_cubit.dart';
import '../../../cubits/rate_mitra/rate_mitra_cubit.dart';
import '../../../models/order/detail_order_model.dart';
import '../../widgets/custom_dialog.dart';
import '../../../utils/manage_token.dart';
import '../../widgets/gradient_card.dart';

enum OrderStatus {
  pending,
  booked,
  paid,
  cancelled,
  otw,
  arrived,
  inProgress,
  complete,
  rated,
}

class DetailOrderPage extends StatefulWidget {
  final int? orderId;
  final double? distanceInKm;
  const DetailOrderPage({
    super.key,
    required this.orderId,
    this.distanceInKm,
  });

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  DetailOrderModel? detailOrder;
  OrderStatus orderStatus = OrderStatus.pending;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidht = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android;
      if (notification != null && android != null) {
        if (notification.title!.trim().toLowerCase().contains('order') &&
            notification.body!
                .trim()
                .toLowerCase()
                .contains('status updated') &&
            context.mounted) {
          context
              .read<DetailOrderCubit>()
              .fetchDetailOrder(orderId: widget.orderId!);
        }
      }
    });

    Widget widgetContent;
    switch (orderStatus) {
      case OrderStatus.pending:
        widgetContent = Text(
          'Anda belum memilh mitra!',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.darkTextColor,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
      case OrderStatus.booked:
        widgetContent = _paymentConsumer(textTheme);
        break;
      case OrderStatus.cancelled:
        widgetContent = Text(
          'Order dibatalkan!',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.darkTextColor,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
      default:
        // widgetContent = _orderTimeLine(textTheme);
        break;
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        didPop ? context.read<DetailOrderCubit>().clearDetailOrder() : null;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: _appBar(context, textTheme),
          body: BlocProvider(
            create: (context) => RateMitraCubit(),
            child: BlocListener<RateMitraCubit, RateMitraState>(
              listener: (context, state) {
                if (state is RateMitraSuccess) {
                  context
                      .read<DetailOrderCubit>()
                      .fetchDetailOrder(orderId: widget.orderId!);
                }
              },
              child: BlocConsumer<DetailOrderCubit, DetailOrderState>(
                  listener: (context, state) {
                if (state is DetailOrderLoaded) {
                  detailOrder = state.data;
                  switch (detailOrder?.orderStatus) {
                    case 'pending':
                      setState(() {
                        orderStatus = OrderStatus.pending;
                      });
                      break;
                    case 'booked':
                      setState(() {
                        orderStatus = OrderStatus.booked;
                      });
                      break;
                    case 'paid':
                      setState(() {
                        orderStatus = OrderStatus.paid;
                      });
                      break;
                    case 'cancelled':
                      setState(() {
                        orderStatus = OrderStatus.cancelled;
                      });
                      break;
                    case 'otw':
                      setState(() {
                        orderStatus = OrderStatus.otw;
                      });
                      break;
                    case 'arrived':
                      setState(() {
                        orderStatus = OrderStatus.arrived;
                      });
                      break;
                    case 'in_progress':
                      setState(() {
                        orderStatus = OrderStatus.inProgress;
                      });
                      break;
                    case 'complete':
                      setState(() {
                        orderStatus = OrderStatus.complete;
                      });
                      break;
                    case 'rated':
                      setState(() {
                        orderStatus = OrderStatus.rated;
                      });
                  }
                }
                if (state is DetailOrderError) {
                  CustomDialog.showAlertDialog(
                    context,
                    'Peringatan!',
                    state.message,
                    null,
                  );
                }
                if (state is ListeningOrderStatusError) {
                  CustomDialog.showAlertDialog(
                    context,
                    'Terjadi Kesalahan!',
                    state.message,
                    null,
                  );
                }
                if (state is OpenWhatsAppError) {
                  CustomDialog.showAlertDialog(
                    context,
                    'Gagal Membuka WhatsApp!',
                    state.message,
                    null,
                  );
                }
                if (state is CreateChatRoomSuccess) {
                  context.read<DetailOrderCubit>().isIdle();
                  context.pushNamed(
                    'chatPage',
                    queryParameters: {
                      'id': (context.read<ProfileBloc>().profile?.id ?? 0)
                          .toString(),
                      'roomCode': context
                          .read<DetailOrderCubit>()
                          .chatRoomCode
                          .toString(),
                      'name': detailOrder?.mitra.toString(),
                      'img': detailOrder?.mitraProfile.toString(),
                    },
                  );
                }
              }, builder: (context, state) {
                if (detailOrder == null) {
                  context
                      .read<DetailOrderCubit>()
                      .fetchDetailOrder(orderId: widget.orderId!);
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is DetailOrderLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => context
                      .read<DetailOrderCubit>()
                      .fetchDetailOrder(orderId: widget.orderId!),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: GradientCard(
                      width: screenWidht,
                      height: screenHeight - (screenHeight / 8),
                      cardColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _infoSection(textTheme),
                                _imageSection(),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Text(
                              'Status Bantuan',
                              style: textTheme.titleLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Expanded(child: widgetContent),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            if (orderStatus == OrderStatus.complete &&
                                detailOrder?.isRated == false) ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => CustomDialog.ratingDialog(
                                    context,
                                    textTheme: textTheme,
                                    orderId: widget.orderId!,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                      AppColors.goldenYellow,
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(42),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Rate Mitra',
                                    style: textTheme.bodyLarge?.copyWith(
                                        color: AppColors.lightTextColor),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                            if (orderStatus != OrderStatus.pending &&
                                orderStatus != OrderStatus.booked &&
                                orderStatus != OrderStatus.complete &&
                                orderStatus != OrderStatus.rated &&
                                orderStatus != OrderStatus.cancelled)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _callBtn(context, textTheme),
                                  const SizedBox(width: 10),
                                  _chatBtn(context, textTheme),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  BlocConsumer<ManageOrderBloc, ManageOrderState> _paymentConsumer(
      TextTheme textTheme) {
    return BlocConsumer<ManageOrderBloc, ManageOrderState>(
      listener: (context, state) async {
        if (state is SnapTokenError) {
          CustomDialog.showAlertDialog(
            context,
            'Gagal Memproses Transaksi!',
            state.message,
            null,
          );
        }
        if (state is SnapTokenRequested) {
          await _invokePayment(context);
        }
      },
      builder: (context, state) {
        if (state is ManageOrderLoading) {
          return const Column(
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        return Column(
          children: [
            OutlinedButton(
              onPressed: () async {
                if (context.read<ManageOrderBloc>().snapToken == null) {
                  context.read<ManageOrderBloc>().add(RequestSnapToken(
                        orderId: detailOrder!.orderId!,
                      ));
                } else {
                  await _invokePayment(context);
                }
              },
              child: Text(
                'Lanjutkan pembayaran',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.darkTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _invokePayment(BuildContext context) async {
    final response = await context.pushNamed(
      'payPage',
      queryParameters: {
        'token': context.read<ManageOrderBloc>().snapToken,
      },
    );
    if (response is MidtransResponse && context.mounted) {
      if (response.transactionStatus.trim().toLowerCase() == 'settlement' &&
          response.statusCode == 200 &&
          response.fraudStatus.trim().toLowerCase() == 'accept') {
        ManageSnapToken.deleteToken();
        context.read<ManageOrderBloc>().snapToken = null;
        context.read<ManageOrderBloc>().add(CompletingPayment());
        context.read<HomeCubit>().fetchHistory();
        context
            .read<DetailOrderCubit>()
            .fetchDetailOrder(orderId: widget.orderId!);
      } else if (response.statusCode == 201 &&
          response.transactionStatus.trim().toLowerCase() == 'pending') {
        context.read<ManageOrderBloc>().add(WaitingPayment());
        CustomDialog.showAlertDialog(
          context,
          'Pembayaran Pending!',
          'Harap selesaikan pembayaran dalam waktu yang ditentukan',
          null,
        );
      } else if (response.statusCode == 407) {
        ManageSnapToken.deleteToken();
        context.read<ManageOrderBloc>().snapToken = null;
        context.read<ManageOrderBloc>().add(ManageOrderIsIdle());
        CustomDialog.showAlertDialog(
          context,
          'Pembayaran Gagal!',
          'Transaksi kadaluwarsa, silahkan coba lagi',
          null,
        );
      } else {
        _invokePayment(context);
      }
    } else if (response is String && context.mounted) {
      if (response
              .trim()
              .toLowerCase()
              .contains('transaction_status=settlement') &&
          response.trim().toLowerCase().contains('status_code=200')) {
        ManageSnapToken.deleteToken();
        context.read<ManageOrderBloc>().snapToken = null;
        context.read<ManageOrderBloc>().add(CompletingPayment());
        context.read<HomeCubit>().fetchHistory();
        context
            .read<DetailOrderCubit>()
            .fetchDetailOrder(orderId: widget.orderId!);
      } else if (response.trim().toLowerCase().contains('status_code=201') &&
          response.trim().toLowerCase().contains('pending')) {
        context.read<ManageOrderBloc>().add(WaitingPayment());
        CustomDialog.showAlertDialog(
          context,
          'Pembayaran Pending!',
          'Harap selesaikan pembayaran dalam waktu yang ditentukan',
          null,
        );
      } else if (response.trim().toLowerCase().contains('status_code=407') ||
          response.trim().toLowerCase().contains('error')) {
        ManageSnapToken.deleteToken();
        context.read<ManageOrderBloc>().snapToken = null;
        context.read<ManageOrderBloc>().add(ManageOrderIsIdle());
        CustomDialog.showAlertDialog(
          context,
          'Pembayaran Gagal!',
          'Transaksi kadaluwarsa, silahkan coba lagi',
          null,
        );
      } else {
        _invokePayment(context);
      }
    }
  }

  // FixedTimeline _orderTimeLine(TextTheme textTheme) {
  //   return FixedTimeline.tileBuilder(
  //     theme: TimelineThemeData(
  //       color: AppColors.limeGreen,
  //       connectorTheme: const ConnectorThemeData(
  //         space: 20,
  //       ),
  //     ),
  //     builder: TimelineTileBuilder.connectedFromStyle(
  //       itemCount: switch (orderStatus) {
  //         OrderStatus.pending => 0,
  //         OrderStatus.booked => 0,
  //         OrderStatus.paid => 1,
  //         OrderStatus.cancelled => 0,
  //         OrderStatus.otw => 2,
  //         OrderStatus.arrived => 3,
  //         OrderStatus.inProgress => 4,
  //         OrderStatus.complete => 5,
  //         OrderStatus.rated => 5,
  //       },
  //       contentsBuilder: (context, index) {
  //         String status = 'Status dari order';
  //         if (index == 0) {
  //           status = 'Uang Transport Dibayar';
  //         }
  //         if (index == 1) {
  //           status = 'Abangnya OTW';
  //         }
  //         if (index == 2) {
  //           status = 'Abangnya sudah sampai';
  //         }
  //         if (index == 3) {
  //           status = 'Sedang dikerjakan';
  //         }
  //         if (index == 4) {
  //           status = 'Pekerjaan selesai';
  //         }
  //         return Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             status,
  //             style: textTheme.bodyLarge?.copyWith(
  //               color: AppColors.darkTextColor,
  //             ),
  //           ),
  //         );
  //       },
  //       firstConnectorStyle: ConnectorStyle.transparent,
  //       lastConnectorStyle: ConnectorStyle.transparent,
  //       connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
  //       indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
  //     ),
  //   );
  // }

  Expanded _callBtn(BuildContext context, TextTheme textTheme) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => context.read<DetailOrderCubit>().openWhatsApp(
              detailOrder?.phoneNumberMitra ?? '',
            ),
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(
            AppColors.primary,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(42),
            ),
          ),
        ),
        child: Text(
          'Call',
          style: textTheme.bodyLarge?.copyWith(color: AppColors.lightTextColor),
        ),
      ),
    );
  }

  Expanded _chatBtn(BuildContext context, TextTheme textTheme) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (context.read<DetailOrderCubit>().chatRoomCode == null) {
            context
                .read<DetailOrderCubit>()
                .createChatRoom(orderId: detailOrder!.orderId!);
          } else {
            context.pushNamed(
              'chatPage',
              queryParameters: {
                'id': (context.read<ProfileBloc>().profile?.id ?? 0).toString(),
                'roomCode':
                    context.read<DetailOrderCubit>().chatRoomCode.toString(),
                'name': detailOrder?.mitra.toString(),
                'img': detailOrder?.mitraProfile.toString(),
              },
            );
          }
        },
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(
            AppColors.darkTextColor,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(42),
            ),
          ),
        ),
        child: Text(
          'Chat',
          style: textTheme.bodyLarge?.copyWith(color: AppColors.lightTextColor),
        ),
      ),
    );
  }

  Container _imageSection() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 40),
      child: CircleAvatar(
        radius: 21,
        backgroundColor: AppColors.surface,
        child: CircleAvatar(
          radius: 16,
          backgroundImage: detailOrder?.mitraProfile != null
              ? CachedNetworkImageProvider(
                  detailOrder?.mitraProfile ??
                      'https://st2.depositphotos.com/1561359/12101/v/950/depositphotos_121012076-stock-illustration-blank-photo-icon.jpg',
                )
              : const AssetImage('assets/images/girl1.png'),
        ),
      ),
    );
  }

  Column _infoSection(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LimitedBox(
          maxWidth: 310,
          child: Text(
            detailOrder?.mitra != null
                ? detailOrder?.mitra.toString() ?? 'N/A'
                : 'Gagal memproses data, refresh untuk lanjut',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        LimitedBox(
            maxWidth: 310,
            child: Text(
              widget.distanceInKm != null
                  ? '${widget.distanceInKm}km'
                  : detailOrder?.orderTime.toString() ?? 'N/A',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.aquamarine,
              ),
            )),
        const SizedBox(height: 10),
        Text(
          detailOrder?.price != null ? 'Rp${detailOrder?.price}' : 'N/A',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        'Help Me!',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
