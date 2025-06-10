import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              Tab(text: 'لیست کل نمونه‌ها'),
              Tab(text: 'گزارش بتن'),
            ],
          ),
          const Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                AddConcreteView(),
                ConcreteListView(),
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

  @override
  void initState() {
    super.initState();
    // داده‌های آزمایشی
    _sections = [
      StructuralSection(name: 'فونداسیون', samples: [
        ConcreteSample(id: 's1', sampleNumber: 1),
        ConcreteSample(id: 's2', sampleNumber: 2),
      ]),
      StructuralSection(name: 'ستون طبقه ۱', samples: [
        ConcreteSample(id: 's3', sampleNumber: 1),
      ]),
      StructuralSection(name: 'سقف طبقه ۱', samples: []),
      StructuralSection(name: 'ستون طبقه ۲', samples: []),
    ];
    _currentlyExpandedIndex = null;
  }

  void _showSampleManagementSheet(BuildContext context, int sectionIndex) {
    final section = _sections[sectionIndex];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('مدیریت نمونه‌ها: ${section.name}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(height: 24),
            const Text('نمونه‌های موجود:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (section.samples.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: Text('هیچ نمونه‌ای برای این بخش ثبت نشده است.')),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: section.samples.map((sample) => ListTile(
                        title: Text('نمونه ${sample.sampleNumber}'),
                        leading: const Icon(Icons.science_outlined),
                        onTap: () {
                          Navigator.pop(ctx); 
                          Get.to(() => SampleDetailPage(
                                sample: sample,
                                sectionName: section.name,
                              ));
                        },
                      )).toList(),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                int nextSampleNum = section.samples.length + 1;
                Get.to(() => AddSamplePage(sectionName: section.name, nextSampleNumber: nextSampleNum));
              },
              icon: const Icon(Icons.add),
              label: const Text('افزودن نمونه جدید'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
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
    );
  }

  Widget _buildPanelHeader(StructuralSection section, bool isExpanded) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              section.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isExpanded ? Theme.of(context).primaryColor : Colors.black87,
              ),
            ),
          ),
          Chip(
            label: Text('${section.samples.length} نمونه'),
            backgroundColor: Colors.grey.shade200,
          )
        ],
      ),
    );
  }

  Widget _buildPanelBody(BuildContext context, StructuralSection section, int sectionIndex) {
    return ListTile(
      title: const Text('برای افزودن یا مشاهده نمونه‌ها کلیک کنید.'),
      trailing: ElevatedButton.icon(
        icon: const Icon(Icons.edit_note),
        onPressed: () => _showSampleManagementSheet(context, sectionIndex),
        label: const Text('مدیریت نمونه‌ها'),
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
            title: Text('نمونه ۲ - فونداسیون - سری ۷ روزه'),
            subtitle: Text('تاریخ شکست: ۱۴۰۴/۰۳/۲۷'),
          ),
        ),
      ],
    );
  }
}
