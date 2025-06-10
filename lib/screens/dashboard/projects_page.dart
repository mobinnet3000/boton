// lib/pages/dashboard/projects_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boton/models/project_model.dart'; // مدل پروژه
import 'package:boton/screens/project_single/project_single_page.dart'; // صفحه جزئیات پروژه
import 'package:boton/utils/snackbar_helper.dart'; // ۱. این ایمپورت را اضافه کنید

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // استفاده از تم فعلی برای رنگ‌بندی TabBar
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 1,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                // استفاده از رنگ‌های تم برای هماهنگی بیشتر
                indicatorColor: theme.colorScheme.primary,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'لیست پروژه‌ها'),
                  Tab(text: 'افزودن پروژه'),
                ],
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProjectListPage(),
            AddProjectPage(),
          ],
        ),
      ),
    );
  }
}

// ویجت نمایش لیست پروژه‌ها
class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // داده‌های آزمایشی
    final List<String> projects = ['پروژه برج میلاد', 'پروژه ایران‌مال', 'پروژه مسکونی الهیه'];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final projectName = projects[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(projectName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('برای مشاهده جزئیات کلیک کنید'),
            leading: Icon(Icons.apartment_rounded, color: Theme.of(context).primaryColor),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            onTap: () {
              // --- منطق جدید onTap ---

              // ۱. ابتدا اسنک‌بار موفقیت‌آمیز را نمایش می‌دهیم
              SnackbarHelper.showSuccess(
                title: 'پروژه انتخاب شد',
                message: ':در حال باز کردن پروژه $projectName',
              );

              // ۲. با یک تأخیر کوتاه، به صفحه جزئیات می‌رویم
              // این تأخیر به کاربر فرصت می‌دهد تا اسنک‌بار را ببیند
              Future.delayed(const Duration(milliseconds: 400), () {
                final projectData = Project(id: index.toString(), name: projectName);
                Get.to(
                  () => ProjectSinglePage(project: projectData),
                  transition: Transition.rightToLeftWithFade,
                );
              });
            },
          ),
        );
      },
    );
  }
}

// ویجت صفحه افزودن پروژه
class AddProjectPage extends StatelessWidget {
  const AddProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'فرم افزودن پروژه در اینجا قرار می‌گیرد',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
