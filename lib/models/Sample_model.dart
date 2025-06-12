import 'package:flutter/foundation.dart';
import 'sampling_serie_model.dart'; // فایل مدل SamplingSerie را اینجا ایمپورت کنید

@immutable
class Sample {
  /// شناسه منحصر به فرد نمونه
  final String id;

  /// تاریخ نمونه‌گیری
  final DateTime date;

  /// **نوع آزمون (مثلا: فشاری، کششی)**
  final String testType; // <<-- فیلد جدید

  /// حجم نمونه‌برداری
  final String samplingVolume;

  /// عیار سیمان
  final String cementGrade;

  /// رده بتن
  final String category;

  /// وضعیت جوی
  final String weatherCondition;

  /// نام کارخانه بتن
  final String concreteFactory;

  /// لیستی از سری‌های نمونه‌گیری
  final List<SamplingSerie> series;

  const Sample({
    required this.id,
    required this.date,
    required this.testType, // <<-- اضافه شده به کانستراکتور
    required this.samplingVolume,
    required this.cementGrade,
    required this.category,
    required this.weatherCondition,
    required this.concreteFactory,
    this.series = const [],
  });

  /// تبدیل آبجکت به جیسان (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'testType': testType, // <<-- اضافه شده به جیسان
      'samplingVolume': samplingVolume,
      'cementGrade': cementGrade,
      'category': category,
      'weatherCondition': weatherCondition,
      'concreteFactory': concreteFactory,
      'series': series.map((s) => s.toJson()).toList(),
    };
  }

  /// ساخت آبجکت از روی جیسان (Map)
  factory Sample.fromJson(Map<String, dynamic> json) {
    return Sample(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      testType: json['testType'] as String, // <<-- اضافه شده از جیسان
      samplingVolume: json['samplingVolume'] as String,
      cementGrade: json['cementGrade'] as String,
      category: json['category'] as String,
      weatherCondition: json['weatherCondition'] as String,
      concreteFactory: json['concreteFactory'] as String,
      series: (json['series'] as List<dynamic>)
          .map((s) => SamplingSerie.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}
