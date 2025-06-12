// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:boton/models/project_model.dart';
// import 'package:boton/utils/snackbar_helper.dart';
// import 'dart:async';

// class ProjectController extends GetxController {
//   var allProjects = <Project>[].obs;
//   var displayedProjects = <Project>[].obs;
//   var searchQuery = ''.obs;

//   // ستون‌های مرتب‌سازی: 0:نام, 1:ناظر, 2:تاریخ, 3:نوع آزمون
//   var sortColumnIndex = 0.obs;
//   var isSortAscending = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProjects();
//     debounce(searchQuery, (_) => filterAndSortProjects(), time: const Duration(milliseconds: 500));
//   }

//   void fetchProjects() {
//     allProjects.value = [
//       Project(id: '3', name: 'پروژه مسکونی الهیه', clientName: 'شرکت آرمان', supervisorName: 'مهندس اکبری', address: 'تهران', floorCount: 15, contractDate: '۱۴۰۴/۰۲/۱۵', mainTestType: 'مقاومت فشاری'),
//       Project(id: '2', name: 'پروژه تجاری ایران‌مال', clientName: 'گروه تات', supervisorName: 'مهندس زمانی', address: 'تهران', floorCount: 8, contractDate: '۱۴۰۳/۱۱/۰۱', mainTestType: 'چکش اشمیت'),
//       Project(id: '1', name: 'پروژه برج میلاد', clientName: 'شهرداری تهران', supervisorName: 'مهندس رضایی', address: 'تهران', floorCount: 20, contractDate: '۱۳۸۰/۰۱/۰۱', mainTestType: 'مقاومت فشاری'),
//     ];
//     filterAndSortProjects();
//   }

//   void updateSearchQuery(String query) {
//     searchQuery.value = query;
//   }

//   void updateSortColumn(int columnIndex) {
//     if (sortColumnIndex.value == columnIndex) {
//       isSortAscending.value = !isSortAscending.value;
//     } else {
//       sortColumnIndex.value = columnIndex;
//       isSortAscending.value = true;
//     }
//     filterAndSortProjects();
//   }

//   void filterAndSortProjects() {
//     List<Project> filtered;
//     final lowerCaseQuery = searchQuery.value.toLowerCase();

//     if (lowerCaseQuery.isEmpty) {
//       filtered = List.from(allProjects);
//     } else {
//       filtered = allProjects.where((p) => p.name.toLowerCase().contains(lowerCaseQuery) || p.clientName.toLowerCase().contains(lowerCaseQuery) || p.supervisorName.toLowerCase().contains(lowerCaseQuery)).toList();
//     }

//     // --- منطق مرتب‌سازی کامل‌تر شد ---
//     final compare = isSortAscending.value ? 1 : -1;
//     switch (sortColumnIndex.value) {
//       case 0: // نام پروژه
//         filtered.sort((a, b) => a.name.compareTo(b.name) * compare);
//         break;
//       case 1: // مهندس ناظر
//         filtered.sort((a, b) => a.supervisorName.compareTo(b.supervisorName) * compare);
//         break;
//       case 2: // تاریخ قرارداد
//         filtered.sort((a, b) => a.contractDate.compareTo(b.contractDate) * compare);
//         break;
//       case 3: // نوع آزمون
//         filtered.sort((a, b) => a.mainTestType.compareTo(b.mainTestType) * compare);
//         break;
//     }

//     displayedProjects.value = filtered;
//   }

// }

// lib/controllers/project_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boton/models/project_model.dart';
import 'package:boton/utils/snackbar_helper.dart';
import 'dart:async';

class ProjectController extends GetxController {
  var allProjects = <Project>[].obs;
  var displayedProjects = <Project>[].obs;
  var searchQuery = ''.obs;

  // --- State Variables for Sorting & Pagination ---
  var sortColumnIndex = 1.obs; // 0:Name, 1:Date, 2:Client, 3:Supervisor...
  var isSortAscending = false.obs; // پیش‌فرض: جدیدترین
  var itemsPerPage = 10.obs;
  var currentPage = 1.obs;
  int get totalPages =>
      (allProjects.where(_matchesFilter).length / itemsPerPage.value).ceil();

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
    debounce(
      searchQuery,
      (_) => filterAndSortProjects(),
      time: const Duration(milliseconds: 400),
    );
  }

  void fetchProjects() {
    allProjects.value = [
      Project(
        id: '1',
        name: 'پروژه برج میلاد',
        clientName: 'شهرداری تهران',
        supervisorName: 'مهندس رضایی',
        floorCount: 20,
        contractDate: '2023-05-10',
        projectid: 'مقاومت فشاری',
        municipalDistrict: 'منطقه ۲',
      ),
      Project(
        id: '2',
        name: 'پروژه تجاری ایران‌مال',
        clientName: 'گروه صنعتی تات',
        supervisorName: 'مهندس زمانی',
        floorCount: 8,
        contractDate: '2024-02-20',
        projectid: 'چکش اشمیت',
        municipalDistrict: 'منطقه ۲۲',
      ),
      Project(
        id: '3',
        name: 'پروژه مسکونی الهیه',
        clientName: 'شرکت آرمان',
        supervisorName: 'مهندس اکبری',
        floorCount: 15,
        contractDate: '2025-08-01',
        projectid: 'مقاومت فشاری',
        municipalDistrict: 'منطقه ۱',
      ),
    ];
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
      filterAndSortProjects();
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
    return p.name.toLowerCase().contains(query) ||
        p.clientName.toLowerCase().contains(query) ||
        p.supervisorName.toLowerCase().contains(query);
  }

  void filterAndSortProjects() {
    currentPage.value = 1; // با هر تغییر، به صفحه اول برگرد
    List<Project> filtered = allProjects.where(_matchesFilter).toList();
    final compare = isSortAscending.value ? 1 : -1;

    switch (sortColumnIndex.value) {
      case 0:
        filtered.sort((a, b) => a.name.compareTo(b.name) * compare);
        break;
      case 1:
        filtered.sort(
          (a, b) => a.contractDate.compareTo(b.contractDate) * compare,
        );
        break;
      case 2:
        filtered.sort((a, b) => a.clientName.compareTo(b.clientName) * compare);
        break;
      case 3:
        filtered.sort(
          (a, b) => a.supervisorName.compareTo(b.supervisorName) * compare,
        );
        break;
      case 4:
        filtered.sort(
          (a, b) =>
              a.municipalDistrict.compareTo(b.municipalDistrict) * compare,
        );
        break;
      case 5:
        filtered.sort((a, b) => a.floorCount.compareTo(b.floorCount) * compare);
        break;
      case 6:
        filtered.sort((a, b) => a.projectid.compareTo(b.projectid) * compare);
        break;
    }

    // اعمال صفحه‌بندی روی لیست نهایی
    int startIndex = (currentPage.value - 1) * itemsPerPage.value;
    int endIndex = startIndex + itemsPerPage.value;
    if (endIndex > filtered.length) endIndex = filtered.length;

    displayedProjects.value = filtered.sublist(startIndex, endIndex);
  }

  void deleteProject(String projectId) {
    Get.defaultDialog(
      title: "تایید حذف",
      middleText: "آیا از حذف این پروژه اطمینان دارید؟",
      textConfirm: "بله، حذف کن",
      textCancel: "انصراف",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red.shade600,
      onConfirm: () {
        allProjects.removeWhere((p) => p.id == projectId);
        filterAndSortProjects();
        Get.back();
        SnackbarHelper.showSuccess(message: "پروژه با موفقیت حذف شد.");
      },
    );
  }
}
