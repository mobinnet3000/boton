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
  });

  factory Mold.fromJson(Map<String, dynamic> json) {
    return Mold(
      id: json['id'] as int,
      ageInDays: json['age_in_days'] as int,
      mass: (json['mass'] as num).toDouble(),
      breakingLoad: (json['breaking_load'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt:
          json['completed_at'] == null
              ? null
              : DateTime.parse(json['completed_at'] as String),
      deadline: DateTime.parse(json['deadline'] as String),
      sampleIdentifier: json['sample_identifier'] as String,
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
      seriesId: json['series'] as int,
    );
  }
}
