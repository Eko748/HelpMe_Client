import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/api_error_response/api_error_response_model.dart';
import '../../models/auth/user_model.dart';
import '../../services/api/api_helper.dart';
import '../../ui/pages/auth/verify_phone_number_page.dart';
import '../../utils/image_picker_util.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ImagePickerUtil imagePickerUtil;

  UserModel? profile;

  String? oldPassword;
  String? newPassword;
  String? newConfirmPassword;

  String? fullname;
  String? username;
  String? phoneNumber;
  XFile? imageProfile;

  String? codeOTP;
  StatusOTP statusOTP = StatusOTP.waiting;

  ProfileBloc({required this.imagePickerUtil}) : super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);

    on<ProfileIsIdle>((event, emit) => emit(ProfileIdle()));

    on<ProfileStart>((event, emit) => emit(ProfileInitial()));

    on<ProfileDispose>((event, emit) {
      profile = null;
      oldPassword = null;
      newPassword = null;
      newConfirmPassword = null;
      fullname = null;
      username = null;
      phoneNumber = null;
      imageProfile = null;
      codeOTP = null;
      statusOTP = StatusOTP.waiting;
      emit(ProfileDisposed());
    });

    on<EditProfileSubmitted>(_onEditProfileSubmitted);

    on<EditPasswordSubmitted>(_onEditPasswordSubmitted);

    on<OldPasswordChanged>(
      (event, emit) => oldPassword = event.oldPassword.trim(),
    );

    on<NewPasswordChanged>(
      (event, emit) => newPassword = event.newPassword.trim(),
    );

    on<NewConfirmPasswordChanged>(
      (event, emit) => newConfirmPassword = event.newConfirmPassword.trim(),
    );

    on<NewFullnameChanged>(
      (event, emit) => fullname = event.fullname.trim(),
    );

    on<NewUsernameChanged>(
      (event, emit) => username = event.username.trim(),
    );

    on<NewPhoneNumberChanged>(
      (event, emit) => phoneNumber = event.phoneNumber.trim(),
    );

    on<OTPCodeChanged>(
      (event, emit) => codeOTP = event.code.trim(),
    );

    on<CameraCapture>(_onCameraCapture);

    on<GalleryImagePicker>(_onGalleryImagePicker);

    on<RequestOTP>(_onRequestOTP);

    on<VerifyOTP>(_onVerifyOTP);
  }

  FutureOr<void> _onVerifyOTP(event, emit) async {
    emit(OTPLoading());
    if (codeOTP == null || codeOTP!.isEmpty) {
      emit(
        const ProfileError(errorMessage: 'Isi dengan kode OTP'),
      );
    } else {
      final response = await ApiHelper.verifyOTP(phoneNumber!, codeOTP!);
      if (response.error != null) {
        String? message = response.error?.message ?? response.error?.error;
        if (message == null || message.isEmpty) {
          message = response.toString();
        }
        emit(OTPVerified(
          message: message.toString(),
        ));
      } else {
        emit(const OTPError(errorMessage: 'Unknown error occured'));
      }
    }
  }

  FutureOr<void> _onRequestOTP(event, emit) async {
    emit(OTPLoading());
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      emit(
        const OTPError(errorMessage: 'Isi nomor telpon'),
      );
    } else if (!phoneNumber!.startsWith('08')) {
      emit(
        const OTPError(errorMessage: 'Isi dengan nomor telpon yang valid'),
      );
    } else {
      final response = await ApiHelper.requestOTP(phoneNumber!);
      if (response.error != null) {
        String? message = response.error?.message ?? response.error?.error;
        if (message == null || message.isEmpty) {
          message = response.toString();
        }
        emit(OTPRequested(
          message: message.toString(),
        ));
      } else {
        emit(const OTPError(errorMessage: 'Unknown error occured'));
      }
    }
  }

  FutureOr<void> _onGalleryImagePicker(event, emit) async {
    XFile? imagePicked = await imagePickerUtil.imageFromGallery();
    if (imagePicked != null) {
      imageProfile = imagePicked;
      emit(ImagePicked(pickedImage: imagePicked));
    } else {
      emit(ProfileIdle());
    }
  }

  FutureOr<void> _onCameraCapture(event, emit) async {
    XFile? imagePicked = await imagePickerUtil.cameraCapture();
    if (imagePicked != null) {
      imageProfile = imagePicked;
      emit(ImagePicked(pickedImage: imagePicked));
    } else {
      emit(ProfileIdle());
    }
  }

  FutureOr<void> _onEditPasswordSubmitted(event, emit) async {
    emit(ProfileLoading());
    if (oldPassword == null || oldPassword!.isEmpty) {
      emit(const EditPasswordError(errorMessage: 'Isi kata sandi lama'));
    } else if (oldPassword!.length < 8) {
      emit(const EditPasswordError(
          errorMessage: 'Kata sandi lama minimal 8 karakter'));
    } else if (newPassword == null || newPassword!.isEmpty) {
      emit(const EditPasswordError(errorMessage: 'Isi kata sandi baru'));
    } else if (newPassword!.length < 8) {
      emit(const EditPasswordError(
          errorMessage: 'Kata sandi baru minimal 8 karakter'));
    } else if (newConfirmPassword == null ||
        newConfirmPassword != newPassword) {
      emit(const EditPasswordError(errorMessage: 'Konfirmasi kata sandi baru'));
    } else {
      final response = await ApiHelper.changePassword(
          oldPassword!, newPassword!, newConfirmPassword!);
      if (response.error != null) {
        String? message = response.error?.message ?? response.error?.error;
        if (message == null || message.isEmpty) {
          message = response.toString();
        }
        emit(EditPasswordLoaded(
          message: message.toString(),
        ));
      } else {
        emit(const EditPasswordError(errorMessage: 'Unknown error occured'));
      }
    }
  }

  FutureOr<void> _onEditProfileSubmitted(event, emit) async {
    emit(ProfileLoading());
    if (fullname == null || fullname!.isEmpty) {
      emit(const EditProfileError(message: 'Isi nama lengkap'));
    } else if (fullname == null || username!.isEmpty) {
      emit(const EditProfileError(message: 'Isi username'));
    } else if (phoneNumber == null || phoneNumber!.isEmpty) {
      emit(
        const EditProfileError(message: 'Isi nomor telpon'),
      );
    } else if (!phoneNumber!.startsWith('08')) {
      emit(
        const EditProfileError(message: 'isi dengan nomor telpon yang valid'),
      );
    } else {
      MultipartFile? profileImage;
      if (imageProfile != null) {
        profileImage = await MultipartFile.fromFile(
          imageProfile!.path,
          filename: imageProfile!.name.split('/').last,
        );
      }
      final formData = FormData.fromMap({
        'full_name': fullname,
        'username': username,
        'phone_number': phoneNumber,
        if (profileImage != null) 'image_profile': profileImage,
      });
      final response = await ApiHelper.editProfile(formData);
      if (response is ApiErrorResponseModel) {
        String? message = response.error?.message ?? response.error?.error;
        if (message == null || message.isEmpty) {
          message = response.toString();
        }
        emit(EditProfileError(
          message: message.toString(),
        ));
      } else {
        emit(ProfileEdited(message: response.message, data: response.user));
      }
    }
  }

  FutureOr<void> _onFetchProfile(event, emit) async {
    emit(ProfileLoading());
    try {
      final response = await ApiHelper.getUserProfile();
      if (response is ApiErrorResponseModel) {
        emit(ProfileError(errorMessage: response.error!.error.toString()));
      } else {
        emit(ProfileLoaded(data: response));
      }
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }
}
