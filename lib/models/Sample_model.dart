import 'package:flutter/foundation.dart';
import 'sampling_serie_model.dart'; // اطمینان حاصل کنید که این فایل وجود دارد

@immutable
class Sample {
  /// شناسه منحصر به فرد نمونه
  final int id;

  /// تاریخ نمونه‌گیری
  final DateTime date;

  /// نوع آزمون (مثلا: فشاری، کششی)
  final String testType;

  /// حجم نمونه‌برداری
  final String samplingVolume;

  /// عیار سیمان
  final String cementGrade;

  /// رده بتن (مثلا: فونداسیون، ستون)
  final String category;

  /// وضعیت جوی
  final String weatherCondition;

  /// نام کارخانه بتن
  final String concreteFactory;

  /// شناسه پروژه مرتبط
  final int projectId;

  /// لیستی از سری‌های نمونه‌گیری
  final List<SamplingSerie> series;

  const Sample({
    required this.id,
    required this.date,
    required this.testType,
    required this.samplingVolume,
    required this.cementGrade,
    required this.category,
    required this.weatherCondition,
    required this.concreteFactory,
    required this.projectId,
    this.series = const [],
  });

  /// متد copyWith برای کپی کردن آبجکت با تغییر برخی مقادیر
  Sample copyWith({
    int? id,
    DateTime? date,
    String? testType,
    String? samplingVolume,
    String? cementGrade,
    String? category,
    String? weatherCondition,
    String? concreteFactory,
    int? projectId,
    List<SamplingSerie>? series,
  }) {
    return Sample(
      id: id ?? this.id,
      date: date ?? this.date,
      testType: testType ?? this.testType,
      samplingVolume: samplingVolume ?? this.samplingVolume,
      cementGrade: cementGrade ?? this.cementGrade,
      category: category ?? this.category,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      concreteFactory: concreteFactory ?? this.concreteFactory,
      projectId: projectId ?? this.projectId,
      series: series ?? this.series,
    );
  }

  /// تبدیل آبجکت به جیسان (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'test_type': testType,
      'sampling_volume': samplingVolume,
      'cement_grade': cementGrade,
      'category': category,
      'weather_condition': weatherCondition,
      'concrete_factory': concreteFactory,
      'project': projectId,
      'series': series.map((s) => s.toJson()).toList(),
    };
  }

  /// ساخت آبجکت از روی جیسان (Map)
  factory Sample.fromJson(Map<String, dynamic> json) {
    return Sample(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      testType: json['test_type'] as String,
      samplingVolume: json['sampling_volume'] as String,
      cementGrade: json['cement_grade'] as String,
      category: json['category'] as String,
      weatherCondition: json['weather_condition'] as String,
      concreteFactory: json['concrete_factory'] as String,
      projectId: json['project'] as int,
      series:
          (json['series'] as List<dynamic>)
              .map((s) => SamplingSerie.fromJson(s as Map<String, dynamic>))
              .toList(),
    );
  }
}
