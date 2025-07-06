import 'package:boton/models/Sample_model.dart';
import 'package:boton/models/project_model.dart';
import 'package:boton/models/sampling_serie_model.dart';
import 'package:boton/screens/project/project_single/tabs/concrete/concrete_tab.dart';
import 'package:boton/screens/project/project_single/tabs/concrete/serie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

//======================================================================
// ۳. ویجت مربوط به تب "لیست کل نمونه‌ها" (کامل شده)
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
              // ✅✅✅ این بخش کامل می‌شود ✅✅✅
              Navigator.of(context).pop(); // اول BottomSheet را می‌بندیم
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SerieDetailPage(
                    serieId: serie.id, // فقط ID را پاس می‌دهیم
                    projectId: project.id,
                    sampleId: parentSample.id,
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

//======================================================================
// ۱. کلاس کمکی برای نگهداری هر سری نمونه همراه با نمونه والد آن
//======================================================================
class SerieWithContext {
  final SamplingSerie serie;
  final Sample parentSample;

  SerieWithContext({required this.serie, required this.parentSample});
}
