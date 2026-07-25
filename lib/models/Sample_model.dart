import 'package:boton/models/allmodels.dart';
import 'package:boton/models/sampling_serie_model.dart';
import 'package:flutter/material.dart';

@immutable
class Sample {
  final int id;
  final DateTime date;
  final String testType;
  final String samplingVolume;
  final String cementGrade;
  final String category;
  final String weatherCondition;
  final String concreteFactory;
  final int projectId;
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
    required this.series,
  });

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
          json['series'] != null
              ? parseList(json['series'], SamplingSerie.fromJson)
              : [],
    );
  }
}
