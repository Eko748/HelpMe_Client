part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<dynamic> get props => [];
}

class FetchProfile extends ProfileEvent {}

class ProfileDispose extends ProfileEvent {}

class ProfileStart extends ProfileEvent {}

class NewFullnameChanged extends ProfileEvent {
  final String fullname;

  const NewFullnameChanged({required this.fullname});

  @override
  List get props => [fullname];
}

class NewUsernameChanged extends ProfileEvent {
  final String username;

  const NewUsernameChanged({required this.username});

  @override
  List get props => [username];
}

class NewPhoneNumberChanged extends ProfileEvent {
  final String phoneNumber;

  const NewPhoneNumberChanged({required this.phoneNumber});

  @override
  List get props => [phoneNumber];
}

class CameraCapture extends ProfileEvent {}

class GalleryImagePicker extends ProfileEvent {}

class EditProfileSubmitted extends ProfileEvent {}

class ProfileIsIdle extends ProfileEvent {}

class EditPasswordSubmitted extends ProfileEvent {}

class OldPasswordChanged extends ProfileEvent {
  final String oldPassword;

  const OldPasswordChanged({required this.oldPassword});

  @override
  List get props => [oldPassword];
}

class NewPasswordChanged extends ProfileEvent {
  final String newPassword;

  const NewPasswordChanged({required this.newPassword});

  @override
  List get props => [newPassword];
}

class NewConfirmPasswordChanged extends ProfileEvent {
  final String newConfirmPassword;

  const NewConfirmPasswordChanged({required this.newConfirmPassword});

  @override
  List get props => [newConfirmPassword];
}

class RequestOTP extends ProfileEvent {}

class VerifyOTP extends ProfileEvent {}

class OTPCodeChanged extends ProfileEvent {
  final String code;

  const OTPCodeChanged({required this.code});

  @override
  List get props => [code];
}
