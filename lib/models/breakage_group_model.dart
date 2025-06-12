import 'package:flutter/foundation.dart';
import 'mold_model.dart'; // مدل قالب را ایمپورت می‌کنیم

@immutable
class BreakageGroup {
  /// شناسه پروژه‌ای که این قالب‌ها به آن تعلق دارند
  final String projectId;

  /// نام پروژه برای نمایش در UI
  final String projectName;
  
  /// زمان ددلاین مشترک بین تمام قالب‌های این گروه
  final DateTime deadline;
  
  /// لیستی از قالب‌هایی که در این گروه قرار دارند
  final List<Mold> molds;

  const BreakageGroup({
    required this.projectId,
    required this.projectName,
    required this.deadline,
    required this.molds,
  });
}