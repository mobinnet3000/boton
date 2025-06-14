import 'package:boton/models/Sample_model.dart'; // فرض بر این است که این import صحیح است
import 'package:flutter/foundation.dart';

@immutable
class Project {
  /// شناسه منحصر به فرد پروژه
  final int id;

  /// شماره پرونده
  final String fileNumber;

  /// نام پروژه
  final String projectName;

  /// نام کارفرما
  final String clientName;

  /// شماره تماس کارفرما
  final String clientPhoneNumber;

  /// نام ناظر
  final String supervisorName;

  /// شماره تماس ناظر
  final String supervisorPhoneNumber;

  /// نام درخواست دهنده
  final String requesterName;

  /// شماره تماس درخواست دهنده
  final String requesterPhoneNumber;

  /// منطقه شهرداری
  final String municipalityZone;

  /// آدرس پروژه
  final String address;

  /// کاربری پروژه (مثلا: مسکونی، تجاری)
  final String projectUsageType;

  /// تعداد طبقات
  final int floorCount;

  /// نوع سیمان
  final String cementType;

  /// سطح زیربنای اشغال شده (به متر مربع)
  final double occupiedArea;

  /// نوع قالب استفاده شده
  final String moldType;

  /// شناسه کاربر صاحب پروژه
  final int ownerId;

  /// لیستی از نمونه‌های گرفته شده برای این پروژه
  final List<Sample> samples;

 // تاریخ ساخت پروژه
   final DateTime createdAt;


  const Project({
    required this.id,
    required this.fileNumber,
    required this.projectName,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.supervisorName,
    required this.supervisorPhoneNumber,
    required this.requesterName,
    required this.requesterPhoneNumber,
    required this.municipalityZone,
    required this.address,
    required this.projectUsageType,
    required this.floorCount,
    required this.cementType,
    required this.occupiedArea,
    required this.moldType,
    required this.ownerId,
    required this.createdAt, 

    this.samples = const [],
  });

  /// متد copyWith برای کپی کردن آبجکت با تغییر برخی مقادیر
  Project copyWith({
    int? id,
    String? fileNumber,
    DateTime? createdAt,
    String? projectName,
    String? clientName,
    String? clientPhoneNumber,
    String? supervisorName,
    String? supervisorPhoneNumber,
    String? requesterName,
    String? requesterPhoneNumber,
    String? municipalityZone,
    String? address,
    String? projectUsageType,
    int? floorCount,
    String? cementType,
    double? occupiedArea,
    String? moldType,
    int? ownerId,
    List<Sample>? samples,
  }) {
    return Project(
      id: id ?? this.id,
      fileNumber: fileNumber ?? this.fileNumber,
      createdAt: createdAt ?? this.createdAt,
      projectName: projectName ?? this.projectName,
      clientName: clientName ?? this.clientName,
      clientPhoneNumber: clientPhoneNumber ?? this.clientPhoneNumber,
      supervisorName: supervisorName ?? this.supervisorName,
      supervisorPhoneNumber:
          supervisorPhoneNumber ?? this.supervisorPhoneNumber,
      requesterName: requesterName ?? this.requesterName,
      requesterPhoneNumber: requesterPhoneNumber ?? this.requesterPhoneNumber,
      municipalityZone: municipalityZone ?? this.municipalityZone,
      address: address ?? this.address,
      projectUsageType: projectUsageType ?? this.projectUsageType,
      floorCount: floorCount ?? this.floorCount,
      cementType: cementType ?? this.cementType,
      occupiedArea: occupiedArea ?? this.occupiedArea,
      moldType: moldType ?? this.moldType,
      ownerId: ownerId ?? this.ownerId,
      samples: samples ?? this.samples,
    );
  }

  /// تبدیل آبجکت به جیسان (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_number': fileNumber,
      'created_at': createdAt.toIso8601String(), // <<-- ۳. اضافه کردن createdAt به JSON خروجی
      'project_name': projectName,
      'client_name': clientName,
      'client_phone_number': clientPhoneNumber,
      'supervisor_name': supervisorName,
      'supervisor_phone_number': supervisorPhoneNumber,
      'requester_name': requesterName,
      'requester_phone_number': requesterPhoneNumber,
      'municipality_zone': municipalityZone,
      'address': address,
      'project_usage_type': projectUsageType,
      'floor_count': floorCount,
      'cement_type': cementType,
      'occupied_area': occupiedArea,
      'mold_type': moldType,
      'owner': ownerId,
      'samples': samples.map((sample) => sample.toJson()).toList(),
    };
  }

  /// ساخت آبجکت از روی جیسان (Map)
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String), 
      fileNumber: json['file_number'] as String,
      projectName: json['project_name'] as String,
      clientName: json['client_name'] as String,
      clientPhoneNumber: json['client_phone_number'] as String,
      supervisorName: json['supervisor_name'] as String,
      supervisorPhoneNumber: json['supervisor_phone_number'] as String,
      requesterName: json['requester_name'] as String,
      requesterPhoneNumber: json['requester_phone_number'] as String,
      municipalityZone: json['municipality_zone'] as String,
      address: json['address'] as String,
      projectUsageType: json['project_usage_type'] as String,
      floorCount: json['floor_count'] as int,
      cementType: json['cement_type'] as String,
      occupiedArea: (json['occupied_area'] as num).toDouble(),
      moldType: json['mold_type'] as String,
      ownerId: json['owner'] as int,
      samples:
          (json['samples'] as List<dynamic>)
              .map(
                (sampleJson) =>
                    Sample.fromJson(sampleJson as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}
