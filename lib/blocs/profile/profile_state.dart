part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileIdle extends ProfileState {}

final class ProfileDisposed extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final DataUser data;

  const ProfileLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

final class ProfileError extends ProfileState {
  final String errorMessage;

  const ProfileError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class ProfileEdited extends ProfileState {
  final String message;
  final UserModel data;

  const ProfileEdited({required this.message, required this.data});

  @override
  List<Object> get props => [message, data];
}

final class EditProfileError extends ProfileState {
  final String message;

  const EditProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class EditPasswordLoaded extends ProfileState {
  final String message;

  const EditPasswordLoaded({required this.message});

  @override
  List<Object> get props => [message];
}

final class EditPasswordError extends ProfileState {
  final String errorMessage;

  const EditPasswordError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class ImagePicked extends ProfileState {
  final XFile? pickedImage;

  const ImagePicked({required this.pickedImage});

  @override
  List<Object?> get props => [pickedImage];
}

final class OTPRequested extends ProfileState {
  final String message;

  const OTPRequested({required this.message});

  @override
  List<Object?> get props => [message];
}

final class OTPError extends ProfileState {
  final String errorMessage;

  const OTPError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class OTPLoading extends ProfileState {}

final class OTPVerified extends ProfileState {
  final String message;

  const OTPVerified({required this.message});

  @override
  List<Object?> get props => [message];
}
