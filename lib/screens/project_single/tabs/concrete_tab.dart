import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

// فایل‌های پروژه خودتان را import کنید
import 'package:boton/models/concrete_sample_model.dart';
import 'add_sample_page.dart';
import 'sample_detail_page.dart';

//======================================================================
// ۱. ویجت اصلی و نگهدارنده‌ی تب بتن
//======================================================================
class ConcreteTab extends StatelessWidget {
  const ConcreteTab({super.key});

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
              // Tab(text: 'لیست کل نمونه‌ها'),
              Tab(text: 'گزارش بتن'),
            ],
          ),
          const Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                AddConcreteView(),
                // ConcreteListView(),
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
  const AddConcreteView({super.key});

  @override
  State<AddConcreteView> createState() => _AddConcreteViewState();
}

class _AddConcreteViewState extends State<AddConcreteView> {
  late List<StructuralSection> _sections;
  int? _currentlyExpandedIndex;
  void _showAddSectionDialog() {
      final TextEditingController nameController = TextEditingController();

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('ایجاد بخش جدید'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'نام بخش را وارد کنید (مثلا: فونداسیون شرقی)'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('انصراف'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  setState(() {
                    _sections.add(
                      StructuralSection(name: nameController.text.trim(), samples: []),
                    );
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text('افزودن'),
            ),
          ],
        ),
      );
    }
  @override
  void initState() {
    super.initState();
    // مقادیر ثابت برای داده‌های آزمایشی پروژه
    const String DUMMY_PROJECT_NAME = "پروژه بزرگ تهران";
    const String DUMMY_CLIENT_NAME = "شهرداری تهران";
    const String DUMMY_CASE_NUMBER = "TH-PRJ-1404-01";

    // داده‌های آزمایشی جدید با تمام فیلدهای مورد نیاز
    _sections = [
      StructuralSection(name: 'فونداسیون', samples: [
        ConcreteSample(
          id: 's1',
          sampleNumber: 1,
          projectName: DUMMY_PROJECT_NAME,
          clientName: DUMMY_CLIENT_NAME,
          projectCaseNumber: DUMMY_CASE_NUMBER,
          samplingLocation: 'فونداسیون',
          sampleAgeDays: 7,
          moldCount: 3,
          samplingDate: DateTime(2025, 6, 10),
        ),
        ConcreteSample(
          id: 's2',
          sampleNumber: 2,
          projectName: DUMMY_PROJECT_NAME,
          clientName: DUMMY_CLIENT_NAME,
          projectCaseNumber: DUMMY_CASE_NUMBER,
          samplingLocation: 'فونداسیون',
          sampleAgeDays: 28,
          moldCount: 3,
          samplingDate: DateTime(2025, 6, 10),
        ),
      ]),
      StructuralSection(name: 'ستون طبقه ۱', samples: [
        ConcreteSample(
          id: 's3',
          sampleNumber: 1,
          projectName: DUMMY_PROJECT_NAME,
          clientName: DUMMY_CLIENT_NAME,
          projectCaseNumber: DUMMY_CASE_NUMBER,
          samplingLocation: 'ستون طبقه ۱',
          sampleAgeDays: 7,
          moldCount: 2,
          samplingDate: DateTime(2025, 6, 15),
        ),
      ]),
      StructuralSection(name: 'سقف طبقه ۱', samples: []),
      StructuralSection(name: 'ستون طبقه ۲', samples: []),
    ];
    _currentlyExpandedIndex = null;
  }
  
  //======================================================================
  // متدهای کمکی برای ساخت UI
  //======================================================================

  /// تابع کمکی برای تبدیل تاریخ میلادی به شمسی
  String _toPersianDate(DateTime date) {
    final f = Jalali.fromDateTime(date);
    return f.toString(); // فرمت YYYY/MM/DD
  }

  /// تابع کمکی برای انتخاب آیکن بر اساس نام بخش
  IconData _getIconForSection(String sectionName) {
    if (sectionName.contains('فونداسیون')) return Icons.foundation;
    if (sectionName.contains('ستون')) return Icons.view_column_outlined;
    if (sectionName.contains('سقف')) return Icons.roofing_outlined;
    if (sectionName.contains('دیوار')) return Icons.view_week_outlined;
    return Icons.category_outlined;
  }

