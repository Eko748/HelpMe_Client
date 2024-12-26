import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../data/menu_items_data.dart';
import '../../../models/auth/user_model.dart';
import '../../../models/misc/menu_item_model.dart';
import '../../../utils/manage_token.dart';
import '../../widgets/custom_dialog.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  UserModel? profile;
  XFile? pickedImg;

  final _fullnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pickedImg = null;
    profile = context.read<ProfileBloc>().profile;
    _fullnameController.text = profile!.fullName.toString();
    _usernameController.text = profile!.username.toString();
    _phoneNumberController.text = profile!.phoneNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: _appBar(context, textTheme),
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              width: screenWidth,
              height: screenHeight / 1.32,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(500, 250),
                    topRight: Radius.elliptical(500, 250),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is EditProfileError) {
                    _onStateError(context, state.message);
                  } else if (state is ProfileEdited) {
                    _onProfileEdited(context, state);
                  } else if (state is ImagePicked) {
                    pickedImg = state.pickedImage;
                  } else if (state is EditPasswordError) {
                    _onStateError(context, state.errorMessage);
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: (screenHeight / 30),
                      left: 20,
                      right: 20,
                    ),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Center(
                            child: _profileSummarySection(textTheme, state),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverToBoxAdapter(child: _fullnameText(textTheme)),
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),
                        SliverToBoxAdapter(
                          child: _fullnameInputField(context, textTheme),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 15)),
                        SliverToBoxAdapter(child: _usernameText(textTheme)),
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),
                        SliverToBoxAdapter(
                          child: _usernameInputField(context, textTheme),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 15)),
                        SliverToBoxAdapter(child: _phoneNumberText(textTheme)),
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),
                        SliverToBoxAdapter(
                          child: _phoneNumInputField(context, textTheme),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        if (state is ProfileLoading) ...{
                          const SliverToBoxAdapter(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        } else ...{
                          SliverToBoxAdapter(child: _editProfileBtn(textTheme)),
                        },
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  PopupMenuButton<MenuItemModel> _pickImageBtn(
    BuildContext context,
    ProfileState state,
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
        Icons.edit_outlined,
        size: 60,
        color: Colors.white60,
      ),
      onSelected: (value) => _pickImageMenuFunction(context, state, value),
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
      BuildContext context, ProfileState state, MenuItemModel item) {
    switch (item) {
      case MenuItems.itemFromCamera:
        context.read<ProfileBloc>().add(CameraCapture());
        break;
      case MenuItems.itemFromGallery:
        context.read<ProfileBloc>().add(GalleryImagePicker());
        break;
    }
  }

  TextFormField _phoneNumInputField(BuildContext context, TextTheme textTheme) {
    return TextFormField(
      controller: _phoneNumberController,
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        _phoneNumberController.text = value;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukkan nomor telpon',
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: AppColors.hintTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  TextFormField _usernameInputField(BuildContext context, TextTheme textTheme) {
    return TextFormField(
      controller: _usernameController,
      onChanged: (value) {
        _usernameController.text = value;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukkan username',
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: AppColors.hintTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  TextFormField _fullnameInputField(BuildContext context, TextTheme textTheme) {
    return TextFormField(
      controller: _fullnameController,
      onChanged: (value) {
        _fullnameController.text = value;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukkan nama lengkap',
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: AppColors.hintTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  SizedBox _editProfileBtn(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            AppColors.primary,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(
          'Simpan',
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          context.read<ProfileBloc>().add(
                NewFullnameChanged(fullname: _fullnameController.text),
              );
          context.read<ProfileBloc>().add(
                NewUsernameChanged(username: _usernameController.text),
              );
          context.read<ProfileBloc>().add(
                NewPhoneNumberChanged(
                  phoneNumber: _phoneNumberController.text,
                ),
              );
          context.read<ProfileBloc>().add(
                EditProfileSubmitted(),
              );
        },
      ),
    );
  }

  Text _phoneNumberText(TextTheme textTheme) {
    return Text(
      'Nomor Telepon',
      style: textTheme.titleLarge?.copyWith(
        color: AppColors.darkTextColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Text _usernameText(TextTheme textTheme) {
    return Text(
      'Username',
      style: textTheme.titleLarge?.copyWith(
        color: AppColors.darkTextColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Text _fullnameText(TextTheme textTheme) {
    return Text(
      'Nama Lengkap',
      style: textTheme.titleLarge?.copyWith(
        color: AppColors.darkTextColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _onProfileEdited(BuildContext context, ProfileEdited state) {
    CustomDialog.showAlertDialog(
      context,
      'Berhasil!',
      state.message,
      null,
    );
    profile = state.data;
    context.read<ProfileBloc>().add(FetchProfile());
  }

  void _onStateError(BuildContext context, String message) {
    CustomDialog.showAlertDialog(
      context,
      'Gagal!',
      message,
      message.toString().trim().toLowerCase().contains('invalid') ||
              message.toString().trim().toLowerCase().contains('unauthorized')
          ? OutlinedButton.icon(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ManageAuthToken.deleteToken();
                  context.read<AuthBloc>().add(AuthIsIdle());
                  context.goNamed('signInPage');
                });
              },
              label: const Text('Sign In ulang'),
              icon: const Icon(Icons.arrow_forward_ios),
              iconAlignment: IconAlignment.end,
            )
          : null,
    );
    context.read<ProfileBloc>().add(ProfileIsIdle());
  }

  Stack _profileSummarySection(TextTheme textTheme, ProfileState state) {
    return Stack(
      children: [
        if (pickedImg != null) _newProfileImage() else _oldProfileImage(),
        Positioned.fill(
          child: _pickImageBtn(context, state),
        ),
      ],
    );
  }

  CircleAvatar _oldProfileImage() {
    return CircleAvatar(
      radius: 83,
      backgroundColor: AppColors.surface,
      child: CircleAvatar(
        radius: 80,
        backgroundImage: profile?.imageProfile != null
            ? CachedNetworkImageProvider(
                profile?.imageProfile ??
                    'https://st2.depositphotos.com/1561359/12101/v/950/depositphotos_121012076-stock-illustration-blank-photo-icon.jpg',
                maxWidth: 150,
                maxHeight: 150,
              )
            : const AssetImage('assets/images/man1.png'),
      ),
    );
  }

  CircleAvatar _newProfileImage() {
    return CircleAvatar(
      radius: 83,
      backgroundColor: AppColors.surface,
      child: CircleAvatar(
        radius: 80,
        backgroundImage: pickedImg != null
            ? FileImage(File(pickedImg!.path))
            : const AssetImage('assets/images/man1.png'),
      ),
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.lightTextColor,
      title: Text(
        'Edit Profile',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
