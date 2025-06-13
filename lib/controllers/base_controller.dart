import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart'; // برای فرمت‌دهی بهتر تاریخ

// مدل‌ها
import '../models/user_model.dart';
import '../models/project_model.dart';
import '../models/breakage_group_model.dart';
import '../models/mold_model.dart';
import '../models/api_response_model.dart';

// سرویس
import '../services/mock_api_service.dart';

// کلاس کمکی داخلی
class _MoldWithProjectInfo {
  final Mold mold;
  final int projectId;
  final String projectName;

  _MoldWithProjectInfo({
    required this.mold,
    required this.projectId,
    required this.projectName,
  });
}

class ProjectController extends GetxController {
  final MockApiService _apiService = MockApiService();
  // final ApiService _apiService = ApiService(); // ✅ این خط جایگزین می‌شود

  var isLoading = true.obs;
  var user = Rxn<User>();
  var projects = <Project>[].obs;
  var breakageGroups = <BreakageGroup>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      isLoading(true);
      final apiResponse = await _apiService.fetchData();
      user.value = apiResponse.user;
      projects.value = apiResponse.projects;
      _groupMoldsForBreakage();

      // <<-- فراخوانی متد لاگ در انتهای فرآیند -->>
      _logFinalState();
    } catch (e, stacktrace) {
      Get.snackbar('خطا!', 'خطا در پردازش اطلاعات: $e');
      print(e);
      print("Stacktrace: $stacktrace");
    } finally {
      isLoading(false);
    }
  }

  void _groupMoldsForBreakage() {
    final allMoldsWithInfo =
        projects.expand((project) {
          return project.samples.expand((sample) {
            return sample.series.expand((serie) {
              return serie.molds.map(
                (mold) => _MoldWithProjectInfo(
                  mold: mold,
                  projectId: project.id,
                  projectName: project.projectName,
                ),
              );
            });
          });
        }).toList();

    final groupedData = groupBy(
      allMoldsWithInfo,
      (info) => '${info.projectId}-${info.mold.deadline.toIso8601String()}',
    );

    final result =
        groupedData.values.map((groupItems) {
          final firstItem = groupItems.first;
          return BreakageGroup(
            projectId: firstItem.projectId.toString(),
            projectName: firstItem.projectName,
            deadline: firstItem.mold.deadline,
            molds: groupItems.map((info) => info.mold).toList(),
          );
        }).toList();

    result.sort((a, b) => a.deadline.compareTo(b.deadline));
    breakageGroups.value = result;
  }

  /// متد جدید برای چاپ وضعیت نهایی کنترلر در کنسول
  void _logFinalState() {
    print('✅ ==========================================');
    print('✅          گزارش وضعیت نهایی کنترلر         ');
    print('✅ ==========================================');

    // 1. لاگ اطلاعات کاربر
    if (user.value != null) {
      print('\n👤 کاربر شناسایی شد:');
      print('   - نام: ${user.value!.fullName}');
      print('   - ایمیل: ${user.value!.email}');
      print('   - آزمایشگاه: ${user.value!.labName}');
    } else {
      print('\n❌ کاربر شناسایی نشد.');
    }

    // 2. لاگ اطلاعات پروه‌ها
    print('\n🏢 پروژه‌های یافت شده: ${projects.length}');
    for (var project in projects) {
      print('   - پروژه #${project.id}: "${project.projectName}"');
      print('     - تعداد نمونه‌ها (Samples): ${project.samples.length}');
      final totalMolds =
          project.samples
              .expand((s) => s.series)
              .expand((se) => se.molds)
              .length;
      print('     - مجموع قالب‌ها (Molds): $totalMolds');
    }

    // 3. لاگ اطلاعات گروه‌های شکست
    print(
      '\n🔬 گروه‌های شکست (Breakage Groups) ایجاد شده: ${breakageGroups.length}',
    );
    for (var group in breakageGroups) {
      // فرمت کردن تاریخ برای نمایش بهتر
      final formattedDate = DateFormat('yyyy-MM-dd').format(group.deadline);
      print('   - گروه برای پروژه "${group.projectName}"');
      print('     - تاریخ ددلاین: $formattedDate');
      print('     - تعداد قالب‌ها برای شکست: ${group.molds.length}');
    }

    print('\n✅ ==========================================');
    print('✅             پایان گزارش               ');
    print('✅ ==========================================');
  }
}
