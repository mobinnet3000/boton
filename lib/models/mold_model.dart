import 'package:flutter/foundation.dart';

@immutable
class Mold {
  /// شناسه منحصر به فرد قالب
  final int id;

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

  /// شناسه سری نمونه گیری والد
  final int seriesId;

  const Mold({
    required this.id,
    required this.ageInDays,
    required this.mass,
    required this.breakingLoad,
    required this.createdAt,
    this.completedAt,
    required this.deadline,
    required this.sampleIdentifier,
    required this.seriesId,
    this.extraData = const {},
  });

  /// متدی برای کپی کردن آبجکت با تغییر برخی مقادیر
  Mold copyWith({
    int? id,
    int? ageInDays,
    double? mass,
    double? breakingLoad,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? deadline,
    String? sampleIdentifier,
    Map<String, dynamic>? extraData,
    int? seriesId,
  }) {
    return Mold(
      id: id ?? this.id,
      ageInDays: ageInDays ?? this.ageInDays,
      mass: mass ?? this.mass,
      breakingLoad: breakingLoad ?? this.breakingLoad,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      deadline: deadline ?? this.deadline,
      sampleIdentifier: sampleIdentifier ?? this.sampleIdentifier,
      extraData: extraData ?? this.extraData,
      seriesId: seriesId ?? this.seriesId,
    );
  }

  /// متدی برای تبدیل آبجکت به جیسان (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'age_in_days': ageInDays,
      'mass': mass,
      'breaking_load': breakingLoad,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'sample_identifier': sampleIdentifier,
      'extra_data': extraData,
      'series': seriesId,
    };
  }

  /// یک Factory constructor برای ساخت آبجکت از روی جیسان (Map)
  factory Mold.fromJson(Map<String, dynamic> json) {
    return Mold(
      id: json['id'] as int,
      ageInDays: json['age_in_days'] as int,
      mass: (json['mass'] as num).toDouble(),
      breakingLoad: (json['breaking_load'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt:
          json['completed_at'] != null
              ? DateTime.parse(json['completed_at'] as String)
              : null,
      deadline: DateTime.parse(json['deadline'] as String),
      sampleIdentifier: json['sample_identifier'] as String,
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
      seriesId: json['series'] as int,
    );
  }
}
