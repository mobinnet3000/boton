import 'package:flutter/material.dart';
// ✅ ایمپورت مدل صحیح و یکپارچه پروژه
import 'package:boton/models/project_model.dart';

class DetailsTab extends StatefulWidget {
  // ✅ نوع پروژه، از مدل صحیح خوانده می‌شود
  final Project project;
  const DetailsTab({super.key, required this.project});

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // ----- کنترلرها برای فرم ویرایش -----
  // این کنترلرها بر اساس مدل جدید Project تعریف شده‌اند
  late TextEditingController _projectNameController;
  late TextEditingController _fileNumberController;
  late TextEditingController _clientNameController;
  late TextEditingController _clientPhoneController;
  late TextEditingController _supervisorNameController;
  late TextEditingController _supervisorPhoneController;
  late TextEditingController _requesterNameController;
  late TextEditingController _requesterPhoneController;
  late TextEditingController _addressController;
  late TextEditingController _municipalityZoneController;
  late TextEditingController _floorCountController;
  late TextEditingController _occupiedAreaController;
  late TextEditingController _moldTypeController;

  // State for Dropdowns
  late String? _selectedUsageType;
  late String? _selectedCementType;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final project = widget.project;

    // ✅ مقداردهی کنترلرها با فیلدهای مدل جدید
    _projectNameController = TextEditingController(text: project.projectName);
    _fileNumberController = TextEditingController(text: project.fileNumber);
    _clientNameController = TextEditingController(text: project.clientName);
    _clientPhoneController = TextEditingController(
      text: project.clientPhoneNumber,
    );
    _supervisorNameController = TextEditingController(
      text: project.supervisorName,
    );
    _supervisorPhoneController = TextEditingController(
      text: project.supervisorPhoneNumber,
    );
    _requesterNameController = TextEditingController(
      text: project.requesterName,
    );
    _requesterPhoneController = TextEditingController(
      text: project.requesterPhoneNumber,
    );
    _addressController = TextEditingController(text: project.address);
    _municipalityZoneController = TextEditingController(
      text: project.municipalityZone,
    );
    _floorCountController = TextEditingController(
      text: project.floorCount.toString(),
    );
    _occupiedAreaController = TextEditingController(
      text: project.occupiedArea.toString(),
    );
    _moldTypeController = TextEditingController(text: project.moldType);

