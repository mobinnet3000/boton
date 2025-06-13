import 'package:flutter/foundation.dart';

@immutable
class User {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String labName;
  final String labPhoneNumber;
  final String labMobileNumber;
  final String labAddress;
  final String province;
  final String city;
  final String? telegramId;

  const User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.labName,
    required this.labPhoneNumber,
    required this.labMobileNumber,
    required this.labAddress,
    required this.province,
    required this.city,
    this.telegramId,
  });

  String get fullName => '$firstName $lastName';

  // متد copyWith بدون تغییر باقی می‌ماند
  User copyWith({
    int? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? labName,
    String? labPhoneNumber,
    String? labMobileNumber,
    String? labAddress,
    String? province,
    String? city,
    String? telegramId,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      labName: labName ?? this.labName,
      labPhoneNumber: labPhoneNumber ?? this.labPhoneNumber,
      labMobileNumber: labMobileNumber ?? this.labMobileNumber,
      labAddress: labAddress ?? this.labAddress,
      province: province ?? this.province,
      city: city ?? this.city,
      telegramId: telegramId ?? this.telegramId,
    );
  }

  /// *** متد اصلاح شده اینجاست ***
  factory User.fromJson(Map<String, dynamic> json) {
    // 'json' در اینجا خود آبجکت user است.
    // دیگر نیازی به جستجوی json['user'] نیست.

    final labProfileData = json['lab_profile'] as Map<String, dynamic>?;

    if (labProfileData == null) {
      // اگر پروفایل آزمایشگاه وجود نداشته باشد، یک خطای واضح‌تر می‌دهیم
      throw const FormatException(
        'اطلاعات "lab_profile" در داده‌های کاربر یافت نشد.',
      );
    }

    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      labName: labProfileData['lab_name'] as String,
      labPhoneNumber: labProfileData['lab_phone_number'] as String,
      labMobileNumber: labProfileData['lab_mobile_number'] as String,
      labAddress: labProfileData['lab_address'] as String,
      province: labProfileData['province'] as String,
      city: labProfileData['city'] as String,
      telegramId: labProfileData['telegram_id'] as String?,
    );
  }

  // متد toJson بدون تغییر باقی می‌ماند
  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'lab_profile': {
          'lab_name': labName,
          'lab_phone_number': labPhoneNumber,
          'lab_mobile_number': labMobileNumber,
          'lab_address': labAddress,
          'province': province,
          'city': city,
          'telegram_id': telegramId,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'user': id,
        },
      },
    };
  }
}
