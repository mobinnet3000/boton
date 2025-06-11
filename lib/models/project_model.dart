// lib/models/project_model.dart

class Project {
  final String id;
  final String name;
  final String clientName;
  final String clientPhone;
  final String supervisorName;
  final String supervisorPhone;
  final String applicantName;
  final String applicantPhone;
  final String projectType;
  final String address;
  final String contractor;
  final String contractNumber;
  final int floorCount;
  final double totalCost;
  final String cementType;
  final String characteristicStrength;
  final String concreteProducer;
  final String description;
  final String projectGroup;
  final String contractDate;
  final String mainTestType;
  final String municipalDistrict; // <-- فیلد جدید

  Project({
    required this.id,
    required this.name,
    this.clientName = 'ثبت نشده',
    this.supervisorName = 'ثبت نشده',
    this.clientPhone = 'ثبت نشده',
    this.supervisorPhone = 'ثبت نشده',
    this.applicantName = 'ثبت نشده',
    this.applicantPhone = 'ثبت نشده',
    this.projectType = 'ساختمانی',
    this.address = 'ثبت نشده',
    this.contractor = 'ثبت نشده',
    this.contractNumber = 'ثبت نشده',
    this.floorCount = 0,
    this.totalCost = 0.0,
    this.cementType = 'تیپ ۲',
    this.characteristicStrength = 'C25',
    this.concreteProducer = 'ثبت نشده',
    this.description = 'توضیحاتی ثبت نشده است.',
    this.projectGroup = 'جاری',
    this.contractDate = 'ثبت نشده',
    this.mainTestType = 'مقاومت فشاری',
    this.municipalDistrict = 'نامشخص',
  });
}
