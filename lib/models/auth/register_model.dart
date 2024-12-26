import 'package:image_picker/image_picker.dart';

class RegisterModel {
  final String? fullName;
  final String? username;
  final String? phoneNumber;
  final String? password;
  final String? passwordConfirmation;
  final XFile? imageProfile;
  final String role;
  final String? fcmToken;

  RegisterModel({
    required this.fullName,
    required this.username,
    required this.phoneNumber,
    required this.password,
    required this.passwordConfirmation,
    this.imageProfile,
    required this.role,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'username': username,
      'phone_number': phoneNumber,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'image_profile': imageProfile,
      'role': role,
      'fcm_token': fcmToken,
    };
  }
}
