import 'package:flutter/material.dart';

@immutable
class ProjectForCreation {
  final String fileNumber;
  final String projectName;
  final String clientName;
  final String clientPhoneNumber;
  final String supervisorName;
  final String supervisorPhoneNumber;
  final String requesterName;
  final String requesterPhoneNumber;
  final String municipalityZone;
  final String address;
  final String projectUsageType;
  final int floorCount;
  final String cementType;
  final double occupiedArea;
  final String moldType;
  final double contractPrice;

  const ProjectForCreation({
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
    required this.contractPrice,
  });

  /// این متد آبجکت دیتای پروژه را به فرمت Map برای ارسال به سرور تبدیل می‌کند.
  Map<String, dynamic> toJson() {
    return {
      'file_number': fileNumber,
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
      'contract_price': contractPrice,
    };
  }
}
