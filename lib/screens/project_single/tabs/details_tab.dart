import 'package:boton/models/project.dart';
import 'package:flutter/material.dart';
// Assume project_model.dart is in this path
// import '../../models/project_model.dart';

class DetailsTab extends StatefulWidget {
  final Project project;
  const DetailsTab({super.key, required this.project});

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers for the edit form, initialized in initState
  late TextEditingController _nameController;
  late TextEditingController _clientNameController;
  late TextEditingController _clientPhoneController;
  late TextEditingController _supervisorNameController;
  late TextEditingController _supervisorPhoneController;
  late TextEditingController _applicantNameController;
  late TextEditingController _applicantPhoneController;
  late TextEditingController _addressController;
  late TextEditingController _contractorController;
  late TextEditingController _contractNumberController;
  late TextEditingController _floorCountController;
  late TextEditingController _totalCostController;
  late TextEditingController _concreteProducerController;
  late TextEditingController _descriptionController;
  late TextEditingController _contractDateController;
  late TextEditingController _municipalDistrictController;

  // State for Dropdowns and Radios
  late String? _selectedProjectType;
  late String? _selectedCementType;
  late String? _selectedStrength;
  late String _selectedTestType;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final project = widget.project;
    _nameController = TextEditingController(text: project.name);
    _clientNameController = TextEditingController(text: project.clientName);
    _clientPhoneController = TextEditingController(text: project.clientPhone);
    _supervisorNameController = TextEditingController(
      text: project.supervisorName,
    );
    _supervisorPhoneController = TextEditingController(
      text: project.supervisorPhone,
    );
    _applicantNameController = TextEditingController(
      text: project.applicantName,
    );
    _applicantPhoneController = TextEditingController(
      text: project.applicantPhone,
    );
    _addressController = TextEditingController(text: project.address);
    _contractorController = TextEditingController(text: project.contractor);
    _contractNumberController = TextEditingController(
      text: project.contractNumber,
    );
    _floorCountController = TextEditingController(
      text: project.floorCount.toString(),
    );
    _totalCostController = TextEditingController(
      text: project.totalCost.toString(),
    );
    _concreteProducerController = TextEditingController(
      text: project.concreteProducer,
    );
    _descriptionController = TextEditingController(text: project.description);
    _contractDateController = TextEditingController(text: project.contractDate);
    _municipalDistrictController = TextEditingController(
      text: project.municipalDistrict,
    );

    _selectedProjectType = project.projectType;
    _selectedCementType = project.cementType;
    _selectedStrength = project.characteristicStrength;
    _selectedTestType = project.projectid;
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _nameController.dispose();
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _supervisorNameController.dispose();
    _supervisorPhoneController.dispose();
    _applicantNameController.dispose();
    _applicantPhoneController.dispose();
    _addressController.dispose();
    _contractorController.dispose();
    _contractNumberController.dispose();
    _floorCountController.dispose();
    _totalCostController.dispose();
    _concreteProducerController.dispose();
    _descriptionController.dispose();
    _contractDateController.dispose();
    _municipalDistrictController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        // If we were editing, save the changes
        if (_formKey.currentState!.validate()) {
          // Here you would typically save the updated project to your database or state management
          // For now, we just show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تغییرات با موفقیت ذخیره شد'),
              backgroundColor: Colors.green,
            ),
          );
          _isEditing = false;
        }
      } else {
        // If we were not editing, just enter edit mode
        _isEditing = true;
      }
    });
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

  // ==================== DISPLAY MODE WIDGETS ====================
  Widget _buildDisplayInfo() {
    final project = widget.project;
    return Column(
      key: const ValueKey('display'),
      children: [
        _buildDisplayCard(
          title: 'اطلاعات پایه',
          children: [
            _buildDisplayRow('نام پروژه:', project.name, Icons.title),
            _buildDisplayRow(
              'آدرس:',
              project.address,
              Icons.location_on_outlined,
            ),
            _buildDisplayRow(
              'منطقه شهرداری:',
              project.municipalDistrict,
              Icons.map_outlined,
            ),
            _buildDisplayRow(
              'نوع پروژه:',
              project.projectType,
              Icons.business_outlined,
            ),
          ],
        ),
        _buildDisplayCard(
          title: 'اشخاص و کارفرما',
          children: [
            _buildDisplayRow(
              'نام کارفرما:',
              project.clientName,
              Icons.person_outline,
            ),
            _buildDisplayRow(
              'تماس کارفرما:',
              project.clientPhone,
              Icons.phone_outlined,
            ),
            _buildDisplayRow(
              'نام ناظر:',
              project.supervisorName,
              Icons.engineering_outlined,
            ),
            _buildDisplayRow(
              'تماس ناظر:',
              project.supervisorPhone,
              Icons.phone_outlined,
            ),
          ],
        ),
        _buildDisplayCard(
          title: 'جزئیات فنی و قرارداد',
          children: [
            _buildDisplayRow(
              'آزمون اصلی:',
              project.projectid,
              Icons.science_outlined,
            ),
            _buildDisplayRow(
              'تعداد طبقات:',
              '${project.floorCount}',
              Icons.layers_outlined,
            ),
            _buildDisplayRow(
              'نوع سیمان:',
              project.cementType,
              Icons.grain_outlined,
            ),
            _buildDisplayRow(
              'مقاومت مشخصه:',
              project.characteristicStrength,
              Icons.speed_outlined,
            ),
            _buildDisplayRow(
              'شماره قرارداد:',
              project.contractNumber,
              Icons.article_outlined,
            ),
            _buildDisplayRow(
              'تاریخ قرارداد:',
              project.contractDate,
              Icons.calendar_today_outlined,
            ),
          ],
        ),
      ],
    );
  }

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

  // ==================== EDIT MODE WIDGETS (similar to AddProjectPage) ====================
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
                items: ['تیپ ۱', 'تیپ ۲', 'تیپ ۳', 'تیپ ۴', 'تیپ ۵', 'سایر'],
                onChanged:
                    (value) => setState(() => _selectedCementType = value),
              ),
              _buildDropdownFormField(
                value: _selectedStrength,
                label: 'مقاومت مشخصه',
                items: ['C20', 'C25', 'C30', 'C35', 'C40', 'C50'],
                onChanged: (value) => setState(() => _selectedStrength = value),
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
