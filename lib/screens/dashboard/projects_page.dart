// lib/pages/dashboard/projects_page.dart
import 'package:boton/controller/project_controller.dart';
import 'package:boton/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/project_list_item_card.dart';


class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey.shade600,
              tabs: const [Tab(text: 'لیست پروژه‌ها'), Tab(text: 'افزودن پروژه')],
            ),
          ),
          const Expanded(child: TabBarView(children: [ProjectListPage(), AddProjectPage()])),
        ],
      ),
    );
  }
}

class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectController controller = Get.put(ProjectController());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(onChanged: controller.updateSearchQuery, decoration: InputDecoration(hintText: 'جستجو...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)), contentPadding: const EdgeInsets.symmetric(horizontal: 15))),
        ),
        _SortableHeader(), // هدر جدید ما
        const Divider(height: 1),
        Expanded(
          child: Obx(() => controller.displayedProjects.isEmpty
              ? const Center(child: Text('هیچ پروژه‌ای یافت نشد.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: controller.displayedProjects.length,
                  itemBuilder: (context, index) {
                    final project = controller.displayedProjects[index];
                    return ProjectListItemCard(project: project, onDelete: () => controller.deleteProject(project.id));
                  },
                )),
        ),
        _PaginationControls(), // کنترل‌های صفحه‌بندی
      ],
    );
  }
}

// ویجت هدر قابل مرتب‌سازی
class _SortableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProjectController controller = Get.find();
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildHeaderItem(context, controller, 'نام پروژه', 0),
          _buildHeaderItem(context, controller, 'تاریخ', 1),
          _buildHeaderItem(context, controller, 'کارفرما', 2),
          _buildHeaderItem(context, controller, 'ناظر', 3),
          _buildHeaderItem(context, controller, 'منطقه', 4),
          _buildHeaderItem(context, controller, 'طبقات', 5),
          _buildHeaderItem(context, controller, 'نوع آزمون', 6),
        ],
      ),
    ));
  }

  Widget _buildHeaderItem(BuildContext context, ProjectController controller, String title, int index) {
    final bool isActive = controller.sortColumnIndex.value == index;
    return TextButton.icon(
      onPressed: () => controller.updateSortColumn(index),
      icon: Icon(
        isActive ? (controller.isSortAscending.value ? Icons.arrow_upward : Icons.arrow_downward) : null,
        size: 16,
        color: isActive ? Theme.of(context).primaryColor : Colors.grey,
      ),
      label: Text(title, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade700)),
    );
  }
}

// ویجت کنترل‌های صفحه‌بندی
class _PaginationControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProjectController controller = Get.find();
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('تعداد در صفحه:'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: controller.itemsPerPage.value,
                items: [10, 20, 50].map((size) => DropdownMenuItem(value: size, child: Text(size.toString()))).toList(),
                onChanged: (value) => controller.changeItemsPerPage(value!),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: controller.currentPage.value > 1 ? () => controller.goToPage(controller.currentPage.value - 1) : null, icon: const Icon(Icons.chevron_right)), // Right for RTL
              Text('صفحه ${controller.currentPage.value} از ${controller.totalPages}'),
              IconButton(onPressed: controller.currentPage.value < controller.totalPages ? () => controller.goToPage(controller.currentPage.value + 1) : null, icon: const Icon(Icons.chevron_left)), // Left for RTL
            ],
          ),
        ],
      ),
    ));
  }
}

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});
  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}
class _AddProjectPageState extends State<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedTestType = 'مقاومت فشاری';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('افزودن پروژه جدید', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(decoration: const InputDecoration(labelText: 'نام پروژه')), const SizedBox(height: 16),
              TextFormField(decoration: const InputDecoration(labelText: 'نام کارفرما')), const SizedBox(height: 16),
              TextFormField(decoration: const InputDecoration(labelText: 'نام مهندس ناظر')), const SizedBox(height: 16),
              TextFormField(decoration: const InputDecoration(labelText: 'آدرس پروژه')), const SizedBox(height: 16),
              TextFormField(decoration: const InputDecoration(labelText: 'تعداد طبقات'), keyboardType: TextInputType.number), const SizedBox(height: 24),
              const Text('نوع آزمون اصلی پروژه:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              RadioListTile<String>(title: const Text('مقاومت فشاری'), value: 'مقاومت فشاری', groupValue: _selectedTestType, onChanged: (value) => setState(() => _selectedTestType = value!)),
              RadioListTile<String>(title: const Text('چکش اشمیت'), value: 'چکش اشمیت', groupValue: _selectedTestType, onChanged: (value) => setState(() => _selectedTestType = value!)),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    SnackbarHelper.showSuccess(message: 'پروژه جدید با موفقیت افزوده شد.');
                  }
                },
                icon: const Icon(Icons.add_circle_outline), label: const Text('افزودن پروژه'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
