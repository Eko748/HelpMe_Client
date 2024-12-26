class DataUser {
  final UserModel user;

  DataUser({required this.user});

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        user: UserModel.fromModel(
          Map<String, dynamic>.from(json['user']),
        ),
      );
}

class EditUserResponse {
  final String message;
  final UserModel? user;

  EditUserResponse({required this.message, this.user});

  factory EditUserResponse.fromJson(Map<String, dynamic> json) =>
      EditUserResponse(
          message: json['message'],
          user: UserModel.fromModel(
            Map<String, dynamic>.from(json['user']),
          ));
}

class UserModel {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final String? username;
  final String? role;
  final int? isActive;
  final String? identifier;
  final String? imageProfile;
  final dynamic phoneNumberVerifiedAt;

  const UserModel({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.username,
    this.role,
    this.isActive,
    this.identifier,
    this.imageProfile,
    this.phoneNumberVerifiedAt,
  });

  factory UserModel.fromModel(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        fullName: json['full_name'],
        phoneNumber: json['phone_number'],
        username: json['username'],
        role: json['role'],
        isActive: json['is_active'],
        identifier: json['identifier'],
        imageProfile: json['image_profile'],
        phoneNumberVerifiedAt: json['phone_number_verified_at'],
      );
}
