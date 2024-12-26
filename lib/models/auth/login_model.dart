class LoginModel {
  final String username;
  final String password;
  final String? fcmToken;

  LoginModel({
    required this.username,
    required this.password,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'fcm_token': fcmToken,
    };
  }
}
