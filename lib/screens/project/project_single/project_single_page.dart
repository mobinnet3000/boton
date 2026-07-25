// lib/pages/project_single/project_single_page.dart

import 'package:boton/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ ۱. ایمپورت Get برای استفاده از Obx و Get.find

// ✅ ۲. ایمپورت کنترلر اصلی که منطق ریلود در آن قرار دارد
import 'package:boton/controllers/base_controller.dart';

import 'package:boton/components/custom_animated_tab_bar.dart';
import 'tabs/details_tab.dart';
import 'tabs/concrete/concrete_tab.dart';
import 'tabs/financial_tab.dart';
// import 'tabs/activity_report_tab.dart'; // این تب در لیست شما کامنت شده بود

class ProjectSinglePage extends StatefulWidget {
  final int projectid;
  const ProjectSinglePage({super.key, required this.projectid});

  @override
  State<ProjectSinglePage> createState() => _ProjectSinglePageState();
}

class _ProjectSinglePageState extends State<ProjectSinglePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ✅ من لیست تب‌ها را با فرزندان TabBarView هماهنگ کردم
  static const List<Tab> _tabs = [
    Tab(text: 'جزئیات'),
    Tab(text: 'بتن'),
    Tab(text: 'مالی'),
  ];

  @override
  void initState() {
    super.initState();
    // ✅ طول TabController باید با تعداد واقعی تب‌ها یکی باشد
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ۳. کنترلر پروژه را پیدا می‌کنیم تا به متغیر isLoading دسترسی داشته باشیم
    final projectController = Get.find<ProjectController>();
    final Project project = Get.find<ProjectController>().projects.firstWhere(
      (p) => p.id == widget.projectid,
      orElse:
          () =>
              Get.find<ProjectController>()
                  .projects[0], // یک پروژه خالی برای جلوگیری از خطا
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('پروژه: ${project.projectName}'),
        bottom: CustomAnimatedTabBar(controller: _tabController, tabs: _tabs),

        // ✅✅✅ ۴. بخش کلیدی: افزودن دکمه‌ها به اپ‌بار ✅✅✅
        actions: [
          // با Obx، آیکون را به وضعیت لودینگ کنترلر وصل می‌کنیم
          Obx(() {
            // اگر کنترلر در حال بارگذاری داده بود، یک لودر نمایش بده
            if (projectController.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.black, // رنگ لودر
                  ),
                ),
              );
            }
            // در غیر این صورت، دکمه ریلود را نمایش بده
            return IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'بارگذاری مجدد داده‌ها',
              onPressed: () {
                // با کلیک روی دکمه، متد ریلود از کنترلر فراخوانی می‌شود
                projectController.loadInitialData();
              },
            );
          }),
          // می‌توانید آیکون‌های دیگری مثل خروج را هم اینجا اضافه کنید
          // IconButton(icon: Icon(Icons.logout_outlined), onPressed: () {}),
          const SizedBox(width: 8), // ایجاد کمی فاصله از لبه صفحه
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        // فرزندان باید با لیست _tabs هماهنگ باشند
        children: [
          DetailsTab(project: project),
          ConcreteTab(project: project),
          FinancialTab(projectId: widget.projectid),
        ],
      ),
    );
  }
}
