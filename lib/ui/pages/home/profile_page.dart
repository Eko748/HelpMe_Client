import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../../models/auth/user_model.dart';
import '../../../utils/manage_token.dart';
import '../../widgets/custom_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? profile;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    profile = context.watch<ProfileBloc>().profile;

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
                  if (state is ProfileError) {
                    _onStateError(context, state);
                  } else if (state is ProfileLoaded) {
                    profile = state.data.user;
                    context.read<ProfileBloc>().profile = profile;
                  }
                },
                builder: (context, state) {
                  if (profile == null) {
                    context.read<ProfileBloc>().add(FetchProfile());
                  }
                  if (state is ProfileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.only(
                      top: (screenHeight / 30),
                      left: 20,
                      right: 20,
                    ),
                    child: RefreshIndicator(
                      triggerMode: RefreshIndicatorTriggerMode.onEdge,
                      onRefresh: () async {
                        context.read<ProfileBloc>().add(FetchProfile());
                      },
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Center(
                              child: _profileSummarySection(textTheme),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 20)),
                          SliverToBoxAdapter(child: _fullnameText(textTheme)),
                          const SliverToBoxAdapter(child: SizedBox(height: 10)),
                          SliverToBoxAdapter(child: _usernameText(textTheme)),
                          const SliverToBoxAdapter(child: SizedBox(height: 10)),
                          SliverToBoxAdapter(
                            child: _phoneNumberSection(context, textTheme),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 20)),
                          SliverToBoxAdapter(child: _editProfileBtn(textTheme)),
                          const SliverToBoxAdapter(child: SizedBox(height: 20)),
                          SliverToBoxAdapter(child: _keamananText(textTheme)),
                          const SliverToBoxAdapter(child: SizedBox(height: 10)),
                          SliverToBoxAdapter(
                            child: _passwordSection(textTheme),
                          ),
                        ],
                      ),
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

  Row _passwordSection(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _passwordText(textTheme),
        _changePasswordBtn(textTheme),
      ],
    );
  }

  SizedBox _changePasswordBtn(TextTheme textTheme) {
    return SizedBox(
      width: 90,
      height: 40,
      child: OutlinedButton(
        style: const ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(
              color: AppColors.surface,
            ),
          ),
        ),
        onPressed: () => context.pushNamed('changePasswordPage'),
        child: Text(
          'Ubah',
          style: textTheme.labelLarge?.copyWith(
            fontSize: 13,
            color: AppColors.darkTextColor,
            fontWeight: FontWeight.w100,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Text _passwordText(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Password\n',
        style: textTheme.titleMedium?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: '********',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Text _keamananText(TextTheme textTheme) {
    return Text(
      'Keamanan',
      style: textTheme.titleLarge?.copyWith(
        color: AppColors.darkTextColor,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  SizedBox _editProfileBtn(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 42,
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
          'Ubah data',
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => context.pushNamed('editProfilePage'),
      ),
    );
  }

  Row _phoneNumberSection(BuildContext context, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _phoneNumberText(textTheme),
        profile?.phoneNumberVerifiedAt != null
            ? _numberVerified(textTheme)
            : _numberNotVerified(context, textTheme),
      ],
    );
  }

  SizedBox _numberNotVerified(BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: 100,
      height: 40,
      child: OutlinedButton(
        onPressed: () {
          context.read<ProfileBloc>().add(
                NewFullnameChanged(fullname: profile!.fullName.toString()),
              );
          context.read<ProfileBloc>().add(
                NewUsernameChanged(username: profile!.username.toString()),
              );
          context.read<ProfileBloc>().add(
                NewPhoneNumberChanged(
                    phoneNumber: profile!.phoneNumber.toString()),
              );
          context.pushNamed('verifyPhoneNumberPage');
        },
        style: const ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(
              color: AppColors.primary,
            ),
          ),
        ),
        child: Text(
          'Verifikasi',
          style: textTheme.labelLarge?.copyWith(
            fontSize: 10,
            color: AppColors.primary,
            fontWeight: FontWeight.w100,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Row _numberVerified(TextTheme textTheme) {
    return Row(
      children: [
        Text(
          'Terverifikasi',
          style: textTheme.labelLarge?.copyWith(
            color: AppColors.darkTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        const Icon(
          Icons.verified_user,
          color: Colors.greenAccent,
        ),
      ],
    );
  }

  Text _phoneNumberText(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Nomor Telepon\n',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: profile?.phoneNumber ?? 'Reload untuk menampilkan data',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Text _usernameText(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Username\n',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: profile?.username ?? 'Reload untuk menampilkan data',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Text _fullnameText(TextTheme textTheme) {
    return Text.rich(
      TextSpan(
        text: 'Nama Lengkap\n',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: profile?.fullName ?? 'Reload untuk menampilkan data',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _onStateError(BuildContext context, ProfileError state) {
    CustomDialog.showAlertDialog(
      context,
      'Error saat memproses profile',
      state.errorMessage,
      state.errorMessage.toString().trim().toLowerCase().contains('invalid') ||
              state.errorMessage
                  .toString()
                  .trim()
                  .toLowerCase()
                  .contains('unauthorized')
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
          : IconButton.outlined(
              onPressed: () {
                context.pop();
                context.read<ProfileBloc>().add(FetchProfile());
              },
              icon: const Icon(Icons.refresh_outlined),
            ),
    );
    context.read<ProfileBloc>().add(ProfileIsIdle());
  }

  Column _profileSummarySection(TextTheme textTheme) {
    return Column(
      children: [
        CircleAvatar(
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
        ),
        const SizedBox(height: 10),
        Text(
          profile?.fullName ?? 'Fullname',
          style: textTheme.titleLarge?.copyWith(
              color: AppColors.darkTextColor, fontWeight: FontWeight.w600),
        ),
        // const SizedBox(height: 10),
        Text(
          profile?.username ?? 'Username',
          style: textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextColor, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.lightTextColor,
      title: Text(
        'Profile',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.lightTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
