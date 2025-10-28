// To parse this JSON data, do
//
//     final userInformation = userInformationFromJson(jsonString);

import 'dart:convert';

UserInformation userInformationFromJson(String str) => UserInformation.fromJson(json.decode(str));

String userInformationToJson(UserInformation data) => json.encode(data.toJson());

class UserInformation {
  bool success;
  String message;
  UserResult result;

  UserInformation({
    required this.success,
    required this.message,
    required this.result,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) => UserInformation(
    success: json["success"],
    message: json["message"],
    result: UserResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "result": result.toJson(),
  };
}

class UserResult {
  String id;
  String firstName;
  String lastName;
  dynamic profileImage;
  String email;

  UserResult({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.email,
  });

  factory UserResult.fromJson(Map<String, dynamic> json) => UserResult(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profileImage: json["profileImage"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
    "email": email,
  };
}