    _selectedUsageType = project.projectUsageType;
    _selectedCementType = project.cementType;
  }

  @override
  void dispose() {
    // ✅ آزادسازی تمام کنترلرهای جدید برای جلوگیری از نشت حافظه
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

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        // اگر در حالت ویرایش بودیم، تغییرات را ذخیره کن
        if (_formKey.currentState!.validate()) {
          // TODO: در اینجا باید پروژه آپدیت شده را به کنترلر اصلی ارسال کنی
          // Project updatedProject = widget.project.copyWith(
          //   projectName: _projectNameController.text,
          //   ... سایر فیلدها
          // );
          // final mainController = Get.find<ProjectController>();
          // mainController.updateProject(updatedProject);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تغییرات با موفقیت ذخیره شد'),
              backgroundColor: Colors.green,
            ),
          );
          _isEditing = false;
        }
      } else {
        // در غیر این صورت، وارد حالت ویرایش شو
        _isEditing = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleEditMode,
        label: Text(_isEditing ? 'ذخیره تغییرات' : 'ویرایش جزئیات'),
        icon: Icon(_isEditing ? Icons.save_alt_outlined : Icons.edit_outlined),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isEditing ? _buildEditForm() : _buildDisplayInfo(),
        ),
      ),
    );
  }

  // ==================== ویجت‌های حالت نمایش ====================
  Widget _buildDisplayInfo() {
    final project = widget.project;
    return Column(
      key: const ValueKey('display'),
      children: [
        _buildDisplayCard(
          title: 'اطلاعات پایه',
          children: [
            _buildDisplayRow(
              'نام پروژه:',
              project.projectName,
              Icons.business_center_outlined,
            ),
            _buildDisplayRow(
              'شماره پرونده:',
              project.fileNumber,
              Icons.article_outlined,
            ),
            _buildDisplayRow(
              'آدرس:',
              project.address,
              Icons.location_on_outlined,
            ),
            _buildDisplayRow(
              'منطقه شهرداری:',
              project.municipalityZone,
              Icons.map_outlined,
            ),
            _buildDisplayRow(
              'کاربری پروژه:',
              project.projectUsageType,
              Icons.category_outlined,
            ),
          ],
        ),
        _buildDisplayCard(
          title: 'اشخاص پروژه',
          children: [
            _buildDisplayRow(
              'نام کارفرما:',
              project.clientName,
              Icons.person_outline,
            ),
            _buildDisplayRow(
              'تماس کارفرما:',
              project.clientPhoneNumber,
              Icons.phone_outlined,
            ),
            _buildDisplayRow(
              'نام ناظر:',
              project.supervisorName,
              Icons.engineering_outlined,
            ),
            _buildDisplayRow(
              'تماس ناظر:',
              project.supervisorPhoneNumber,
              Icons.phone_outlined,
            ),
            _buildDisplayRow(
              'نام درخواست دهنده:',
              project.requesterName,
              Icons.person_pin_outlined,
            ),
            _buildDisplayRow(
              'تماس درخواست دهنده:',
              project.requesterPhoneNumber,
              Icons.phone_outlined,
            ),
          ],
        ),
        _buildDisplayCard(
          title: 'جزئیات فنی',
          children: [
            _buildDisplayRow(
              'تعداد طبقات:',
              project.floorCount.toString(),
              Icons.layers_outlined,
            ),
            _buildDisplayRow(
              'سطح زیربنا (متر مربع):',
              project.occupiedArea.toString(),
              Icons.square_foot_outlined,
            ),
            _buildDisplayRow(
              'نوع سیمان:',
              project.cementType,
              Icons.grain_outlined,
            ),
            _buildDisplayRow(
              'نوع قالب:',
              project.moldType,
              Icons.view_in_ar_outlined,
            ),
          ],
        ),
      ],
    );
  }

  // ==================== ویجت‌های حالت ویرایش ====================
  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('edit'),
        children: [
          _buildSectionCard(
            title: 'اطلاعات پایه پروژه',
            children: [
              _buildTextFormField(
                controller: _projectNameController,
                label: 'نام پروژه',
                icon: Icons.business_center_outlined,
              ),
              _buildTextFormField(
                controller: _fileNumberController,
                label: 'شماره پرونده',
                icon: Icons.article_outlined,
              ),
              _buildTextFormField(
                controller: _addressController,
                label: 'آدرس پروژه',
                icon: Icons.location_on_outlined,
              ),
              _buildTextFormField(
                controller: _municipalityZoneController,
                label: 'منطقه شهرداری',
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
                controller: _requesterNameController,
                label: 'نام درخواست‌کننده',
                icon: Icons.person_pin_outlined,
              ),
              _buildTextFormField(
                controller: _requesterPhoneController,
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
              _buildTextFormField(
                controller: _occupiedAreaController,
                label: 'سطح زیربنا (متر مربع)',
                icon: Icons.square_foot_outlined,
                keyboardType: TextInputType.number,
              ),
              _buildDropdownFormField(
                value: _selectedCementType,
                label: 'نوع سیمان',
                items: ['تیپ ۱', 'تیپ ۲', 'تیپ ۳', 'تیپ ۴', 'تیپ ۵', 'سایر'],
                onChanged:
                    (value) => setState(() => _selectedCementType = value),
              ),
              _buildTextFormField(
                controller: _moldTypeController,
                label: 'نوع قالب',
                icon: Icons.view_in_ar_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== ویجت‌های کمکی (Helper Widgets) ====================
  Widget _buildDisplayCard({
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

  Widget _buildDisplayRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label ',
            style: const TextStyle(color: Colors.black54, fontSize: 15),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

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
          if (!readOnly && (value == null || value.isEmpty)) {
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
      ),
    );
  }
}
