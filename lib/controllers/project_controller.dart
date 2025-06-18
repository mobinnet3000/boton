// lib/controllers/project_list_controller.dart

import 'package:boton/controllers/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart'; // برای groupBy اگر نیاز باشد

// مدل‌ها و کنترلر اصلی
import 'package:boton/models/project_model.dart';
import 'package:boton/controllers/project_controller.dart'; // کنترلر اصلی
import 'package:boton/utils/snackbar_helper.dart'; // فرض بر وجود این فایل

/// کنترلر برای مدیریت نمایش، جستجو، مرتب‌سازی و صفحه‌بندی لیست پروژه‌ها
class ProjectListController extends GetxController {
  // یک نمونه از کنترلر اصلی برای دسترسی به داده‌های مرکزی
  final ProjectController _mainController = Get.find<ProjectController>();

  // ----- وضعیت‌های داخلی کنترلر -----

  /// لیست کامل پروژه‌های دریافت شده از کنترلر اصلی
  var allProjects = <Project>[].obs;

  var isLoading = false.obs;

  /// لیستی که پس از فیلتر، مرتب‌سازی و صفحه‌بندی در UI نمایش داده می‌شود
  var displayedProjects = <Project>[].obs;

  /// رشته جستجوی وارد شده توسط کاربر
  var searchQuery = ''.obs;

  // ----- وضعیت‌های مرتب‌سازی -----
  // ستون‌ها: 0:نام پروژه, 1:شماره پرونده, 2:نام کارفرما, 3:نام ناظر
  var sortColumnIndex = 0.obs;
  var isSortAscending = true.obs;

  // ----- وضعیت‌های صفحه‌بندی -----
  var itemsPerPage = 10.obs;
  var currentPage = 1.obs;

  /// محاسبه تعداد کل صفحات بر اساس لیست فیلتر شده
  int get totalPages {
    final totalItems = allProjects.where(_matchesFilter).length;
    if (totalItems == 0) return 1;
    return (totalItems / itemsPerPage.value).ceil();
  }

  @override
  void onInit() {
    super.onInit();

    // 1. به محض تغییر در لیست پروژه‌های کنترلر اصلی، لیست این کنترلر را به‌روز کن
    // این اصلی‌ترین بخش برای اتصال دو کنترلر است
    ever(_mainController.projects, _updateProjectListFromMainController);

    // 2. برای جلوگیری از فراخوانی مکرر فیلتر هنگام تایپ کاربر، از debounce استفاده می‌کنیم
    debounce(
      searchQuery,
      (_) => filterAndSortProjects(),
      time: const Duration(milliseconds: 400),
    );

    // 3. لیست اولیه را بارگذاری کن (در صورتی که کنترلر اصلی داده‌ها را قبلا لود کرده باشد)
    _updateProjectListFromMainController(_mainController.projects);
  }

  /// این متد لیست پروژه‌ها را از کنترلر اصلی می‌گیرد و فرآیند فیلتر را آغاز می‌کند
  void _updateProjectListFromMainController(List<Project> projectsFromMain) {
    allProjects.value = projectsFromMain;
    filterAndSortProjects();
  }

