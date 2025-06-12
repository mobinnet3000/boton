

// این کلاس یک بخش از سازه را تعریف می‌کند (مثل فونداسیون یا ستون)
class StructuralSection {
  final String name;
  final List<ConcreteSample> samples;

  StructuralSection({required this.name, required this.samples});
}

// models/concrete_sample.dart


class ConcreteSample {
  final String id;
  final int sampleNumber; // <<-- این فیلد دوباره اضافه شد
  final String projectCaseNumber;
  final String projectName;
  final String clientName;
  final String samplingLocation;
  final int sampleAgeDays;
  final int moldCount;
  final DateTime samplingDate;
  
  String testType;
  DateTime? actualBreakDate;
  double? appliedForce;
  double? cubicStrength;

  ConcreteSample({
    required this.id,
    required this.sampleNumber, // <<-- اینجا هم اضافه شد
    required this.projectCaseNumber,
    required this.projectName,
    required this.clientName,
    required this.samplingLocation,
    required this.sampleAgeDays,
    required this.moldCount,
    required this.samplingDate,
    this.testType = 'مقاومت فشاری',
    this.actualBreakDate,
    this.appliedForce,
    this.cubicStrength,
  });

  // ... بقیه متدها مثل requiredBreakDate و ... بدون تغییر باقی می‌مانند
  DateTime get requiredBreakDate => samplingDate.add(Duration(days: sampleAgeDays));
  int get remainingDays {
    final difference = requiredBreakDate.difference(DateTime.now()).inDays;
    return difference < 0 ? 0 : difference;
  }
  int get currentAge => DateTime.now().difference(samplingDate).inDays;
}

// این کلاس کمکی را هم اضافه کنید تا در فایل بعدی استفاده شود
