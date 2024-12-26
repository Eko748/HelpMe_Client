import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../configs/app_colors.dart';
import '../../widgets/custom_dialog.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _appBar(context, textTheme),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ForgetPasswordError) {
              CustomDialog.showAlertDialog(
                context,
                'Gagal!',
                state.message,
                null,
              );
            } else if (state is ForgetPasswordLoaded) {
              final message = state.message;
              // nomor tidak terdaftar atau belum diverifikasi
              if (message.toLowerCase().trim().contains('belum') ||
                  message.toLowerCase().trim().contains('tidak')) {
                context.read<AuthBloc>().add(AuthIsIdle());
              } else {
                context.read<AuthBloc>().add(ResetAuthState());
              }
              CustomDialog.showAlertDialog(
                context,
                'Permintaan terkirim!',
                message,
                null,
              );
            }
          },
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsetsDirectional.all(20),
              children: [
                Center(
                  child: Text(
                    'Reset kata sandi',
                    style: textTheme.titleLarge
                        ?.copyWith(color: AppColors.darkTextColor),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Nomor telpon',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.darkTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                _phoneNumberInput(
                  context,
                  textTheme,
                  state,
                ),
                const SizedBox(height: 20),
                if (state is AuthLoading) ...[
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ] else ...[
                  _confirmBtn(context, textTheme, state),
                ],
                const SizedBox(height: 10),
                _verifyBtn(context, textTheme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _verifyBtn(BuildContext context, TextTheme textTheme) {
    return GestureDetector(
      onTap: () => context.pushNamed('verifyPhoneNumberPage'),
      child: Center(
        child: Text(
          'Verifikasi nomor',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.darkTextColor,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.darkTextColor,
          ),
        ),
      ),
    );
  }

  SizedBox _confirmBtn(
    BuildContext context,
    TextTheme textTheme,
    AuthState state,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            state is AuthInitial == true ? AppColors.gray : AppColors.primary,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () => state is AuthInitial != true
            ? context.read<AuthBloc>().add(ForgetPasswordSubmitted())
            : null,
        child: Text(
          'Konfirmasi',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.lightTextColor,
            fontStyle: state is AuthInitial == true
                ? FontStyle.italic
                : FontStyle.normal,
          ),
        ),
      ),
    );
  }

  TextFormField _phoneNumberInput(
    BuildContext context,
    TextTheme textTheme,
    AuthState state,
  ) {
    return TextFormField(
      enabled: state is AuthInitial ? false : true,
      onChanged: (value) => context.read<AuthBloc>().add(
            PhoneNumberChanged(value),
          ),
      cursorColor: Colors.black,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukan nomor telpon',
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.hintTextColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
      ),
    );
  }

  AppBar _appBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      foregroundColor: AppColors.darkTextColor,
      title: Text(
        'HelpMe!',
        style: textTheme.titleLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
