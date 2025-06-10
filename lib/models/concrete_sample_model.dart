// lib/models/concrete_sample_model.dart

// این کلاس اطلاعات یک نمونه بتن را نگه می‌دارد
class ConcreteSample {
  final String id;
  final int sampleNumber;
  // ... سایر اطلاعات مثل تاریخ، حجم و ...

  ConcreteSample({required this.id, required this.sampleNumber});
}

// این کلاس یک بخش از سازه را تعریف می‌کند (مثل فونداسیون یا ستون)
class StructuralSection {
  final String name;
  final List<ConcreteSample> samples;

  StructuralSection({required this.name, required this.samples});
}
