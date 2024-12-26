import 'package:flutter/foundation.dart';

@immutable
class MessageErrorModel {
  final String? error;
  final String? message;
  final List<dynamic>? fullname;
  final List<dynamic>? username;
  final List<dynamic>? phoneNumber;
  final List<dynamic>? password;
  final List<dynamic>? role;
  final List<dynamic>? newPassword;
  final List<dynamic>? verificationCode;
  final List<dynamic>? attachment0;
  final List<dynamic>? attachment1;

  const MessageErrorModel({
    this.error,
    this.message,
    this.fullname,
    this.username,
    this.phoneNumber,
    this.password,
    this.role,
    this.newPassword,
    this.verificationCode,
    this.attachment0,
    this.attachment1,
  });

  @override
  String toString() {
    String str = '';
    if (error != null) {
      str += '$error\n';
    }
    if (message != null) {
      str += '$message\n';
    }
    if (fullname != null) {
      str += '$fullname\n';
    }
    if (username != null) {
      str += '$username\n';
    }
    if (phoneNumber != null) {
      str += '$phoneNumber\n';
    }
    if (password != null) {
      str += '$password\n';
    }
    if (role != null) {
      str += '$role\n';
    }
    if (newPassword != null) {
      str += '$newPassword\n';
    }
    if (verificationCode != null) {
      str += '$verificationCode\n';
    }
    if (attachment0 != null) {
      str += '$attachment0\n';
    }
    if (attachment1 != null) {
      str += '$attachment1\n';
    }
    return str.trim();
  }

  factory MessageErrorModel.fromMap(Map<String, dynamic> data) =>
      MessageErrorModel(
        error: data['error'] as String?,
        message: data['message'] as String?,
        fullname: data['full_name'] as List<dynamic>?,
        username: data['username'] as List<dynamic>?,
        phoneNumber: data['phone_number'] as List<dynamic>?,
        password: data['password'] as List<dynamic>?,
        role: data['role'] as List<dynamic>?,
        newPassword: data['new_password'] as List<dynamic>?,
        verificationCode: data['verification_code'] as List<dynamic>?,
        attachment0: data['attachments.0'] as List<dynamic>?,
        attachment1: data['attachments.1'] as List<dynamic>?,
      );
}
