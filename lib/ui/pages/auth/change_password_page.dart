import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/profile/profile_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../widgets/custom_dialog.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: <Widget>[
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            _sliverAppBar(context, textTheme),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Ubah Kata Sandi',
                        style: textTheme.headlineLarge?.copyWith(
                            color: AppColors.darkTextColor,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<ProfileBloc, ProfileState>(
                      listener: (context, state) {
                        if (state is EditPasswordError) {
                          _stateError(context, state);
                        } else if (state is EditPasswordLoaded) {
                          _stateLoaded(context, state);
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password Lama',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _oldPasswordInputField(context, textTheme),
                            const SizedBox(height: 10),
                            Text(
                              'Password Baru',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _newPasswordInputField(context, textTheme),
                            const SizedBox(height: 10),
                            Text(
                              'Konfirmasi Password',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _newConfirmPasswordInputField(context, textTheme),
                            const SizedBox(height: 20),
                            if (state is ProfileLoading) ...[
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                              const SizedBox(height: 10),
                            ] else ...[
                              _saveButton(textTheme, context, state),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _stateError(BuildContext context, EditPasswordError state) {
    CustomDialog.showAlertDialog(
      context,
      'Peringatan!',
      state.errorMessage,
      null,
    );
    context.read<ProfileBloc>().add(ProfileIsIdle());
  }

  _stateLoaded(BuildContext context, EditPasswordLoaded state) {
    CustomDialog.showAlertDialog(
      context,
      'Ubah Kata Sandi',
      state.message,
      null,
    );
    context.read<ProfileBloc>().add(ProfileIsIdle());
  }

  SizedBox _saveButton(
      TextTheme textTheme, BuildContext context, ProfileState state) {
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
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () =>
            context.read<ProfileBloc>().add(EditPasswordSubmitted()),
      ),
    );
  }

  TextFormField _oldPasswordInputField(
      BuildContext context, TextTheme textTheme) {
    return TextFormField(
      onChanged: (value) => context.read<ProfileBloc>().add(
            OldPasswordChanged(oldPassword: value),
          ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukkan password lama',
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

  TextFormField _newPasswordInputField(
      BuildContext context, TextTheme textTheme) {
    return TextFormField(
      onChanged: (value) => context.read<ProfileBloc>().add(
            NewPasswordChanged(newPassword: value),
          ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukkan password baru',
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

  TextFormField _newConfirmPasswordInputField(
      BuildContext context, TextTheme textTheme) {
    return TextFormField(
      onChanged: (value) => context.read<ProfileBloc>().add(
            NewConfirmPasswordChanged(newConfirmPassword: value),
          ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Konfirmasi password baru',
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

  SliverAppBar _sliverAppBar(BuildContext context, TextTheme textTheme) {
    return SliverAppBar(
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
