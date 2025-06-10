// lib/models/project_model.dart
class Project {
  final String id;
  final String name;
  final String clientName;
  final String supervisorName;
  final String applicantName;
  final String address;
  final int floorCount;
  // ... سایر فیلدهای جزئیات پروژه
  
  Project({
    required this.id,
    required this.name,
    this.clientName = 'علی علوی',
    this.supervisorName = 'رضا رضایی',
    this.applicantName = 'سارا محمودی',
    this.address = 'تهران، خیابان آزادی، پلاک ۱۲',
    this.floorCount = 5,
  });
}
