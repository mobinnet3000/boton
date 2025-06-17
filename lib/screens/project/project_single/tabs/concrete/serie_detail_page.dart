// screens/project/project_single/tabs/concrete/serie_detail_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

// ✅ مدل‌های خودتان را import کنید
import '../../../../../models/mold_model.dart';
import '../../../../../models/sampling_serie_model.dart';

/// ویجت اصلی صفحه جزئیات یک سری نمونه‌گیری
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
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        // ✅ حالا لیست آیتم‌ها، همان لیست قالب‌های (molds) موجود در سری است
        itemCount: serie.molds.length,
        itemBuilder: (context, index) {
          final mold = serie.molds[index];
          return MoldDataTile(
            // ✅ کل شیء mold به ویجت فرزند پاس داده می‌شود
            key: ValueKey(mold.id), // استفاده از id برای پایداری ویجت
            mold: mold,
            onSave: (Map<String, dynamic> updatedData) async {
              // ✅ اینجا متد کنترلر را برای ذخیره داده‌ها فراخوانی می‌کنید
              print('Saving data for mold id ${mold.id}...');
              print('Data: $updatedData');

              // کد نهایی شما شبیه به این خواهد بود:
              // await Get.find<ProjectController>().updateMoldResult(
              //   projectId: projectId,
              //   sampleId: sampleId,
              //   serieId: serie.id,
              //   moldId: mold.id,
              //   resultData: updatedData,
              // );

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
// ویجت آکاردئونی برای نمایش و ویرایش اطلاعات یک قالب (کاملاً سازگار شده)
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

  late bool _isBreakTime;
  DateTime? _selectedBreakDate;

  @override
  void initState() {
    super.initState();
    // ✅ بررسی اینکه آیا زمان شکست (deadline) فرا رسیده است یا خیر
    _isBreakTime = DateTime.now().isAfter(widget.mold.deadline) ||
        DateUtils.isSameDay(DateTime.now(), widget.mold.deadline);

    // مقداردهی اولیه کنترلرها با داده‌های موجود در شیء mold
    // اگر مقدار اولیه 0.0 بود، فیلد را خالی نمایش می‌دهیم
    _massController = TextEditingController(
        text: widget.mold.mass > 0 ? widget.mold.mass.toString() : '');
    _loadController = TextEditingController(
        text: widget.mold.breakingLoad > 0
            ? widget.mold.breakingLoad.toString()
            : '');
    
    _selectedBreakDate = widget.mold.completedAt;
    _breakDateController = TextEditingController(
      text: _selectedBreakDate != null ? _toPersianDate(_selectedBreakDate!) : '',
    );
  }

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

  Future<void> _selectBreakDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBreakDate ?? DateTime.now(),
      // ✅ تاریخ شروع از زمان ساخت قالب است
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
    if (_formKey.currentState!.validate()) {
      // ✅ ساخت یک Map از داده‌های جدید برای ارسال به کنترلر
      final updatedData = {
        'mass': double.tryParse(_massController.text) ?? 0.0,
        'breaking_load': double.tryParse(_loadController.text) ?? 0.0,
        // ✅ تاریخ تکمیل (شکست) را به فرمت استاندارد ISO 8601 می‌فرستیم
        'completed_at': _selectedBreakDate?.toIso8601String(),
      };
      widget.onSave(updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ✅ وضعیت ثبت شده بر اساس فیلد completedAt مشخص می‌شود
    final isSubmitted = widget.mold.completedAt != null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isSubmitted
              ? Colors.green
              : (_isBreakTime ? theme.primaryColor : Colors.grey.shade400),
          foregroundColor: Colors.white,
          child: Text(
            widget.mold.ageInDays.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          'قالب ${widget.mold.ageInDays} روزه',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('تاریخ شکست مطلوب: ${_toPersianDate(widget.mold.deadline)}'),
        trailing: isSubmitted ? const Icon(Icons.check_circle, color: Colors.green) : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoRow('شناسه نمونه:', widget.mold.sampleIdentifier),
                  _buildInfoRow('تاریخ نمونه‌گیری:', _toPersianDate(widget.mold.createdAt)),
                  const Divider(height: 24),
                  
                  // فیلدهای ورود اطلاعات
                  TextFormField(
                    controller: _breakDateController,
                    decoration: const InputDecoration(
                      labelText: 'تاریخ شکست واقعی',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    readOnly: true,
                    onTap: _isBreakTime ? _selectBreakDate : null, // ✅ قفل کردن فیلد
                    validator: (v) => v!.isEmpty ? 'تاریخ الزامی است' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _massController,
                    decoration: const InputDecoration(
                      labelText: 'جرم نمونه (گرم)',
                      prefixIcon: Icon(Icons.scale_outlined),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    enabled: _isBreakTime, // ✅ قفل کردن فیلد
                    validator: (v) => v!.isEmpty ? 'جرم الزامی است' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _loadController,
                    decoration: const InputDecoration(
                      labelText: 'بار گسیختگی (kN)',
                      prefixIcon: Icon(Icons.line_weight_rounded),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    enabled: _isBreakTime, // ✅ قفل کردن فیلد
                    validator: (v) => v!.isEmpty ? 'بار گسیختگی الزامی است' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isBreakTime ? _submitForm : null, // ✅ قفل کردن دکمه
                    icon: const Icon(Icons.save_alt_outlined),
                    label: const Text('ثبت نتایج شکست'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  if (!_isBreakTime)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        'امکان ثبت نتایج قبل از رسیدن به تاریخ شکست وجود ندارد.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red.shade700),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold,)),
        ],
      ),
    );
  }
}