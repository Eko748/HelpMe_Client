import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/auth/auth_response_model.dart';
import '../../models/auth/login_model.dart';
import '../../services/api/api_controller.dart';
import '../../services/firebase/firebase_api.dart';
import '../../utils/manage_token.dart';
import '../../models/auth/register_model.dart';
import '../../services/api/api_helper.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String fullName = '';
  String username = '';
  String password = '';
  String passwordConfirmation = '';
  String phoneNumber = '';
  final role = 'client';
  bool isPasswordVisible = false;

  AuthBloc() : super(AuthInitial()) {
    on<FullNameChanged>(
      (event, emit) => fullName = event.fullName.trim(),
    );

    on<UsernameChanged>(
      (event, emit) => username = event.username.trim(),
    );

    on<PhoneNumberChanged>(
      (event, emit) => phoneNumber = event.phoneNumber.trim(),
    );

    on<PasswordChanged>((event, emit) => password = event.password.trim());

    on<ConfirmPasswordChanged>(
      (event, emit) => passwordConfirmation = event.confirmPassword.trim(),
    );

    on<TogglePasswordVisibility>((event, emit) {
      isPasswordVisible = !isPasswordVisible;
      emit(PasswordToggled());
    });

    on<SignInSubmitted>(_onSignInSubmitted);

    on<SignOutSubmitted>(_onSignOutSubmitted);

    on<SignUpSubmitted>(_onSignUpSubmitted);

    on<ForgetPasswordSubmitted>(_onForgetPasswordSubmitted);

    on<AuthIsIdle>((event, emit) => emit(AuthIdle()));

    on<ResetAuthState>((event, emit) {
      fullName = '';
      username = '';
      password = '';
      passwordConfirmation = '';
      phoneNumber = '';
      isPasswordVisible = false;
      emit(AuthInitial());
    });
  }

  FutureOr<void> _onForgetPasswordSubmitted(event, emit) async {
    emit(AuthLoading());
    if (phoneNumber.isEmpty) {
      emit(const ForgetPasswordError(message: 'Isi nomor telpon'));
    } else if (!phoneNumber.startsWith('08')) {
      emit(const ForgetPasswordError(
          message: 'Isi dengan nomor telpon yang valid'));
    } else {
      final response = await ApiHelper.forgotPassword(phoneNumber);
      if (response.error != null) {
        var message = response.error?.message ?? response.error?.error;
        message ??= 'Nomor yang anda masukan tidak terdaftar';
        emit(ForgetPasswordLoaded(message: message.toString()));
      } else {
        emit(const ForgetPasswordError(message: 'Unknown error occured'));
      }
    }
  }

  Future<void> _onSignOutSubmitted(
    SignOutSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final signOutResponse = await ApiHelper.authLogout();
    if (signOutResponse is ApiErrorResponseModel) {
      String? message =
          signOutResponse.error?.message ?? signOutResponse.error?.error;
      if (!message.toString().trim().toLowerCase().contains('invalid') ||
          !message.toString().trim().toLowerCase().contains('unauthorized')) {
        message = signOutResponse.toString();
      }
      emit(AuthError(message: message.toString()));
    } else {
      signOutResponse as AuthResponseModel;
      ApiController.token = null;
      FirebaseMessagingApi.fcmToken = null;
      ManageAuthToken.deleteToken();
      ManageFCMToken.deleteToken();
      await DefaultCacheManager().emptyCache();
      emit(SignOutLoaded(
        message: signOutResponse.message ?? 'Failed to load message',
      ));
    }
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (username.isEmpty) {
      emit(
        const AuthError(
          message: 'Isi username',
        ),
      );
    } else if (password.length < 8) {
      emit(
        const AuthError(
          message: 'Password minimal 8 karakter',
        ),
      );
    } else {
      emit(AuthLoading());
      String? fcmToken = await ManageFCMToken.readToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        fcmToken = await FirebaseMessagingApi.getFCMToken();
      }
      final loginRequest = LoginModel(
        username: username,
        password: password,
        fcmToken: fcmToken,
      );
      final signInResponse = await ApiHelper.authLogin(loginRequest);
      if (signInResponse is AuthResponseModel) {
        final authMessage = signInResponse.message.toString();
        final authToken = signInResponse.token;
        if (authToken != null) {
          ApiController.token = authToken;
          FirebaseMessagingApi.fcmToken = fcmToken;
          ManageAuthToken.writeToken();
          ManageFCMToken.writeToken(fcmToken);
          emit(
            SignInLoaded(
              message: authMessage.toString(),
              token: authToken,
            ),
          );
        }
      } else if (signInResponse is ApiErrorResponseModel) {
        String? message =
            signInResponse.error?.error ?? signInResponse.error?.message;
        if (message.toString().trim().toLowerCase().contains('invalid') ||
            message.toString().trim().toLowerCase().contains('unauthorized')) {
          message = 'Username atau password salah';
        }
        emit(AuthError(message: message.toString()));
      }
    }
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (fullName.isEmpty) {
      emit(
        const AuthError(message: 'Isi nama lengkap'),
      );
    } else if (phoneNumber.isEmpty) {
      emit(
        const AuthError(message: 'Isi nomor telepon'),
      );
    } else if (!phoneNumber.startsWith('08')) {
      emit(
        const AuthError(message: 'Isi dengan nomor telpon yang valid'),
      );
    } else if (username.isEmpty) {
      emit(
        const AuthError(message: 'Isi username'),
      );
    } else if (password.isEmpty || password.length < 8) {
      emit(
        const AuthError(message: 'Password minimal 8 karakter'),
      );
    } else if (passwordConfirmation.isEmpty) {
      emit(
        const AuthError(message: 'Isi konfirmasi password'),
      );
    } else if (passwordConfirmation != password) {
      emit(
        const AuthError(message: 'Konfirmasi password salah'),
      );
    } else {
      emit(AuthLoading());
      String? fcmToken = await ManageFCMToken.readToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        fcmToken = await FirebaseMessagingApi.getFCMToken();
      } else {
        emit(
          const AuthError(message: 'Gagal memuat FCM token'),
        );
        return;
      }
      final signUpModel = RegisterModel(
        fullName: fullName,
        username: username,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phoneNumber: phoneNumber,
        role: role,
        fcmToken: fcmToken,
      );
      final signUpResponse = await ApiHelper.authRegister(signUpModel);
      if (signUpResponse is AuthResponseModel) {
        final authMessage = signUpResponse.message.toString();
        final authToken = signUpResponse.token;
        if (authToken != null) {
          ApiController.token = authToken;
          FirebaseMessagingApi.fcmToken = fcmToken;
          ManageAuthToken.writeToken();
          ManageFCMToken.writeToken(fcmToken);
          emit(
            SignUpLoaded(
              message: authMessage.toString(),
              token: authToken,
            ),
          );
        }
      } else if (signUpResponse is ApiErrorResponseModel) {
        String? message =
            signUpResponse.error?.error ?? signUpResponse.error?.message;
        if (message == null || message.isEmpty) {
          message = signUpResponse.toString();
        }
        emit(AuthError(message: message.toString()));
      }
    }
  }
}
