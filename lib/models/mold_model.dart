import 'package:flutter/foundation.dart';

@immutable

class Mold {
  /// شناسه منحصر به فرد قالب
  final String id;

  /// عمر قالب به روز
  final int ageInDays;

  /// جرم قالب
  final double mass;

  /// بار گسیختگی یا نیرویی که باعث شکستن قالب می‌شود
  final double breakingLoad;

  /// زمانی که این دیتا در سیستم ثبت شده است
  final DateTime createdAt;

  /// زمانی که کار مربوط به قالب انجام شده است (می‌تواند خالی باشد)
  final DateTime? completedAt;

  /// آخرین مهلت (ددلاین)
  final DateTime deadline;

  /// شناسه یا نام نمونه قالب
  final String sampleIdentifier;

  /// یک مپ برای ذخیره دیتاهای اضافی و متفرقه
  final Map<String, dynamic> extraData;

  const Mold({
    required this.id,
    required this.ageInDays,
    required this.mass,
    required this.breakingLoad,
    required this.createdAt,
    this.completedAt,
    required this.deadline,
    required this.sampleIdentifier,
    this.extraData = const {},
  });

  /// متدی برای تبدیل آبجکت به جیسان (Map) برای ذخیره در دیتابیس
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ageInDays': ageInDays,
      'mass': mass,
      'breakingLoad': breakingLoad,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'sampleIdentifier': sampleIdentifier,
      'extraData': extraData,
    };
  }

  /// یک Factory constructor برای ساخت آبجکت از روی جیسان (Map)
  factory Mold.fromJson(Map<String, dynamic> json) {
    return Mold(
      id: json['id'] as String,
      ageInDays: json['ageInDays'] as int,
      mass: (json['mass'] as num).toDouble(),
      breakingLoad: (json['breakingLoad'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      deadline: DateTime.parse(json['deadline'] as String),
      sampleIdentifier: json['sampleIdentifier'] as String,
      extraData: json['extraData'] as Map<String, dynamic>? ?? const {},
    );
  }
}