  /// متد اصلی که وظیفه فیلتر، مرتب‌سازی و صفحه‌بندی را بر عهده دارد
  void filterAndSortProjects() {
    // با هر تغییر در فیلتر یا مرتب‌سازی، به صفحه اول برگرد
    currentPage.value = 1;

    // 1. فیلتر کردن بر اساس جستجو
    List<Project> filtered = allProjects.where(_matchesFilter).toList();

    // 2. مرتب‌سازی بر اساس ستون و جهت انتخاب شده
    final compare = isSortAscending.value ? 1 : -1;
    switch (sortColumnIndex.value) {
      case 0: // نام پروژه
        filtered.sort(
          (a, b) => a.projectName.compareTo(b.projectName) * compare,
        );
        break;
      case 1: // تاریخ ساخت (createdAt)
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt) * compare);
        break;
      case 2: // نام کارفرما
        filtered.sort((a, b) => a.clientName.compareTo(b.clientName) * compare);
        break;
      case 3: // نام ناظر
        filtered.sort(
          (a, b) => a.supervisorName.compareTo(b.supervisorName) * compare,
        );
        break;
      case 4: // منطقه
        filtered.sort(
          (a, b) => a.municipalityZone.compareTo(b.municipalityZone) * compare,
        );
        break;
      case 5: // تعداد طبقات
        filtered.sort((a, b) => a.fileNumber.compareTo(b.fileNumber) * compare);
        break;
      // case 6: // نوع آزمون - این فیلد روی مدل پروژه نیست و نیاز به منطق جدا دارد.
      default:
        // اگر اندیس نامعتبر بود، کاری انجام نده
        break;
    }

    // 3. صفحه‌بندی لیست نهایی
    int startIndex = (currentPage.value - 1) * itemsPerPage.value;
    int endIndex = startIndex + itemsPerPage.value;
    if (endIndex > filtered.length) endIndex = filtered.length;

    displayedProjects.value = filtered.sublist(startIndex, endIndex);
  }

  /// تابع کمکی برای بررسی اینکه آیا یک پروژه با عبارت جستجو مطابقت دارد یا خیر
  bool _matchesFilter(Project p) {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return true;

    return p.projectName.toLowerCase().contains(query) ||
        p.fileNumber.toLowerCase().contains(query) ||
        p.clientName.toLowerCase().contains(query) ||
        p.supervisorName.toLowerCase().contains(query) ||
        p.address.toLowerCase().contains(query);
  }

  // ----- متدهای عمومی برای فراخوانی از UI -----

  /// به‌روزرسانی عبارت جستجو
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// تغییر ستون مرتب‌سازی
  void updateSortColumn(int columnIndex) {
    if (sortColumnIndex.value == columnIndex) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      sortColumnIndex.value = columnIndex;
      isSortAscending.value = true; // با تغییر ستون، جهت را به صعودی ریست کن
    }
    filterAndSortProjects();
  }

  /// رفتن به صفحه مشخص
  void goToPage(int page) {
    if (page > 0 && page <= totalPages) {
      currentPage.value = page;
      // نیازی به فراخوانی filterAndSortProjects نیست چون فقط sublist عوض میشه
      // اما برای سادگی، فراخوانی می‌کنیم تا منطق متمرکز بماند
      filterAndSortProjects();
    }
  }

  /// تغییر تعداد آیتم‌ها در هر صفحه
  void changeItemsPerPage(int newSize) {
    itemsPerPage.value = newSize;
    filterAndSortProjects();
  }

  /// حذف یک پروژه (این متد باید در کنترلر اصلی پیاده‌سازی شود)
  void deleteProject(int projectId) {
    Get.defaultDialog(
      title: "تایید حذف",
      middleText: "آیا از حذف این پروژه اطمینان دارید؟",
      textConfirm: "بله، حذف کن",
      textCancel: "انصراف",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red.shade600,
      onConfirm: () {
        Get.back(); // بستن دیالوگ
        // **نکته مهم:** حذف باید از طریق کنترلر اصلی انجام شود
        // تا منبع اصلی داده (single source of truth) آپدیت شود.
        // _mainController.deleteProjectById(projectId);
        SnackbarHelper.showSuccess(message: "درخواست حذف ارسال شد.");
        // به محض اینکه پروژه از لیست `_mainController.projects` حذف شود،
        // متد `ever` به طور خودکار این کنترلر را آپدیت خواهد کرد.
      },
    );
  }

  //  Future<void> loadInitialData() async {
  //     try {
  //       // ✅ ۲. قبل از شروع فراخوانی API، وضعیت لودینگ را true می‌کنیم
  //       isLoading.value = true;

  //       // شبیه‌سازی فراخوانی API (کد واقعی شما جایگزین شود)
  //       // final data = await _apiService.fetchAllData();
  //       // projects.value = data.projects;
  //       await Future.delayed(const Duration(seconds: 2)); // این خط را با کد واقعی API جایگزین کنید

  //       print("Data reloaded successfully!");

  //     } catch (e) {
  //       // مدیریت خطا
  //       print("Error reloading data: $e");
  //     } finally {
  //       // ✅ ۳. در هر صورت (چه موفقیت چه خطا)، وضعیت لودینگ را false می‌کنیم
  //       isLoading.value = false;
  //     }
  //   }
}
