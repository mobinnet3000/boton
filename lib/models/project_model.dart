import 'package:boton/models/Sample_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class Project {
  /// شناسه منحصر به فرد پروژه
  final String id;
  
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
  
  /// لیستی از نمونه‌های گرفته شده برای این پروژه
  final List<Sample> samples;

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
    this.samples = const [],
  });

  /// تبدیل آبجکت به جیسان (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileNumber': fileNumber,
      'projectName': projectName,
      'clientName': clientName,
      'clientPhoneNumber': clientPhoneNumber,
      'supervisorName': supervisorName,
      'supervisorPhoneNumber': supervisorPhoneNumber,
      'requesterName': requesterName,
      'requesterPhoneNumber': requesterPhoneNumber,
      'municipalityZone': municipalityZone,
      'address': address,
      'projectUsageType': projectUsageType,
      'floorCount': floorCount,
      'cementType': cementType,
      'occupiedArea': occupiedArea,
      'moldType': moldType,
      'samples': samples.map((sample) => sample.toJson()).toList(),
    };
  }

  /// ساخت آبجکت از روی جیسان (Map)
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      fileNumber: json['fileNumber'] as String,
      projectName: json['projectName'] as String,
      clientName: json['clientName'] as String,
      clientPhoneNumber: json['clientPhoneNumber'] as String,
      supervisorName: json['supervisorName'] as String,
      supervisorPhoneNumber: json['supervisorPhoneNumber'] as String,
      requesterName: json['requesterName'] as String,
      requesterPhoneNumber: json['requesterPhoneNumber'] as String,
      municipalityZone: json['municipalityZone'] as String,
      address: json['address'] as String,
      projectUsageType: json['projectUsageType'] as String,
      floorCount: json['floorCount'] as int,
      cementType: json['cementType'] as String,
      occupiedArea: (json['occupiedArea'] as num).toDouble(),
      moldType: json['moldType'] as String,
      samples: (json['samples'] as List<dynamic>)
          .map((sampleJson) => Sample.fromJson(sampleJson as Map<String, dynamic>))
          .toList(),
    );
  }
}
