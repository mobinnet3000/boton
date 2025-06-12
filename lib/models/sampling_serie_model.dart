import 'package:boton/models/mold_model.dart';
import 'package:flutter/foundation.dart';


@immutable
class SamplingSerie {
  /// شناسه منحصر به فرد برای سری نمونه‌گیری
  final String id;

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
  /// true: دارد (معادل 1)
  /// false: ندارد (معادل 0)
  final bool hasAdditive;

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
    required this.molds,
  });

  /// متدی برای کپی کردن آبجکت با تغییر برخی مقادیر
  SamplingSerie copyWith({
    String? id,
    double? concreteTemperature,
    double? ambientTemperature,
    double? slump,
    String? range,
    double? airPercentage,
    bool? hasAdditive,
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
      molds: molds ?? this.molds,
    );
  }

  /// تبدیل آبجکت به جیسان (Map) برای ذخیره‌سازی
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'concreteTemperature': concreteTemperature,
      'ambientTemperature': ambientTemperature,
      'slump': slump,
      'range': range,
      'airPercentage': airPercentage,
      'hasAdditive': hasAdditive ? 1 : 0, // تبدیل بولین به ۰ و ۱
      'molds': molds.map((mold) => mold.toJson()).toList(), // تبدیل لیست قالب‌ها به جیسان
    };
  }

  /// ساخت آبجکت از روی جیسان (Map)
  factory SamplingSerie.fromJson(Map<String, dynamic> json) {
    return SamplingSerie(
      id: json['id'] as String,
      concreteTemperature: (json['concreteTemperature'] as num).toDouble(),
      ambientTemperature: (json['ambientTemperature'] as num).toDouble(),
      slump: (json['slump'] as num).toDouble(),
      range: json['range'] as String,
      airPercentage: (json['airPercentage'] as num).toDouble(),
      hasAdditive: (json['hasAdditive'] as int) == 1, // تبدیل ۰ و ۱ به بولین
      molds: (json['molds'] as List<dynamic>)
          .map((moldJson) => Mold.fromJson(moldJson as Map<String, dynamic>))
          .toList(), // تبدیل لیست جیسان به لیست قالب‌ها
    );
  }
}