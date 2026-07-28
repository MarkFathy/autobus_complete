// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final UserData user;
  final String? token;
  final bool? hasCreatedFund;
  final String? tokenType;

  UserModel({
    required this.user,
    required this.token,
    required this.hasCreatedFund,
    required this.tokenType,
  });

  UserModel copyWith({
    UserData? user,
    String? token,
    bool? hasCreatedFund,
    String? tokenType,
  }) => UserModel(
    user: user ?? this.user,
    token: token ?? this.token,
    hasCreatedFund: hasCreatedFund ?? this.hasCreatedFund,
    tokenType: tokenType ?? this.tokenType,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    user: UserData.fromJson(json["beneficiary"]),
    token: json["token"],
    hasCreatedFund: json["has_created_fund"],
    tokenType: json["token_type"],
  );

  Map<String, dynamic> toJson() => {
    "beneficiary": user.toJson(),
    "token": token,
    "has_created_fund": hasCreatedFund,
    "token_type": tokenType,
  };
}

class UserData {
  final int id;
  final String phone;
  final String? firstName;
  final String? lastName;
  final String? otp;
  final dynamic otpVerifiedAt;
  final String? otpExpiresAt;
  final String? email;
  final String? referCode;
  final String? referCodeFrom;
  final String? referralCount;
  final String? referralEarnings;
  final String? maxReferrals;
  final String? birthDate;
  final String? active;
  final dynamic numberOfLogin;
  final dynamic createdAt;
  final dynamic updatedAt;
  final String? deletedAt;
  final String? countryId;
  final String? cityId;
  final String? gender;

  UserData({
    required this.id,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.otp,
    required this.otpVerifiedAt,
    required this.otpExpiresAt,
    required this.email,
    required this.referCode,
    required this.referCodeFrom,
    required this.referralCount,
    required this.referralEarnings,
    required this.maxReferrals,
    required this.birthDate,
    required this.active,
    required this.numberOfLogin,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.countryId,
    required this.cityId,
    required this.gender,
  });

  UserData copyWith({
    int? id,
    String? phone,
    String? firstName,
    String? lastName,
    String? otp,
    dynamic otpVerifiedAt,
    String? otpExpiresAt,
    String? email,
    String? referCode,
    String? referCodeFrom,
    String? referralCount,
    String? referralEarnings,
    String? maxReferrals,
    String? birthDate,
    String? active,
    String? numberOfLogin,
    dynamic createdAt,
    dynamic updatedAt,
    String? deletedAt,
    String? countryId,
    String? cityId,
    String? gender,
  }) => UserData(
    id: id ?? this.id,
    phone: phone ?? this.phone,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    otp: otp ?? this.otp,
    otpVerifiedAt: otpVerifiedAt ?? this.otpVerifiedAt,
    otpExpiresAt: otpExpiresAt ?? this.otpExpiresAt,
    email: email ?? this.email,
    referCode: referCode ?? this.referCode,
    referCodeFrom: referCodeFrom ?? this.referCodeFrom,
    referralCount: referralCount ?? this.referralCount,
    referralEarnings: referralEarnings ?? this.referralEarnings,
    maxReferrals: maxReferrals ?? this.maxReferrals,
    birthDate: birthDate ?? this.birthDate,
    active: active ?? this.active,
    numberOfLogin: numberOfLogin ?? this.numberOfLogin,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
    countryId: countryId ?? this.countryId,
    cityId: cityId ?? this.cityId,
    gender: gender ?? this.gender,
  );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    phone: json["phone"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    otp: json["otp"],
    otpVerifiedAt: json["otp_verified_at"],
    otpExpiresAt: json["otp_expires_at"],
    email: json["email"],
    referCode: json["refer_code"],
    referCodeFrom: json["refer_code_from"],
    referralCount: json["referral_count"],
    referralEarnings: json["referral_earnings"],
    maxReferrals: json["max_referrals"],
    birthDate: json["birth_date"],
    active: json["active"],
    numberOfLogin: json["number_of_login"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
    countryId: json["country_id"],
    cityId: json["city_id"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone": phone,
    "first_name": firstName,
    "last_name": lastName,
    "otp": otp,
    "otp_verified_at": otpVerifiedAt,
    "otp_expires_at": otpExpiresAt,
    "email": email,
    "refer_code": referCode,
    "refer_code_from": referCodeFrom,
    "referral_count": referralCount,
    "referral_earnings": referralEarnings,
    "max_referrals": maxReferrals,
    "birth_date": birthDate,
    "active": active,
    "number_of_login": numberOfLogin,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
    "country_id": countryId,
    "city_id": cityId,
    "gender": gender,
  };
}
