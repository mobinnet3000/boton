// lib/pages/dashboard/projects_page.dart
import 'package:boton/controllers/project_controller.dart';
import 'package:boton/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/project_list_item_card.dart';
import 'package:boton/models/project_model.dart';

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
              tabs: const [
                Tab(text: 'لیست پروژه‌ها'),
                Tab(text: 'افزودن پروژه'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(children: [ProjectListPage(), AddProjectPage()]),
          ),
        ],
      ),
    );
  }
}

class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectListController controller = Get.put(ProjectListController());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            onChanged: controller.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'جستجو...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
        ),
        _SortableHeader(), // هدر جدید ما
        const Divider(height: 1),
        Expanded(
          child: Obx(
            () =>
                controller.displayedProjects.isEmpty
                    ? const Center(child: Text('هیچ پروژه‌ای یافت نشد.'))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: controller.displayedProjects.length,
                      itemBuilder: (context, index) {
                        final project = controller.displayedProjects[index];
                        return ProjectListItemCard(
                          project: project,
                          onDelete: () => controller.deleteProject(project.id),
                        );
                      },
                    ),
          ),
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
    final ProjectListController controller = Get.find();
    return Obx(
      () => SingleChildScrollView(
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
      ),
    );
  }

  Widget _buildHeaderItem(
    BuildContext context,
    ProjectListController controller,
    String title,
    int index,
  ) {
    final bool isActive = controller.sortColumnIndex.value == index;
    return TextButton.icon(
      onPressed: () => controller.updateSortColumn(index),
      icon: Icon(
        isActive
            ? (controller.isSortAscending.value
                ? Icons.arrow_upward
                : Icons.arrow_downward)
            : null,
        size: 16,
        color: isActive ? Theme.of(context).primaryColor : Colors.grey,
      ),
      label: Text(
        title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color:
              isActive ? Theme.of(context).primaryColor : Colors.grey.shade700,
        ),
      ),
    );
  }
}

