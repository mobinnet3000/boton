import 'package:boton/models/Sample_model.dart';
import 'package:boton/models/project_model.dart';
import 'package:boton/models/sampling_serie_model.dart';
import 'package:boton/pages/serie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

// فایل‌های پروژه خودتان را import کنید
import 'package:boton/models/concrete_sample_model.dart';
import 'add_sample_page.dart';
import 'sample_detail_page.dart';

//======================================================================
// ۱. ویجت اصلی و نگهدارنده‌ی تب بتن
//======================================================================
class ConcreteTab extends StatelessWidget {
  const ConcreteTab({super.key, required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(text: 'افزودن و مدیریت نمونه'),
              Tab(text: 'لیست کل نمونه‌ها'),
              Tab(text: 'گزارش بتن'),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                AddConcreteView(project: project),
                ConcreteListView(project: project),
                Center(child: Text('گزارش کلی و نمودارهای بتن')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//======================================================================
// ۲. ویجت تب "افزودن و مدیریت نمونه" با منطق نهایی
//======================================================================
class AddConcreteView extends StatefulWidget {
  const AddConcreteView({super.key, required this.project});
  final Project project;

  @override
  State<AddConcreteView> createState() => _AddConcreteViewState();
}

//======================================================================
// ۱. ویجت داخلی و stateful برای محتوای فرم
// این ویجت مسئولیت مدیریت کنترلرها و وضعیت فرم را بر عهده دارد
//======================================================================

// ... (کلاس‌های ConcreteTab و AddConcreteView بدون تغییر باقی می‌مانند) ...

//======================================================================
// ۲. کلاس State بازنویسی شده با داده‌های داینامیک
//======================================================================
class _AddConcreteViewState extends State<AddConcreteView> {
  // دیگر به لیست ثابت _sections نیازی نداریم

  //======================================================================
  // متدهای کمکی برای ساخت UI
  //======================================================================

  /// تابع کمکی برای تبدیل تاریخ میلادی به شمسی
  String _toPersianDate(DateTime date) {
    final f = Jalali.fromDateTime(date);
    return f.toString(); // فرمت YYYY/MM/DD
  }

  /// تابع کمکی برای انتخاب آیکن بر اساس نام بخش
  IconData _getIconForCategory(String categoryName) {
    final nameLower = categoryName.toLowerCase();
    if (nameLower.contains('فونداسیون')) return Icons.foundation;
    if (nameLower.contains('ستون')) return Icons.view_column_outlined;
    if (nameLower.contains('سقف')) return Icons.roofing_outlined;
    if (nameLower.contains('دیوار')) return Icons.view_week_outlined;
    return Icons.category_outlined;
  }

  /// یک ردیف برای نمایش جزئیات (مثلا: نوع آزمون: فشاری)
  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(color: Colors.black54)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// متد نمایش صفحه مودال از پایین (Bottom Sheet) برای مدیریت سری‌های نمونه‌گیری
  void _showSeriesManagementSheet(BuildContext context, Sample sample) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder:
          (ctx) => Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'مدیریت سری‌ها: ${sample.category}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 24),
                if (sample.series.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'هیچ سری نمونه‌گیری برای این نمونه ثبت نشده است.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                else
                  // استفاده از Flexible برای محدود کردن ارتفاع ListView
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: sample.series.length,
                      itemBuilder: (context, index) {
                        final serie = sample.series[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(
                              'اسلامپ: ${serie.slump} - دما: ${serie.concreteTemperature}°C',
                            ),
                            subtitle: Text(
                              'افزودنی: ${serie.hasAdditive ? "دارد" : "ندارد"} - درصد هوا: ${serie.airPercentage}%',
                            ),
                            onTap: () {
                              // ✅✅✅ این بخش را تغییر دهید ✅✅✅
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => SerieDetailPage(
                                        serie: serie,
                                        sampleCategory: 'asdasdasd',
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // ✅ فراخوانی تابع جدید برای نمایش دیالوگ افزودن سری
                    showAddSerieDialog(
                      context: context, // از context اصلی استفاده می‌کنیم
                      sampleId: sample.id, // شناسه نمونه والد را پاس می‌دهیم
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('افزودن سری جدید'),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // لیست نمونه‌ها مستقیما از ویجت پدر خوانده می‌شود
    final List<Sample> samples = widget.project.samples;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child:
                samples.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'هیچ نمونه‌ای برای این پروژه ثبت نشده است.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: samples.length,
                      itemBuilder: (context, index) {
                        final sample = samples[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ExpansionTile(
                            // بخش هدر
                            leading: Icon(
                              _getIconForCategory(sample.category),
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              sample.category,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'تاریخ: ${_toPersianDate(sample.date)}',
                            ),

                            // ✅✅✅ بخش اضافه شده اینجاست ✅✅✅
                            trailing: Chip(
                              label: Text(
                                '${sample.series.length} سری', // نمایش تعداد سری‌های نمونه‌گیری
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              backgroundColor: Colors.grey.shade200,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                            ),
                            // ✅✅✅ پایان بخش اضافه شده ✅✅✅

                            // محتوای بازشونده
                            children: [
                              const Divider(
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                              ),
                              _buildDetailRow(
                                context,
                                Icons.science_outlined,
                                'نوع آزمون',
                                sample.testType,
                              ),
                              _buildDetailRow(
                                context,
                                Icons.speed_outlined,
                                'عیار سیمان',
                                sample.cementGrade,
                              ),
                              _buildDetailRow(
                                context,
                                Icons.factory_outlined,
                                'کارخانه بتن',
                                sample.concreteFactory,
                              ),
                              _buildDetailRow(
                                context,
                                Icons.wb_sunny_outlined,
                                'وضعیت جوی',
                                sample.weatherCondition,
                              ),

                              // دکمه مدیریت سری‌ها
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.settings_outlined),
                                  onPressed:
                                      () => _showSeriesManagementSheet(
                                        context,
                                        sample,
                                      ),
                                  label: const Text(
                                    'مدیریت سری‌های نمونه‌گیری',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.1),
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
          const SizedBox(height: 12),
          // دکمه اصلی افزودن نمونه جدید
          OutlinedButton.icon(
            onPressed: () async {
              final Sample? newSample = await showAddSampleDialog(
                context: context,
                projectId: widget.project.id,
              );
              if (newSample != null) {
                setState(() {
                  // این کد فقط در حالت تستی کار می‌کند
                  // در برنامه واقعی باید نمونه به کنترلر اصلی اضافه شود
                  widget.project.samples.add(newSample);
                });
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('افزودن نمونه جدید'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

//======================================================================
// ۳. ویجت مربوط به تب "لیست کل نمونه‌ها" (کامل شده)
//======================================================================

//======================================================================
// ۱. کلاس کمکی برای نگهداری هر سری نمونه همراه با نمونه والد آن
//======================================================================
class SerieWithContext {
  final SamplingSerie serie;
  final Sample parentSample;

  SerieWithContext({required this.serie, required this.parentSample});
}

//======================================================================
// ۲. ویجت اصلی که لیست سری‌ها را نمایش می‌دهد
//======================================================================
class ConcreteListView extends StatelessWidget {
  final Project project;
  const ConcreteListView({super.key, required this.project});

  /// تابع کمکی برای تبدیل تاریخ میلادی به شمسی
  String _toPersianDate(DateTime date) {
    final f = Jalali.fromDateTime(date);
    return f.toString(); // فرمت YYYY/MM/DD
  }

  @override
  Widget build(BuildContext context) {
    //------------------------------------------------------------------
    // مرحله اول: ساختن یک لیست یکپارچه از تمام سری‌ها در پروژه
    //------------------------------------------------------------------
    final List<SerieWithContext> allSeries = [];
    for (final sample in project.samples) {
      for (final serie in sample.series) {
        allSeries.add(SerieWithContext(serie: serie, parentSample: sample));
      }
    }

    // (اختیاری) مرتب‌سازی لیست بر اساس تاریخ نمونه‌گیری
    allSeries.sort(
      (a, b) => a.parentSample.date.compareTo(b.parentSample.date),
    );

    //------------------------------------------------------------------
    // مرحله دوم: ساخت UI
    //------------------------------------------------------------------
    if (allSeries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'هیچ سری نمونه‌گیری در این پروژه ثبت نشده است.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: allSeries.length,
      itemBuilder: (context, index) {
        final item = allSeries[index];
        final serie = item.serie;
        final parentSample = item.parentSample;

        // پیدا کردن اولین تاریخ شکست برای نمایش در زیرنویس
        String deadlineInfo = 'بدون قالب';
        if (serie.molds.isNotEmpty) {
          // برای اطمینان، قالب‌ها را بر اساس تاریخ مرتب می‌کنیم
          serie.molds.sort((a, b) => a.deadline.compareTo(b.deadline));
          final nextDeadline = serie.molds.first.deadline;
          deadlineInfo = 'تاریخ شکست بعدی: ${_toPersianDate(nextDeadline)}';
        }

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.science_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              // نمایش اینکه کدام سری مربوط به کدام نمونه است
              'سری ${serie.id} - نمونه ${parentSample.category}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(deadlineInfo),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // ✅✅✅ این بخش را تغییر دهید ✅✅✅
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SerieDetailPage(
                        serie: serie,
                        sampleCategory: parentSample.category,
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _AddSampleFormContent extends StatefulWidget {
  // کلید فرم از بیرون به این ویجت داده می‌شود تا به دکمه‌ها دسترسی داشته باشیم
  const _AddSampleFormContent({super.key, this.initialCategory});

  final String? initialCategory;

  @override
  State<_AddSampleFormContent> createState() => _AddSampleFormContentState();
}

class _AddSampleFormContentState extends State<_AddSampleFormContent> {
  final formKey = GlobalKey<FormState>();

  // کنترلرها و متغیرها داخل State تعریف می‌شوند
  late TextEditingController categoryController;
  final dateController = TextEditingController();
  final samplingVolumeController = TextEditingController();
  final concreteFactoryController = TextEditingController();

  DateTime? selectedDate;
  String? selectedTestType = 'فشاری';
  String? selectedCementGrade = 'C25';
  String? selectedWeatherCondition = 'آفتابی';

  @override
  void initState() {
    super.initState();
    categoryController = TextEditingController(text: widget.initialCategory);
  }

  @override
  void dispose() {
    // فلاتر به صورت خودکار و در زمان مناسب این متد را فراخوانی می‌کند
    categoryController.dispose();
    dateController.dispose();
    samplingVolumeController.dispose();
    concreteFactoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('yyyy/MM/dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // این متد فقط UI فرم را می‌سازد
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: 'عنوان نمونه*',
              prefixIcon: Icon(Icons.title),
            ),
            validator: (v) => v!.isEmpty ? 'این فیلد الزامی است' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedTestType,
            decoration: const InputDecoration(
              labelText: 'نوع آزمون*',
              prefixIcon: Icon(Icons.science_outlined),
            ),
            items:
                ['فشاری', 'کششی', 'خمشی']
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
            onChanged: (v) => setState(() => selectedTestType = v!),
            validator: (v) => v == null ? 'این فیلد الزامی است' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: 'تاریخ نمونه‌گیری*',
              prefixIcon: Icon(Icons.calendar_today_outlined),
            ),
            readOnly: true,
            onTap: _selectDate,
            validator: (v) => v!.isEmpty ? 'تاریخ الزامی است' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: samplingVolumeController,
            decoration: const InputDecoration(
              labelText: 'حجم بتن ریزی (m³)',
              prefixIcon: Icon(Icons.opacity_outlined),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedCementGrade,
            decoration: const InputDecoration(
              labelText: 'عیار سیمان*',
              prefixIcon: Icon(Icons.speed_outlined),
            ),
            items:
                ['C20', 'C25', 'C30', 'C35']
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
            onChanged: (v) => setState(() => selectedCementGrade = v!),
            validator: (v) => v == null ? 'این فیلد الزامی است' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedWeatherCondition,
            decoration: const InputDecoration(
              labelText: 'وضعیت جوی*',
              prefixIcon: Icon(Icons.wb_sunny_outlined),
            ),
            items:
                ['آفتابی', 'ابری', 'بارانی', 'برفی']
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
            onChanged: (v) => setState(() => selectedWeatherCondition = v!),
            validator: (v) => v == null ? 'این فیلد الزامی است' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: concreteFactoryController,
            decoration: const InputDecoration(
              labelText: 'نام کارخانه بتن*',
              prefixIcon: Icon(Icons.factory_outlined),
            ),
            validator: (v) => v!.isEmpty ? 'این فیلد الزامی است' : null,
          ),
        ],
      ),
    );
  }
}

//======================================================================
// ۲. تابع اصلی برای نمایش دیالوگ که حالا از ویجت بالا استفاده می‌کند
//======================================================================
Future<Sample?> showAddSampleDialog({
  required BuildContext context,
  required int projectId,
  String? initialCategory,
}) async {
  // یک کلید برای دسترسی به State ویجت فرم از بیرون
  final formWidgetKey = GlobalKey<_AddSampleFormContentState>();

  return showDialog<Sample>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('ایجاد نمونه جدید'),
        content: SingleChildScrollView(
          // ویجت فرم را با کلیدش اینجا قرار می‌دهیم
          child: _AddSampleFormContent(
            key: formWidgetKey,
            initialCategory: initialCategory,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              // با استفاده از کلید، به فرم دسترسی پیدا کرده و آن را validate می‌کنیم
              final formState = formWidgetKey.currentState;
              if (formState != null &&
                  formState.formKey.currentState!.validate()) {
                // مقادیر را از State ویجت فرم می‌خوانیم
                final newSample = Sample(
                  id: 0,
                  date: formState.selectedDate!,
                  testType: formState.selectedTestType!,
                  samplingVolume: formState.samplingVolumeController.text,
                  cementGrade: formState.selectedCementGrade!,
                  category: formState.categoryController.text.trim(),
                  weatherCondition: formState.selectedWeatherCondition!,
                  concreteFactory: formState.concreteFactoryController.text,
                  projectId: projectId,
                  series: const [],
                );

                // دیالوگ را با نتیجه می‌بندیم
                Navigator.pop(ctx, newSample);
                print(newSample);
              }
            },
            child: const Text('ثبت'),
          ),
        ],
      );
    },
  );
}

//======================================================================
// ویجت داخلی و stateful برای فرم "افزودن سری"
//======================================================================
class _AddSerieFormContent extends StatefulWidget {
  // کلید فرم از بیرون به این ویجت داده می‌شود
  const _AddSerieFormContent({super.key});

  @override
  State<_AddSerieFormContent> createState() => __AddSerieFormContentState();
}

class __AddSerieFormContentState extends State<_AddSerieFormContent> {
  final formKey = GlobalKey<FormState>();

  // کنترلرها و متغیرهای فرم
  final _concreteTempController = TextEditingController();
  final _ambientTempController = TextEditingController();
  final _slumpController = TextEditingController();
  final _rangeController = TextEditingController();
  final _airPercentageController = TextEditingController();
  bool _hasAdditive = false;

  @override
  void dispose() {
    // پاک کردن کنترلرها
    _concreteTempController.dispose();
    _ambientTempController.dispose();
    _slumpController.dispose();
    _rangeController.dispose();
    _airPercentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _concreteTempController,
            decoration: const InputDecoration(
              labelText: 'دمای بتن (°C)',
              prefixIcon: Icon(Icons.thermostat_outlined),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ambientTempController,
            decoration: const InputDecoration(
              labelText: 'دمای محیط (°C)',
              prefixIcon: Icon(Icons.wb_sunny_outlined),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _slumpController,
            decoration: const InputDecoration(
              labelText: 'مقدار اسلامپ (cm)',
              prefixIcon: Icon(Icons.format_line_spacing_outlined),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _rangeController,
            decoration: const InputDecoration(
              labelText: 'محدوده (مثال: اسلامپ)',
              prefixIcon: Icon(Icons.unfold_more_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _airPercentageController,
            decoration: const InputDecoration(
              labelText: 'درصد هوا (%)',
              prefixIcon: Icon(Icons.air_outlined),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('افزودنی دارد؟'),
            value: _hasAdditive,
            onChanged: (newValue) {
              setState(() {
                _hasAdditive = newValue;
              });
            },
            secondary: const Icon(Icons.science_outlined),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

//======================================================================
// تابع اصلی برای نمایش دیالوگ "افزودن سری"
//======================================================================
Future<void> showAddSerieDialog({
  required BuildContext context,
  required int sampleId,
}) async {
  // یک کلید برای دسترسی به State ویجت فرم از بیرون
  final formWidgetKey = GlobalKey<__AddSerieFormContentState>();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('افزودن سری نمونه‌گیری'),
        content: SingleChildScrollView(
          child: _AddSerieFormContent(key: formWidgetKey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: در مرحله بعد، منطق ذخیره‌سازی اینجا پیاده‌سازی می‌شود.
              print("دکمه ثبت فشرده شد. در مرحله بعد این بخش کامل می‌شود.");

              // فقط برای نمونه، به مقادیر دسترسی پیدا می‌کنیم و چاپ می‌کنیم
              final formState = formWidgetKey.currentState;
              if (formState != null &&
                  formState.formKey.currentState!.validate()) {
                print(
                  'مقدار اسلامپ وارد شده: ${formState._slumpController.text}',
                );
                print('آیا افزودنی دارد؟: ${formState._hasAdditive}');
              }

              Navigator.pop(ctx);
            },
            child: const Text('ثبت'),
          ),
        ],
      );
    },
  );
}
