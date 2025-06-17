// screens/project/project_single/tabs/concrete/serie_detail_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

// ✅ مدل‌های خودتان را import کنید
import '../../../../../models/mold_model.dart';
import '../../../../../models/sampling_serie_model.dart';
import '../../../../../controllers/base_controller.dart'; // کنترلر GetX شما

/// ویجت اصلی صفحه جزئیات یک سری نمونه‌گیری (بدون تغییر)
class SerieDetailPage extends StatelessWidget {
  final SamplingSerie serie;
  final int projectId;
  final int sampleId;

  const SerieDetailPage({
    super.key,
    required this.serie,
    required this.projectId,
    required this.sampleId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('جزئیات سری: ${serie.name}'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: serie.molds.length,
        itemBuilder: (context, index) {
          final mold = serie.molds[index];
          return MoldDataTile(
            key: ValueKey(mold.id),
            mold: mold,
            onSave: (Map<String, dynamic> updatedData) async {
              // ... منطق ذخیره‌سازی شما بدون تغییر باقی می‌ماند
              print('Saving data for mold id ${mold.id}...');
              print('Data: $updatedData');
              // await Get.find<ProjectController>().updateMoldResult(...);
              Get.snackbar(
                'موفقیت',
                'اطلاعات شکست برای قالب ${mold.ageInDays} روزه ثبت شد.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ✅✅✅ ویجت آکاردئونی با منطق نهایی و کاملاً صحیح ✅✅✅
// -----------------------------------------------------------------------------
class MoldDataTile extends StatefulWidget {
  final Mold mold;
  final Future<void> Function(Map<String, dynamic> data) onSave;

  const MoldDataTile({
    super.key,
    required this.mold,
    required this.onSave,
  });

  @override
  State<MoldDataTile> createState() => _MoldDataTileState();
}

class _MoldDataTileState extends State<MoldDataTile> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _massController;
  late final TextEditingController _loadController;
  late final TextEditingController _breakDateController;

  late bool _isMarkedAsDone;
  DateTime? _selectedBreakDate;

  @override
  void initState() {
    super.initState();
    _isMarkedAsDone = widget.mold.isDone;
    _selectedBreakDate = widget.mold.completedAt;

    _massController = TextEditingController(
        text: widget.mold.mass > 0 ? widget.mold.mass.toString() : '');
    _loadController = TextEditingController(
        text: widget.mold.breakingLoad > 0
            ? widget.mold.breakingLoad.toString()
            : '');
    _breakDateController = TextEditingController(
      text: _selectedBreakDate != null ? _toPersianDate(_selectedBreakDate!) : '',
    );
  }
  
  // سایر متدها (_dispose, _toPersianDate, _getTileColor, etc.) بدون تغییر هستند...

  @override
  void dispose() {
    _massController.dispose();
    _loadController.dispose();
    _breakDateController.dispose();
    super.dispose();
  }

  String _toPersianDate(DateTime date) {
    final f = Jalali.fromDateTime(date).formatter;
    return '${f.yyyy}/${f.mm}/${f.dd}';
  }

  Color _getTileColor(BuildContext context) {
    if (widget.mold.isDone) return Colors.green.withOpacity(0.12);
    final now = DateTime.now();
    if (DateUtils.isSameDay(now, widget.mold.deadline)) return Colors.orange.withOpacity(0.15);
    if (now.isAfter(widget.mold.deadline)) return Colors.red.withOpacity(0.12);
    return Theme.of(context).cardColor;
  }
  
  Color _getLeadingColor(BuildContext context) {
    if (widget.mold.isDone) return Colors.green;
    final now = DateTime.now();
    if (DateUtils.isSameDay(now, widget.mold.deadline)) return Colors.orange.shade700;
    if (now.isAfter(widget.mold.deadline)) return Colors.red;
    return Colors.grey.shade400;
  }

  Future<void> _selectBreakDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBreakDate ?? DateTime.now(),
      firstDate: widget.mold.createdAt,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedBreakDate = pickedDate;
        _breakDateController.text = _toPersianDate(pickedDate);
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    
    if (_isMarkedAsDone && _selectedBreakDate == null) {
      _selectedBreakDate = DateTime.now();
    }
    
    final updatedData = {
      'mass': double.tryParse(_massController.text) ?? 0.0,
      'breaking_load': double.tryParse(_loadController.text) ?? 0.0,
      'completed_at': _isMarkedAsDone ? _selectedBreakDate?.toIso8601String() : null,
    };
    widget.onSave(updatedData);
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      color: _getTileColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _getTileColor(context).withOpacity(0.5), width: 1),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getLeadingColor(context).withOpacity(0.15),
          child: Text(widget.mold.ageInDays.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: _getLeadingColor(context))),
        ),
        title: Text('قالب ${widget.mold.ageInDays} روزه', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('موعد شکست: ${_toPersianDate(widget.mold.deadline)}'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoRow('تاریخ نمونه‌گیری:', _toPersianDate(widget.mold.createdAt)),
                  _buildInfoRow('شناسه نمونه:', widget.mold.sampleIdentifier),
                  const Divider(height: 1),
                  
                  SwitchListTile(
                    title: const Text('ثبت نتایج شکست', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _isMarkedAsDone,
                    onChanged: (newValue) {
                      setState(() {
                        _isMarkedAsDone = newValue;
                        if (!newValue) {
                          _selectedBreakDate = null;
                          _breakDateController.clear();
                          _massController.clear();
                          _loadController.clear();
                        }
                      });
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _breakDateController,
                    decoration: const InputDecoration(labelText: 'تاریخ واقعی شکست', prefixIcon: Icon(Icons.calendar_today_outlined)),
                    readOnly: true,
                    // ✅✅✅ تغییر کلیدی اینجا اعمال شد ✅✅✅
                    enabled: _isMarkedAsDone,
                    onTap: _isMarkedAsDone ? _selectBreakDate : null, 
                    validator: (v) => v!.isEmpty ? 'تاریخ الزامی است' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _massController,
                    decoration: const InputDecoration(labelText: 'جرم نمونه (گرم)', prefixIcon: Icon(Icons.scale_outlined)),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    enabled: _isMarkedAsDone, 
                    validator: (v) => v!.isEmpty ? 'جرم الزامی است' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _loadController,
                    decoration: const InputDecoration(labelText: 'بار گسیختگی (kN)', prefixIcon: Icon(Icons.line_weight_rounded)),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    enabled: _isMarkedAsDone,
                    validator: (v) => v!.isEmpty ? 'بار گسیختگی الزامی است' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isMarkedAsDone ? _submitForm : null,
                    icon: const Icon(Icons.save_alt_outlined),
                    label: const Text('ذخیره نتایج'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}