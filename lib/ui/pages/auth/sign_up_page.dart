import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/app_colors.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../widgets/custom_dialog.dart';

enum TextInputEvent {
  fullname,
  username,
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;

    bool isPassword = true;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            _sliverAPpBSliverAppBar(context, textTheme),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(),
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar akun',
                      style: textTheme.headlineLarge?.copyWith(
                          color: AppColors.darkTextColor,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is SignUpLoaded) {
                          _stateLoaded(context);
                        } else if (state is AuthError) {
                          _stateError(context, state);
                        } else if (state is PasswordToggled) {
                          context.read<AuthBloc>().add(AuthIsIdle());
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama lengkap',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _textInputField(
                                context,
                                textTheme,
                                'Masukkan nama lengkap',
                                TextInputEvent.fullname),
                            const SizedBox(height: 10),
                            Text(
                              'Nomor handphone',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _phoneNumInputField(context, textTheme),
                            const SizedBox(height: 10),
                            Text(
                              'Username',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _textInputField(context, textTheme,
                                'Masukan username', TextInputEvent.username),
                            const SizedBox(height: 10),
                            Text(
                              'Kata sandi',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _passwordInputField(state, context, textTheme,
                                'Masukan Kata sandi', isPassword),
                            const SizedBox(height: 10),
                            Text(
                              'Konfirmasi kata sandi',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _passwordInputField(state, context, textTheme,
                                'Konfirmasi kata sandi', !isPassword),
                            const SizedBox(height: 40),
                            if (state is AuthLoading) ...[
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                              const SizedBox(height: 10),
                            ] else ...[
                              _signUpButton(textTheme, context, state),
                            ],
                            const SizedBox(height: 10),
                            _haveAccountSection(textTheme, context),
                            const SizedBox(height: 50),
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

  Widget _haveAccountSection(TextTheme textTheme, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AuthBloc>().add(ResetAuthState());
        context.goNamed('signInPage');
      },
      child: Center(
        child: Text.rich(
          style: textTheme.bodyLarge?.copyWith(
              color: AppColors.darkTextColor, fontWeight: FontWeight.normal),
          TextSpan(
            text: 'Sudah memiliki akun? ',
            children: [
              TextSpan(
                text: 'Masuk',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _stateError(BuildContext context, AuthError state) {
    CustomDialog.showAlertDialog(
      context,
      'Peringatan!',
      state.message,
      null,
    );
    context.read<AuthBloc>().add(AuthIsIdle());
    return const SizedBox.shrink();
  }

  _stateLoaded(BuildContext context) {
    CustomDialog.showAlertDialog(
      context,
      'Berhasil Sign Up!',
      null,
      OutlinedButton.icon(
        onPressed: () {
          context.read<AuthBloc>().add(ResetAuthState());
            context.pop();
            context.goNamed('homePage');
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          iconColor: WidgetStateProperty.all(AppColors.lightTextColor),
        ),
        label: const Text(
          'Lanjut ke halaman utama',
          style: TextStyle(color: AppColors.lightTextColor),
        ),
        icon: const Icon(Icons.arrow_forward_ios_rounded),
        iconAlignment: IconAlignment.end,
      ),
    );
  }

  SizedBox _signUpButton(
      TextTheme textTheme, BuildContext context, AuthState state) {
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
          'Sign Up',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          context.read<AuthBloc>().add(SignUpSubmitted());
        },
      ),
    );
  }

  TextFormField _passwordInputField(AuthState state, BuildContext context,
      TextTheme textTheme, String hintText, bool passwordC) {
    return TextFormField(
      obscureText: !context.watch<AuthBloc>().isPasswordVisible,
      onChanged: (password) => context.read<AuthBloc>().add(passwordC
          ? PasswordChanged(password)
          : ConfirmPasswordChanged(password)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle:
            textTheme.bodyLarge?.copyWith(color: AppColors.hintTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIconColor: Colors.black,
        suffixIcon: IconButton(
          icon: Icon(
            context.watch<AuthBloc>().isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: () {
            context.read<AuthBloc>().add(TogglePasswordVisibility());
          },
        ),
      ),
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.lightTextColor,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  TextFormField _phoneNumInputField(BuildContext context, TextTheme textTheme) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      cursorColor: Colors.black,
      onChanged: (phoneNumber) =>
          context.read<AuthBloc>().add(PhoneNumberChanged(phoneNumber)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: '08xxxxxxxxxx',
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

  TextFormField _textInputField(BuildContext context, TextTheme textTheme,
      String hintText, TextInputEvent event) {
    return TextFormField(
      cursorColor: Colors.black,
      onChanged: (textInput) => context.read<AuthBloc>().add(switch (event) {
            TextInputEvent.fullname => FullNameChanged(textInput),
            TextInputEvent.username => UsernameChanged(textInput),
          }),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
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

  SliverAppBar _sliverAPpBSliverAppBar(
      BuildContext context, TextTheme textTheme) {
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
