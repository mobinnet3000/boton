import 'package:flutter/material.dart';

@immutable
class Mold {
  final int id;
  final int ageInDays;
  final double mass;
  final double breakingLoad;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime deadline;
  final String sampleIdentifier;
  final Map<String, dynamic> extraData;
  final int seriesId;
  final bool isDone; 

  const Mold({
    required this.id,
    required this.ageInDays,
    required this.mass,
    required this.breakingLoad,
    required this.createdAt,
    this.completedAt,
    required this.deadline,
    required this.sampleIdentifier,
    required this.extraData,
    required this.seriesId,
    required this.isDone,
  });

  /// متدی برای ساخت یک نمونه Mold از داده‌های JSON (معمولاً از سرور دریافت می‌شود)
  factory Mold.fromJson(Map<String, dynamic> json) {
    return Mold(
      id: json['id'] as int,
      ageInDays: json['age_in_days'] as int,
      mass: (json['mass'] as num? ?? 0.0).toDouble(),
      breakingLoad: (json['breaking_load'] as num? ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt:
          json['completed_at'] == null
              ? null
              : DateTime.parse(json['completed_at'] as String),
      deadline: DateTime.parse(json['deadline'] as String),
      sampleIdentifier: json['sample_identifier'] as String? ?? '',
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
      seriesId: json['series'] as int,
      // وضعیت 'انجام شده' بر اساس وجود بار گسیختگی محاسبه می‌شود
      isDone: (json['breaking_load'] as num? ?? 0.0) != 0.0,
    );
  }

  /// ✅ (بخش اضافه شده) متدی برای تبدیل نمونه Mold به فرمت JSON (برای ارسال به سرور)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'series': seriesId,
      'age_in_days': ageInDays,
      'mass': mass,
      'breaking_load': breakingLoad,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'sample_identifier': sampleIdentifier,
      'extra_data': extraData,
    };
  }

  /// ✅ (بخش اضافه شده) متدی برای کپی کردن یک نمونه با تغییر برخی فیلدها
  /// این متد در مدیریت state بسیار کاربردی است.
  Mold copyWith({
    int? id,
    int? ageInDays,
    double? mass,
    double? breakingLoad,
    DateTime? createdAt,
    // برای nullable ها، باید راهی برای پاس دادن null صریح داشته باشیم
    // اما برای سادگی فعلا از این روش استفاده می‌کنیم.
    DateTime? completedAt,
    DateTime? deadline,
    String? sampleIdentifier,
    Map<String, dynamic>? extraData,
    int? seriesId,
    bool? isDone,
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
      isDone: isDone ?? this.isDone,
    );
  }
}