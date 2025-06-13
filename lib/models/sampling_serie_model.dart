import 'package:boton/models/mold_model.dart'; // اطمینان حاصل کنید که این فایل وجود دارد
import 'package:flutter/foundation.dart';

@immutable
class SamplingSerie {
  /// شناسه منحصر به فرد برای سری نمونه‌گیری
  final int id;

  /// دمای بتن
  final double concreteTemperature;

  /// دمای محیط
  final double ambientTemperature;

  /// مقدار اسلامپ
  final double slump;

  /// محدوده (برای مثال محدوده اسلامپ)
  final String range;

  /// درصد هوا
  final double airPercentage;

  /// مشخص می‌کند که آیا افزودنی دارد یا خیر
  final bool hasAdditive;

  /// شناسه نمونه (Sample) والد
  final int sampleId;

  /// لیستی از قالب‌های مرتبط با این سری نمونه‌گیری
  final List<Mold> molds;

  const SamplingSerie({
    required this.id,
    required this.concreteTemperature,
    required this.ambientTemperature,
    required this.slump,
    required this.range,
    required this.airPercentage,
    required this.hasAdditive,
    required this.sampleId,
    required this.molds,
  });

  /// متدی برای کپی کردن آبجکت با تغییر برخی مقادیر
  SamplingSerie copyWith({
    int? id,
    double? concreteTemperature,
    double? ambientTemperature,
    double? slump,
    String? range,
    double? airPercentage,
    bool? hasAdditive,
    int? sampleId,
    List<Mold>? molds,
  }) {
    return SamplingSerie(
      id: id ?? this.id,
      concreteTemperature: concreteTemperature ?? this.concreteTemperature,
      ambientTemperature: ambientTemperature ?? this.ambientTemperature,
      slump: slump ?? this.slump,
      range: range ?? this.range,
      airPercentage: airPercentage ?? this.airPercentage,
      hasAdditive: hasAdditive ?? this.hasAdditive,
      sampleId: sampleId ?? this.sampleId,
      molds: molds ?? this.molds,
    );
  }

  /// تبدیل آبجکت به جیسان (Map) برای ذخیره‌سازی
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'concrete_temperature': concreteTemperature,
      'ambient_temperature': ambientTemperature,
      'slump': slump,
      'range': range,
      'air_percentage': airPercentage,
      'has_additive': hasAdditive, // ارسال مستقیم به صورت boolean
      'sample': sampleId,
      'molds': molds.map((mold) => mold.toJson()).toList(),
    };
  }

  /// ساخت آبجکت از روی جیسان (Map)
  factory SamplingSerie.fromJson(Map<String, dynamic> json) {
    return SamplingSerie(
      id: json['id'] as int,
      concreteTemperature: (json['concrete_temperature'] as num).toDouble(),
      ambientTemperature: (json['ambient_temperature'] as num).toDouble(),
      slump: (json['slump'] as num).toDouble(),
      range: json['range'] as String,
      airPercentage: (json['air_percentage'] as num).toDouble(),
      hasAdditive:
          json['has_additive'] as bool, // خواندن مستقیم به صورت boolean
      sampleId: json['sample'] as int,
      molds:
          (json['molds'] as List<dynamic>)
              .map(
                (moldJson) => Mold.fromJson(moldJson as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}
