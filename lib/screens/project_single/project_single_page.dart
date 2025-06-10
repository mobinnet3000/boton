// lib/pages/project_single/project_single_page.dart
import 'package:flutter/material.dart';
import 'package:boton/models/project_model.dart';
import 'package:boton/components/custom_animated_tab_bar.dart'; // ایمپورت کامپوننت جدید
import 'tabs/details_tab.dart';
import 'tabs/concrete_tab.dart';
import 'tabs/financial_tab.dart';
import 'tabs/activity_report_tab.dart';

class ProjectSinglePage extends StatefulWidget {
  final Project project;
  const ProjectSinglePage({super.key, required this.project});

  @override
  State<ProjectSinglePage> createState() => _ProjectSinglePageState();
}

class _ProjectSinglePageState extends State<ProjectSinglePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<Tab> _tabs = [
    Tab(text: 'جزئیات'),
    Tab(text: 'بتن'),
    Tab(text: 'میلگرد'),
    Tab(text: 'مالی'),
    Tab(text: 'گزارش فعالیت'),
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('پروژه: ${widget.project.name}'),
        // به جای TabBar قدیمی، از ویجت سفارشی خودمان استفاده می‌کنیم
        bottom: CustomAnimatedTabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DetailsTab(project: widget.project),
          const ConcreteTab(),
          const Center(child: Text('صفحه میلگرد')),
          const FinancialTab(),
          const ActivityReportTab(),
        ],
      ),
    );
  }
}
