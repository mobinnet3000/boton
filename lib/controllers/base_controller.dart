import 'package:boton/models/ProjectForCreation_model.dart';
import 'package:boton/models/Sample_model.dart';
import 'package:boton/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart'; // برای فرمت‌دهی بهتر تاریخ
import '../models/user_model.dart';
import '../models/project_model.dart';
import '../models/breakage_group_model.dart';
import '../models/mold_model.dart';
import '../services/api_service.dart';

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
  // final MockApiService _apiService = MockApiService();
  final ApiService _apiService = ApiService(DioClient.instance);
  // final ApiService _apiService = ApiService(); // ✅ این خط جایگزین می‌شود

  var isLoading = true.obs;
  var user = Rxn<User>();
  var projects = <Project>[].obs;
  var breakageGroups = <BreakageGroup>[].obs;
  var isAddingProject = false.obs;
  var isUpdatingProject = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      isLoading(true);
      final apiResponse = await _apiService.getFullUserData();
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

  // Future<void> addProject(ProjectForCreation projectData) async {
  //   try {
  //     isAddingProject(true); // لودینگ شروع می‌شود
  //     // متد سرویس را که در گام قبل ساختیم، فراخوانی می‌کنیم
  //     final createdProject = await _apiService.createProject(projectData);
  //     // پروژه جدیدی که از سرور آمده را به ابتدای لیست پروژه‌ها اضافه می‌کنیم
  //     // projects.insert(0, createdProject);
  //     Get.back(); // از صفحه فرم به صفحه لیست برمی‌گردیم
  //     // یک پیام موفقیت به کاربر نمایش می‌دهیم
  //     Get.snackbar(
  //       'انجام شد!',
  //       'پروژه "${createdProject.projectName}" با موفقیت ایجاد شد.',
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //       margin: const EdgeInsets.all(12),
  //       duration: const Duration(seconds: 4),
  //     );
  //   } catch (e) {
  //     // در صورت بروز خطا، یک پیام خطا نمایش می‌دهیم
  //     Get.snackbar(
  //       'خطا',
  //       'متاسفانه در ایجاد پروژه مشکلی پیش آمد: $e',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       margin: const EdgeInsets.all(12),
  //       duration: const Duration(seconds: 4),
  //     );
  //   } finally {
  //     isAddingProject(false); // در هر صورت، لودینگ تمام می‌شود
  //   }
  // }

  Future<bool> updateProject(Project updatedProject) async {
    try {
      isUpdatingProject(true);

      // فراخوانی سرویس API
      final result = await _apiService.updateProject(
        updatedProject.id,
        updatedProject,
      );

      // پیدا کردن ایندکس پروژه قدیمی در لیست
      final index = projects.indexWhere((p) => p.id == updatedProject.id);

      if (index != -1) {
        // جایگزین کردن پروژه قدیمی با پروژه جدیدی که از سرور آمده
        projects[index] = result;
        // به‌روزرسانی لیست برای اعمال تغییرات در UI
        projects.refresh();
      }

      Get.snackbar(
        'موفقیت',
        'پروژه با موفقیت به‌روزرسانی شد.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      loadInitialData();
      return true;
    } catch (e) {
      Get.snackbar(
        'خطا',
        'خطا در به‌روزرسانی پروژه: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isUpdatingProject(false);
    }
  }

  Future<bool> addProject(ProjectForCreation projectData) async {
    try {
      isAddingProject(true);
      final createdProject = await _apiService.createProject(projectData);
      projects.insert(0, createdProject);

      Get.snackbar(
        'انجام شد!',
        'پروژه "${createdProject.projectName}" با موفقیت ایجاد شد.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true; // ✅ موفقیت
    } catch (e) {
      Get.snackbar(
        'خطا',
        'متاسفانه در ایجاد پروژه مشکلی پیش آمد: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // ✅ شکست
    } finally {
      isAddingProject(false);
    }
  }

  Future<void> addSampleToProject(
    Map<String, dynamic> sampleData,
    int projectId,
  ) async {
    try {
      isLoading(true); // نمایش لودینگ
      // ۱. متد سرویس را برای ارسال داده به سرور فراخوانی می‌کنیم
      final newSample = await _apiService.createSample(sampleData);

      // ۲. پروژه مورد نظر را در لیست پروژه‌های کنترلر پیدا می‌کنیم
      final projectIndex = projects.indexWhere((p) => p.id == projectId);
      if (projectIndex != -1) {
        // ۳. نمونه جدیدی که از سرور آمده را به لیست samples آن پروژه اضافه می‌کنیم
        projects[projectIndex].samples.add(newSample);
        // ۴. به GetX اطلاع می‌دهیم که لیست پروژه‌ها تغییر کرده تا UI به‌روز شود
        projects.refresh();
        loadInitialData();
      }

      SnackbarHelper.showSuccess(message: 'نمونه جدید با موفقیت ثبت شد.');
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ثبت نمونه: ${e.toString()}');
    } finally {
      isLoading(false); // پنهان کردن لودینگ
    }
  }

  Future<void> addSerieToSample(
    Map<String, dynamic> serieData,
    int projectId,
    int sampleId,
  ) async {
    try {
      isLoading(true); // یا یک لودینگ مخصوص برای این عملیات

      // ۱. متد سرویس را برای ارسال داده به بک‌اند فراخوانی می‌کنیم
      final newSerie = await _apiService.createSerie(serieData);

      // ۲. پروژه مورد نظر را در لیست پروژه‌های کنترلر پیدا می‌کنیم
      final projectIndex = projects.indexWhere((p) => p.id == projectId);
      if (projectIndex == -1) return; // اگر پروژه پیدا نشد، خارج شو

      // ۳. نمونه (Sample) مورد نظر را در آن پروژه پیدا می‌کنیم
      final sampleIndex = projects[projectIndex].samples.indexWhere(
        (s) => s.id == sampleId,
      );
      if (sampleIndex == -1) return; // اگر نمونه پیدا نشد، خارج شو

      // ۴. سری جدیدی که از سرور آمده را به لیست series آن نمونه اضافه می‌کنیم
      projects[projectIndex].samples[sampleIndex].series.add(newSerie);

      // ۵. به GetX اطلاع می‌دهیم که لیست پروژه‌ها تغییر کرده تا UI به‌روز شود
      projects.refresh();

      Get.back();
      SnackbarHelper.showSuccess(message: 'سری جدید با موفقیت ثبت شد.');
      loadInitialData();
    } catch (e) {
      Get.snackbar('خطا', 'خطا در ثبت سری جدید: ${e.toString()}');
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
      // print('   - نام: ${user.value!.fullName}');
      print('   - ایمیل: ${user.value!.email}');
      // print('   - آزمایشگاه: ${user.value!.labName}');
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
