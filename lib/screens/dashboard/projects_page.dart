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
    final ProjectController controller = Get.put(ProjectController());
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
    final ProjectController controller = Get.find();
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
    ProjectController controller,
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
    final ProjectController controller = Get.find();
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

  // Controllers for all fields
  final _nameController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _supervisorNameController = TextEditingController();
  final _supervisorPhoneController = TextEditingController();
  final _applicantNameController = TextEditingController();
  final _applicantPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _contractorController = TextEditingController();
  final _contractNumberController = TextEditingController();
  final _floorCountController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _concreteProducerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contractDateController = TextEditingController();
  final _municipalDistrictController = TextEditingController();

  // Values for Dropdowns and Radios
  String? _selectedProjectType = 'ساختمانی';
  String? _selectedCementType = 'تیپ ۲';
  String? _selectedStrength = 'C25';
  String _selectedTestType = 'مقاومت فشاری';

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _supervisorNameController.dispose();
    // ... dispose all other controllers
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _contractDateController.text =
            "${picked.year}/${picked.month}/${picked.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    controller: _nameController,
                    label: 'نام پروژه',
                    icon: Icons.title,
                  ),
                  _buildTextFormField(
                    controller: _addressController,
                    label: 'آدرس پروژه',
                    icon: Icons.location_on_outlined,
                  ),
                  _buildTextFormField(
                    controller: _municipalDistrictController,
                    label: 'منطقه شهرداری',
                    icon: Icons.map_outlined,
                  ),
                  _buildDropdownFormField(
                    value: _selectedProjectType,
                    label: 'نوع پروژه',
                    items: ['ساختمانی', 'راه‌سازی', 'صنعتی', 'سایر'],
                    onChanged:
                        (value) => setState(() => _selectedProjectType = value),
                  ),
                ],
              ),
              _buildSectionCard(
                title: 'اشخاص و کارفرما',
                children: [
                  _buildTextFormField(
                    controller: _clientNameController,
                    label: 'نام کارفرما',
                    icon: Icons.person_outline,
                  ),
                  _buildTextFormField(
                    controller: _clientPhoneController,
                    label: 'شماره تماس کارفرما',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextFormField(
                    controller: _supervisorNameController,
                    label: 'نام مهندس ناظر',
                    icon: Icons.engineering_outlined,
                  ),
                  _buildTextFormField(
                    controller: _supervisorPhoneController,
                    label: 'شماره تماس ناظر',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextFormField(
                    controller: _applicantNameController,
                    label: 'نام درخواست‌کننده',
                    icon: Icons.person_pin_outlined,
                  ),
                  _buildTextFormField(
                    controller: _applicantPhoneController,
                    label: 'شماره تماس درخواست‌کننده',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              _buildSectionCard(
                title: 'جزئیات فنی',
                children: [
                  _buildTextFormField(
                    controller: _floorCountController,
                    label: 'تعداد طبقات',
                    icon: Icons.layers_outlined,
                    keyboardType: TextInputType.number,
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
                  _buildDropdownFormField(
                    value: _selectedStrength,
                    label: 'مقاومت مشخصه',
                    items: ['C20', 'C25', 'C30', 'C35', 'C40', 'C50'],
                    onChanged:
                        (value) => setState(() => _selectedStrength = value),
                  ),
                  _buildTextFormField(
                    controller: _concreteProducerController,
                    label: 'تولیدکننده بتن',
                    icon: Icons.factory_outlined,
                  ),
                ],
              ),
              _buildSectionCard(
                title: 'نوع آزمون اصلی',
                children: [
                  RadioListTile<String>(
                    title: const Text('مقاومت فشاری'),
                    value: 'مقاومت فشاری',
                    groupValue: _selectedTestType,
                    onChanged:
                        (value) => setState(() => _selectedTestType = value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('چکش اشمیت'),
                    value: 'چکش اشمیت',
                    groupValue: _selectedTestType,
                    onChanged:
                        (value) => setState(() => _selectedTestType = value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('التراسونیک'),
                    value: 'التراسونیک',
                    groupValue: _selectedTestType,
                    onChanged:
                        (value) => setState(() => _selectedTestType = value!),
                  ),
                ],
              ),
              _buildSectionCard(
                title: 'اطلاعات قرارداد و مالی',
                children: [
                  _buildTextFormField(
                    controller: _contractorController,
                    label: 'پیمانکار',
                    icon: Icons.handshake_outlined,
                  ),
                  _buildTextFormField(
                    controller: _contractNumberController,
                    label: 'شماره قرارداد',
                    icon: Icons.article_outlined,
                  ),
                  _buildTextFormField(
                    controller: _contractDateController,
                    label: 'تاریخ قرارداد',
                    icon: Icons.calendar_today_outlined,
                    onTap: _selectDate,
                    readOnly: true,
                  ),
                  _buildTextFormField(
                    controller: _totalCostController,
                    label: 'هزینه کل پروژه (تومان)',
                    icon: Icons.monetization_on_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              _buildSectionCard(
                title: 'توضیحات تکمیلی',
                children: [
                  _buildTextFormField(
                    controller: _descriptionController,
                    label: 'توضیحات',
                    icon: Icons.notes_outlined,
                    maxLines: 4,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Here you can create the Project object and save it
                    // For example:
                    // final newProject = Project(
                    //   id: DateTime.now().toIso8601String(),
                    //   name: _nameController.text,
                    //   clientName: _clientNameController.text,
                    //   // ... and so on for all fields
                    // );
                    // print('New project created: ${newProject.name}');
                    // SnackbarHelper.showSuccess(message: 'پروژه جدید با موفقیت افزوده شد.');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('پروژه افزوده شد'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
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

  // Helper widget to build styled cards for sections
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

  // Helper widget for styled TextFormFields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label نمی‌تواند خالی باشد.';
          }
          return null;
        },
      ),
    );
  }

  // Helper widget for styled DropdownButtonFormFields
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
      ),
    );
  }
}
