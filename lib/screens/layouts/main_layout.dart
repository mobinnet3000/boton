// lib/layouts/main_layout.dart
import 'package:boton/controller/drawer_controller.dart';
import 'package:boton/controller/menu_controller.dart';
import 'package:boton/screens/layouts/components/costum_app_bar.dart';
import 'package:boton/screens/layouts/components/custom_drawer.dart';
import 'package:boton/screens/layouts/components/header.dart';
import 'package:boton/screens/layouts/components/item_drawer.dart';
import 'package:boton/screens/setting/setting.dart';
import 'package:flutter/material.dart';
// صفحات مختلف داشبورد را اینجا وارد می‌کنیم
import 'package:boton/screens/dashboard/dashboard_home_page.dart';
import 'package:boton/screens/dashboard/projects_page.dart';
import 'package:boton/screens/dashboard/placeholder_page.dart'; 
// --- ایمپورت جدید برای صفحه پشتیبانی ---
import 'package:boton/screens/dashboard/support_page.dart';
import 'package:get/get.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0; // آیتم منوی انتخاب شده
  bool _isRailExpanded = false; // آیا منوی کناری در حالت دسکتاپ باز است یا بسته
Widget getBody(DrawerSection section) {
      switch (section) {
        case DrawerSection.dashboard:
          return  DashboardHomePage();
        case DrawerSection.projects:
          return ProjectsPage();
        case DrawerSection.dailyTest:
          return PlaceholderPage(title: 'گزارش روزانه');
        case DrawerSection.activityReport:
          return PlaceholderPage(title: 'گزارش فعالیت');
        case DrawerSection.financialReport:
          return  PlaceholderPage(title: 'گزارش مالی');
        case DrawerSection.managers:
          return PlaceholderPage(title: 'مدیریت');
        case DrawerSection.settings:
          return PlaceholderPage(title: 'تنظیمات');
        case DrawerSection.support:
          return SupportPage();
        default:
          return Center(child: Text('صفحه پیدا نشد'));
      }
    }

  static List ml = [
    DrawerSection.dashboard,
    DrawerSection.projects,
    DrawerSection.dailyTest,
    DrawerSection.activityReport,
    DrawerSection.financialReport,
    DrawerSection.managers,
    DrawerSection.settings,
    DrawerSection.support,
  ]; // لیست صفحات ما که با انتخاب منو تغییر می‌کند
  // static const List<Widget> _pages = <Widget>[
  //   DashboardHomePage(), // پیشخوان
  //   ProjectsPage(), // پروژه‌ها
  //   PlaceholderPage(title: 'گزارش فعالیت'),
  //   PlaceholderPage(title: 'گزارش مالی'),
  //   PlaceholderPage(title: 'مدیریت'),
  //   SupportPage(), // <-- تغییر اصلی اینجاست: PlaceholderPage با SupportPage جایگزین شد
  // ];
  final MenuControllerr menuController = Get.put(MenuControllerr());

  @override
  Widget build(BuildContext context) {
    // با استفاده از MediaQuery اندازه صفحه را تشخیص می‌دهیم
    final isLargeScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: CustomAppBar(title: 'پنل مدیریت آزمایشگاه بتن'),
      // دراور فقط برای صفحات کوچک استفاده می‌شود
      drawer: isLargeScreen ? null : Drawer(child: CustomDrawer()),
      body: Row(
        children: [
          // منوی ثابت کناری (NavigationRail) فقط در صفحات بزرگ نمایش داده می‌شود
          if (isLargeScreen)
            // NavigationRail(
            //     selectedIndex: _selectedIndex,
            //     extended: _isRailExpanded, // کنترل باز و بسته بودن
            //     onDestinationSelected: (index) {
            //       setState(() {
            //         () => _selectedIndex = index;
            //         menuController.selectSection(ml[index]);
            //       });
            //     },
            //     leading: IconButton(
            //       icon: Icon(_isRailExpanded ? Icons.menu_open : Icons.menu),
            //       onPressed: () {
            //         setState(() => _isRailExpanded = !_isRailExpanded);
            //       },
            //     ),
            //     destinations: DrawerItems.getDestinationss(),
            //   ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300), // مدت زمان انیمیشن
              curve: Curves.easeInOut, // نوع منحنی انیمیشن
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                extended: _isRailExpanded, // کنترل باز و بسته بودن
                onDestinationSelected: (index) {
                  setState(() => _selectedIndex = index);
                  menuController.selectSection(ml[index]);
                },
                leading: IconButton(
                  icon: Icon(_isRailExpanded ? Icons.menu_open : Icons.menu),
                  onPressed: () {
                    setState(() => _isRailExpanded = !_isRailExpanded);
                  },
                ),
                destinations: DrawerItems.getDestinationss(),
              ),
            ),

          const VerticalDivider(thickness: 1, width: 1),

          // محتوای اصلی صفحه
          Expanded(
            child: Obx(() => getBody(menuController.selectedSection.value)),
          ),
        ],
      ),
    );
  }
}