  /// متد ساخت هدر پنل (بخش بالایی هر آیتم)
  Widget _buildPanelHeader(StructuralSection section, bool isExpanded) {
    final theme = Theme.of(context);
    final hasSamples = section.samples.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(
            _getIconForSection(section.name),
            color: isExpanded ? theme.primaryColor : Colors.grey[600],
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isExpanded ? theme.primaryColor : Colors.black87,
                  ),
                ),
                if (hasSamples) ...[
                  const SizedBox(height: 4),
                  Text(
                    'تاریخ نمونه‌گیری: ${_toPersianDate(section.samples.first.samplingDate)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
          Chip(
            label: Text(
              '${section.samples.length} نمونه',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
            backgroundColor: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
          )
        ],
      ),
    );
  }

  /// متد ساخت بدنه پنل (محتوایی که بعد از باز شدن نمایش داده می‌شود)
  Widget _buildPanelBody(BuildContext context, StructuralSection section, int sectionIndex) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'نمونه‌های ثبت شده برای "${section.name}" را مدیریت کرده یا نمونه جدیدی اضافه کنید.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSampleManagementSheet(context, sectionIndex),
            label: const Text('ورود به بخش مدیریت نمونه‌ها'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// متد نمایش صفحه مودال از پایین (Bottom Sheet) برای مدیریت نمونه‌ها
  void _showSampleManagementSheet(BuildContext context, int sectionIndex) {
    final section = _sections[sectionIndex];
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'مدیریت نمونه‌ها: ${section.name}',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 24),
            if (section.samples.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 50, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('هیچ نمونه‌ای برای این بخش ثبت نشده است.', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: section.samples.length,
                  itemBuilder: (context, index) {
                    final sample = section.samples[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          child: Text(
                            sample.sampleNumber.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor),
                          ),
                        ),
                        title: Text('نمونه شماره ${sample.sampleNumber}'),
                        subtitle: Text('تاریخ نمونه‌گیری: ${_toPersianDate(sample.samplingDate)}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () {
                          Navigator.pop(ctx);
                          Get.to(() => SampleDetailPage(
                                sample: sample,
                                sectionName: section.name,
                              ));
                        },
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                int nextSampleNum = section.samples.length + 1;
                Get.to(() => AddSamplePage(sectionName: section.name, nextSampleNumber: nextSampleNum));
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('افزودن نمونه جدید'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ExpansionPanelList(
                elevation: 2,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    if (_currentlyExpandedIndex == index) {
                      _currentlyExpandedIndex = null;
                    } else {
                      _currentlyExpandedIndex = index;
                    }
                  });
                },
                children: _sections.asMap().entries.map<ExpansionPanel>((entry) {
                  int index = entry.key;
                  StructuralSection section = entry.value;
                  return ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) => _buildPanelHeader(section, isExpanded),
                    body: _buildPanelBody(context, section, index),
                    isExpanded: _currentlyExpandedIndex == index,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _showAddSectionDialog,
            icon: const Icon(Icons.add),
            label: const Text('افزودن بخش جدید'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45), // تمام عرض
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
class ConcreteListView extends StatelessWidget {
  const ConcreteListView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: این بخش باید به صورت داینامیک از روی لیست کل نمونه‌ها ساخته شود
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: const [
        Card(
          child: ListTile(
            leading: Icon(Icons.document_scanner_outlined, color: Colors.blue),
            title: Text('نمونه ۱ - فونداسیون - سری ۷ روزه'),
            subtitle: Text('تاریخ شکست: ۱۴۰۴/۰۳/۲۷'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.document_scanner_outlined, color: Colors.blue),
            title: Text('نمونه ۲ - فونداسیون - سری ۲۸ روزه'),
            subtitle: Text('تاریخ شکست: ۱۴۰۴/۰۴/۱۸'),
          ),
        ),
      ],
    );
  }
}