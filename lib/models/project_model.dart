import 'package:boton/models/Sample_model.dart';
import 'package:boton/models/allmodels.dart';
import 'package:boton/models/transaction_model.dart';
import 'package:flutter/material.dart';

@immutable
class Project {
  final int id;
  final DateTime createdAt;
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
  final int ownerId;
  final List<Sample> samples;
  final List<Transaction> transactions;
  final double totalIncome;
  final double totalExpense;
  final double balance;

  const Project({
    required this.id,
    required this.createdAt,
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
    required this.ownerId,
    required this.samples,
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });

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
      contractPrice:
          double.tryParse(json['contract_price'] as String? ?? '0.0') ?? 0.0,
      ownerId: json['owner'] as int,
      // samples: parseList(json['samples'], Sample.fromJson),
      // transactions: parseList(json['transactions'], Transaction.fromJson),
      // totalIncome: (json['total_income'] as num).toDouble(),
      // totalExpense: (json['total_expense'] as num).toDouble(),
      // balance: (json['balance'] as num).toDouble(),
      samples:
          json['samples'] == null
              ? []
              : parseList(json['samples'], Sample.fromJson),

      // اگر 'transactions' در جیسان نبود، یک لیست خالی [] برگردان
      transactions:
          json['transactions'] == null
              ? []
              : parseList(json['transactions'], Transaction.fromJson),

      // اگر فیلدهای عددی نبودند، مقدار پیش‌فرض 0.0 را برایشان در نظر بگیر
      totalIncome: (json['total_income'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (json['total_expense'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }
  // در انتهای کلاس Project خود، این متد را اضافه کنید
  Project copyWith({
    int? id,
    DateTime? createdAt,
    String? fileNumber,
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
    double? contractPrice,
    int? ownerId,
    List<Sample>? samples,
    List<Transaction>? transactions,
    double? totalIncome,
    double? totalExpense,
    double? balance,
  }) {
    return Project(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      fileNumber: fileNumber ?? this.fileNumber,
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
      contractPrice: contractPrice ?? this.contractPrice,
      ownerId: ownerId ?? this.ownerId,
      samples: samples ?? this.samples,
      transactions: transactions ?? this.transactions,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      balance: balance ?? this.balance,
    );
  }
}
