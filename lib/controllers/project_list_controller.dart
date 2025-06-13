import 'package:boton/controllers/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// مدل اصلی پروژه و کنترلر اصلی را ایمپورت می‌کنیم
import '../models/project_model.dart';
import '../utils/snackbar_helper.dart'; // فرض بر وجود این فایل

class ProjectListController extends GetxController {
  // ۱. اتصال به کنترلر اصلی برای دریافت داده‌ها
  final ProjectController _mainController = Get.find<ProjectController>();

  // --- متغیرهای وضعیت برای نمایش در UI ---
  var allProjects = <Project>[].obs;
  var displayedProjects = <Project>[].obs;
  var searchQuery = ''.obs;

  // --- متغیرهای وضعیت برای مرتب‌سازی و صفحه‌بندی ---
  var sortColumnIndex = 0.obs; // پیش‌فرض: نام پروژه
  var isSortAscending = true.obs;
  var itemsPerPage = 10.obs;
  var currentPage = 1.obs;

  // محاسبه تعداد کل صفحات بر اساس لیست فیلتر شده
  int get totalPages {
    final totalItems = allProjects.where(_matchesFilter).length;
    if (totalItems == 0) return 1;
    return (totalItems / itemsPerPage.value).ceil();
  }

  @override
  void onInit() {
    super.onInit();
    // ۲. داده‌ها را از کنترلر اصلی بارگذاری می‌کنیم
    _loadProjectsFromMainController();

    // به محض آماده شدن داده‌ها در کنترلر اصلی، لیست ما هم آپدیت می‌شود
    _mainController.projects.listen((_) => _loadProjectsFromMainController());

    // debounce برای بهینه‌سازی جستجو
    debounce(
      searchQuery,
      (_) => filterAndSortProjects(),
      time: const Duration(milliseconds: 400),
    );
  }

  void _loadProjectsFromMainController() {
    allProjects.value = _mainController.projects;
    filterAndSortProjects();
  }

  void updateSearchQuery(String query) => searchQuery.value = query;

  void changeItemsPerPage(int size) {
    itemsPerPage.value = size;
    filterAndSortProjects();
  }

  void goToPage(int page) {
    if (page > 0 && page <= totalPages) {
      currentPage.value = page;
      // فقط صفحه‌بندی را آپدیت می‌کنیم، نیازی به مرتب‌سازی مجدد نیست
      _applyPagination();
    }
  }

  void updateSortColumn(int columnIndex) {
    if (sortColumnIndex.value == columnIndex) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      sortColumnIndex.value = columnIndex;
      isSortAscending.value = true;
    }
    filterAndSortProjects();
  }

  bool _matchesFilter(Project p) {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) return true;
    // ۳. جستجو بر اساس فیلدهای مدل اصلی
    return p.projectName.toLowerCase().contains(query) ||
        p.clientName.toLowerCase().contains(query) ||
        p.supervisorName.toLowerCase().contains(query) ||
        p.fileNumber.toLowerCase().contains(query);
  }

  void filterAndSortProjects() {
    currentPage.value = 1; // با هر فیلتر یا مرتب‌سازی جدید، به صفحه اول برگرد
    _applyPagination();
  }

  void _applyPagination() {
    // ابتدا فیلتر می‌کنیم
    List<Project> filtered = allProjects.where(_matchesFilter).toList();

    // سپس مرتب‌سازی را اعمال می‌کنیم
    final compare = isSortAscending.value ? 1 : -1;

    // ۴. مرتب‌سازی بر اساس فیلدهای مدل اصلی
    switch (sortColumnIndex.value) {
      case 0: // نام پروژه
        filtered.sort(
          (a, b) => a.projectName.compareTo(b.projectName) * compare,
        );
        break;
      case 1: // شماره پرونده
        filtered.sort((a, b) => a.fileNumber.compareTo(b.fileNumber) * compare);
        break;
      case 2: // نام کارفرما
        filtered.sort((a, b) => a.clientName.compareTo(b.clientName) * compare);
        break;
      case 3: // نام ناظر
        filtered.sort(
          (a, b) => a.supervisorName.compareTo(b.supervisorName) * compare,
        );
        break;
      case 4: // تعداد طبقات
        filtered.sort((a, b) => a.floorCount.compareTo(b.floorCount) * compare);
        break;
      case 5: // نوع سیمان
        filtered.sort((a, b) => a.cementType.compareTo(b.cementType) * compare);
        break;
    }

    // در نهایت صفحه‌بندی را روی لیست نهایی اعمال می‌کنیم
    int startIndex = (currentPage.value - 1) * itemsPerPage.value;
    int endIndex = startIndex + itemsPerPage.value;
    if (endIndex > filtered.length) endIndex = filtered.length;

    displayedProjects.value = filtered.sublist(startIndex, endIndex);
  }

  // ۵. متد حذف با استفاده از id از نوع int
  void deleteProject(int projectId) {
    Get.defaultDialog(
      title: "تایید حذف",
      middleText: "آیا از حذف این پروژه اطمینان دارید؟",
      textConfirm: "بله، حذف کن",
      textCancel: "انصراف",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red.shade600,
      onConfirm: () {
        // توجه: این کار فقط لیست داخل کنترلر اصلی را تغییر می‌دهد
        // برای حذف دائمی، باید یک درخواست به API ارسال شود
        _mainController.projects.removeWhere((p) => p.id == projectId);
        // لیست‌های ما به صورت خودکار آپدیت می‌شوند چون به کنترلر اصلی گوش می‌دهند
        Get.back();
        SnackbarHelper.showSuccess(message: "پروژه با موفقیت حذف شد.");
      },
    );
  }
}