// ویجت کنترل‌های صفحه‌بندی
class _PaginationControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProjectListController controller = Get.find();
    return Obx(
      () => Padding(
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
                  items:
                      [10, 20, 50]
                          .map(
                            (size) => DropdownMenuItem(
                              value: size,
                              child: Text(size.toString()),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => controller.changeItemsPerPage(value!),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed:
                      controller.currentPage.value > 1
                          ? () => controller.goToPage(
                            controller.currentPage.value - 1,
                          )
                          : null,
                  icon: const Icon(Icons.chevron_right),
                ), // Right for RTL
                Text(
                  'صفحه ${controller.currentPage.value} از ${controller.totalPages}',
                ),
                IconButton(
                  onPressed:
                      controller.currentPage.value < controller.totalPages
                          ? () => controller.goToPage(
                            controller.currentPage.value + 1,
                          )
                          : null,
                  icon: const Icon(Icons.chevron_left),
                ), // Left for RTL
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});
  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();

  // ✅ کنترلرها بر اساس مدل جدید Project
  final _projectNameController = TextEditingController();
  final _fileNumberController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _supervisorNameController = TextEditingController();
  final _supervisorPhoneController = TextEditingController();
  final _requesterNameController = TextEditingController();
  final _requesterPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _municipalityZoneController = TextEditingController();
  final _floorCountController = TextEditingController();
  final _occupiedAreaController = TextEditingController();
  final _moldTypeController = TextEditingController();

  // ✅ مقادیر برای Dropdowns بر اساس مدل جدید
  String? _selectedUsageType = 'مسکونی';
  String? _selectedCementType = 'تیپ ۲';

  @override
  void dispose() {
    // ✅ آزادسازی تمام کنترلرها
    _projectNameController.dispose();
    _fileNumberController.dispose();
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _supervisorNameController.dispose();
    _supervisorPhoneController.dispose();
    _requesterNameController.dispose();
    _requesterPhoneController.dispose();
    _addressController.dispose();
    _municipalityZoneController.dispose();
    _floorCountController.dispose();
    _occupiedAreaController.dispose();
    _moldTypeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: در یک برنامه واقعی، ownerId باید از کنترلر کاربر گرفته شود
      // final authController = Get.find<AuthController>();
      // final ownerId = authController.user.id;
      const ownerId = 1; // مقدار تستی

      // ✅ ساخت آبجکت Project بر اساس مدل جدید
      final newProject = Project(
        id: 0, // سرور معمولا ID را مشخص می‌کند، پس 0 یا -1 ارسال می‌کنیم
        createdAt: DateTime.now(), // تاریخ فعلی را به عنوان پیش‌فرض قرار می‌دهیم
        projectName: _projectNameController.text,
        fileNumber: _fileNumberController.text,
        clientName: _clientNameController.text,
        clientPhoneNumber: _clientPhoneController.text,
        supervisorName: _supervisorNameController.text,
        supervisorPhoneNumber: _supervisorPhoneController.text,
        requesterName: _requesterNameController.text,
        requesterPhoneNumber: _requesterPhoneController.text,
        address: _addressController.text,
        municipalityZone: _municipalityZoneController.text,
        projectUsageType: _selectedUsageType ?? '',
        floorCount: int.tryParse(_floorCountController.text) ?? 0,
        occupiedArea: double.tryParse(_occupiedAreaController.text) ?? 0.0,
        cementType: _selectedCementType ?? '',
        moldType: _moldTypeController.text,
        ownerId: ownerId,
        samples: const [], // پروژه جدید نمونه‌ای ندارد
      );

      // TODO: آبجکت ساخته شده را به کنترلر اصلی برای ارسال به API بده
      // final projectController = Get.find<ProjectController>();
      // projectController.createProject(newProject);

      SnackbarHelper.showSuccess(message: 'پروژه جدید با موفقیت افزوده شد.');
      Get.back(); // بازگشت به صفحه قبل
    } else {
      SnackbarHelper.showError(
        message: 'لطفاً تمام فیلدهای ستاره‌دار را پر کنید.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('افزودن پروژه جدید')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionCard(
                title: 'اطلاعات پایه پروژه',
                children: [
                  _buildTextFormField(
                    controller: _projectNameController,
                    label: 'نام پروژه*',
                    icon: Icons.business_center_outlined,
                  ),
                  _buildTextFormField(
                    controller: _fileNumberController,
                    label: 'شماره پرونده*',
                    icon: Icons.article_outlined,
                  ),
                  _buildTextFormField(
                    controller: _addressController,
                    label: 'آدرس پروژه*',
                    icon: Icons.location_on_outlined,
                  ),
                  _buildTextFormField(
                    controller: _municipalityZoneController,
                    label: 'منطقه شهرداری*',
                    icon: Icons.map_outlined,
                  ),
                  _buildDropdownFormField(
                    value: _selectedUsageType,
                    label: 'کاربری پروژه',
                    items: ['مسکونی', 'تجاری', 'اداری', 'صنعتی', 'سایر'],
                    onChanged:
                        (value) => setState(() => _selectedUsageType = value),
                  ),
                ],
              ),
              _buildSectionCard(
                title: 'اشخاص پروژه',
                children: [
                  _buildTextFormField(
                    controller: _clientNameController,
                    label: 'نام کارفرما*',
                    icon: Icons.person_outline,
                  ),
                  _buildTextFormField(
                    controller: _clientPhoneController,
                    label: 'شماره تماس کارفرما*',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextFormField(
                    controller: _supervisorNameController,
                    label: 'نام مهندس ناظر*',
                    icon: Icons.engineering_outlined,
                  ),
                  _buildTextFormField(
                    controller: _supervisorPhoneController,
                    label: 'شماره تماس ناظر*',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextFormField(
                    controller: _requesterNameController,
                    label: 'نام درخواست‌کننده',
                    icon: Icons.person_pin_outlined,
                    isRequired: false,
                  ),
                  _buildTextFormField(
                    controller: _requesterPhoneController,
                    label: 'شماره تماس درخواست‌کننده',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    isRequired: false,
                  ),
                ],
              ),
              _buildSectionCard(
                title: 'جزئیات فنی',
                children: [
                  _buildTextFormField(
                    controller: _floorCountController,
                    label: 'تعداد طبقات*',
                    icon: Icons.layers_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextFormField(
                    controller: _occupiedAreaController,
                    label: 'سطح زیربنا (متر مربع)*',
                    icon: Icons.square_foot_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  _buildTextFormField(
                    controller: _moldTypeController,
                    label: 'نوع قالب*',
                    icon: Icons.view_in_ar_outlined,
                  ),
                  _buildDropdownFormField(
                    value: _selectedCementType,
                    label: 'نوع سیمان',
                    items: [
                      'تیپ ۱',
                      'تیپ ۲',
                      'تیپ ۳',
                      'تیپ ۴',
                      'تیپ ۵',
                      'سایر',
                    ],
                    onChanged:
                        (value) => setState(() => _selectedCementType = value),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('افزودن پروژه'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ویجت‌های کمکی
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return '$label نمی‌تواند خالی باشد.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownFormField({
    required String? value,
    required String label,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label را انتخاب کنید.';
          }
          return null;
        },
      ),
    );
  }
}
