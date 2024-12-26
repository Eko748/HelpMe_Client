import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/app_colors.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../widgets/custom_dialog.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final textTheme = appTheme.textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
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
                    Text(
                      'Masuk',
                      style: textTheme.headlineLarge?.copyWith(
                          color: AppColors.darkTextColor,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 20),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is SignInLoaded) {
                          _stateLoaded(context);
                        } else if (state is AuthError) {
                          _stateError(context, state);
                        } else if (state is PasswordToggled ||
                            state is RememberMeToggled) {
                          context.read<AuthBloc>().add(AuthIsIdle());
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _usernameInputField(context, textTheme),
                            const SizedBox(height: 10),
                            Text(
                              'Password',
                              style: textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _passwordInputField(state, context, textTheme),
                            const SizedBox(height: 10),
                            Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                _forgetPassword(context, textTheme),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (state is AuthLoading) ...[
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                              const SizedBox(height: 10),
                            ] else ...[
                              _signInButton(textTheme, context, state),
                            ],
                            const SizedBox(height: 10),
                            _notHaveAccountSection(textTheme, context),
                            const SizedBox(height: 20),
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

  Widget _notHaveAccountSection(TextTheme textTheme, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AuthBloc>().add(ResetAuthState());
        context.goNamed('signUpPage');
      },
      child: Center(
        child: Text.rich(
          style: textTheme.bodyLarge?.copyWith(
              color: AppColors.darkTextColor, fontWeight: FontWeight.normal),
          TextSpan(
            text: 'Belum memiliki akun? ',
            children: [
              TextSpan(
                text: 'Daftar',
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

  GestureDetector _forgetPassword(BuildContext context, TextTheme textTheme) {
    return GestureDetector(
      onTap: () {
        context.read<AuthBloc>().add(AuthIsIdle());
        context.pushNamed('forgetPasswordPage');
      },
      child: Text(
        'Lupa kata sandi?',
        style: textTheme.bodyLarge?.copyWith(
          color: AppColors.darkTextColor,
          fontWeight: FontWeight.normal,
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
    context.read<AuthBloc>().add(ResetAuthState());
    context.goNamed('homePage');
  }

  SizedBox _signInButton(
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
          'Sign In',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.lightTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          context.read<AuthBloc>().add(SignInSubmitted());
        },
      ),
    );
  }

  TextFormField _passwordInputField(
      AuthState state, BuildContext context, TextTheme textTheme) {
    return TextFormField(
      obscureText: !context.watch<AuthBloc>().isPasswordVisible,
      onChanged: (password) =>
          context.read<AuthBloc>().add(PasswordChanged(password)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Masukan password',
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

  TextFormField _usernameInputField(BuildContext context, TextTheme textTheme) {
    return TextFormField(
      onChanged: (username) =>
          context.read<AuthBloc>().add(UsernameChanged(username)),
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
