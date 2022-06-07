import 'dart:convert';

class LoginResponse {
  LoginResponse({
    this.userId,
    this.username,
    this.email,
    this.sessionToken,
  });

  String? userId;
  String? username;
  String? email;
  String? sessionToken;

  factory LoginResponse.fromRawJson(String str) => LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    userId: json["objectId"],
    username: json["username"],
    email: json["email"],
    sessionToken: json["sessionToken"],
  );

  Map<String, dynamic> toJson() => {
    "sessionToken": sessionToken,
    "username": username,
    "email": email,
    "objectId": userId,
  };
}