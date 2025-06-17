import 'package:boton/models/allmodels.dart';
import 'package:boton/models/mold_model.dart';
import 'package:flutter/material.dart';

@immutable
class SamplingSerie {
  final int id;
  final String name;
  final double concreteTemperature;
  final double ambientTemperature;
  final double slump;
  final String range;
  final double airPercentage;
  final bool hasAdditive;
  final int sampleId;
  final List<Mold> molds;

  const SamplingSerie({
    required this.id,
    required this.name,
    required this.concreteTemperature,
    required this.ambientTemperature,
    required this.slump,
    required this.range,
    required this.airPercentage,
    required this.hasAdditive,
    required this.sampleId,
    required this.molds,
  });

  factory SamplingSerie.fromJson(Map<String, dynamic> json) {
    return SamplingSerie(
      id: json['id'] as int,
      name: json['name'] != null ? json['name'] as String : 'سری ؟',
      concreteTemperature: (json['concrete_temperature'] as num).toDouble(),
      ambientTemperature: (json['ambient_temperature'] as num).toDouble(),
      slump: (json['slump'] as num).toDouble(),
      range: json['range'] as String,
      airPercentage: (json['air_percentage'] as num).toDouble(),
      hasAdditive: json['has_additive'] as bool,
      sampleId: json['sample'] != null ? json['sample'] as int : 1,
      molds:
          json['molds'] != null ? parseList(json['molds'], Mold.fromJson) : [],
    );
  }
}
