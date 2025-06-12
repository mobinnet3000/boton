import 'package:flutter/foundation.dart';

@immutable
class User {
  /// شناسه منحصر به فرد کاربر
  final String id;
  
  /// شماره تماس کاربر
  final String phoneNumber;
  
  /// نام
  final String firstName;
  
  /// نام خانوادگی
  final String lastName;
  
  /// نام آزمایشگاه
  final String labName;
  
  /// شماره تلفن ثابت آزمایشگاه
  final String labPhoneNumber;
  
  /// شماره موبایل آزمایشگاه
  final String labMobileNumber;
  
  /// آدرس آزمایشگاه
  final String labAddress;
  
  /// استان
  final String province;
  
  /// شهر
  final String city;
  
  /// آیدی تلگرام (می‌تواند خالی باشد)
  final String? telegramId;

  const User({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.labName,
    required this.labPhoneNumber,
    required this.labMobileNumber,
    required this.labAddress,
    required this.province,
    required this.city,
    this.telegramId,
  });
  
  /// یک getter برای نمایش نام کامل
  String get fullName => '$firstName $lastName';

  /// متد copyWith برای کپی کردن آبجکت با تغییر برخی مقادیر
  User copyWith({
    String? id,
    String? phoneNumber,
    String? firstName,
    String? lastName,
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
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      labName: labName ?? this.labName,
      labPhoneNumber: labPhoneNumber ?? this.labPhoneNumber,
      labMobileNumber: labMobileNumber ?? this.labMobileNumber,
      labAddress: labAddress ?? this.labAddress,
      province: province ?? this.province,
      city: city ?? this.city,
      telegramId: telegramId ?? this.telegramId,
    );
  }

  /// تبدیل آبجکت به جیسان (Map) برای ذخیره‌سازی
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'labName': labName,
      'labPhoneNumber': labPhoneNumber,
      'labMobileNumber': labMobileNumber,
      'labAddress': labAddress,
      'province': province,
      'city': city,
      'telegramId': telegramId,
    };
  }

  /// ساخت آبجکت از روی جیسان (Map)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      labName: json['labName'] as String,
      labPhoneNumber: json['labPhoneNumber'] as String,
      labMobileNumber: json['labMobileNumber'] as String,
      labAddress: json['labAddress'] as String,
      province: json['province'] as String,
      city: json['city'] as String,
      telegramId: json['telegramId'] as String?,
    );
  }
}
