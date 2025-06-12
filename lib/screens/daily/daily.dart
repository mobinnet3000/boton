import 'package:boton/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:jalali_table_calendar_plus/jalali_table_calendar_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shamsi_date/shamsi_date.dart';

class shecast {
  final String project;
  final DateTime dateTime;
  final String sampeling;
  final String after;
  final int tedad;

  shecast({
    required this.project,
    required this.dateTime,
    required this.sampeling,
    required this.after,
    required this.tedad,
  });
}

class Daily extends StatefulWidget {
  const Daily({super.key});

  @override
  _PersianCalendarPageState createState() => _PersianCalendarPageState();
}

class _PersianCalendarPageState extends State<Daily> {
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<shecast> _patientsForSelectedDay = [];

  List<shecast> samples = List.generate(100, (index) {
    final month = (index % 2 == 0) ? 5 : 6; // خرداد (3) یا تیر (4)
    final day = (index % 30) + 1; // روزهای 1 تا 30

    return shecast(
      project: "پروژه ${index + 1}",
      dateTime: DateTime(2025, month, day),
      sampeling:
          index % 3 == 0 ? "فنداسیون" : (index % 3 == 1 ? "دیوار" : "سقف"),
      after: "${(index % 5) + 3} روزه",
      tedad: (index % 5) + 1,
    );
  });

  String _formatJalali(DateTime dt) {
    final f = Jalali.fromDateTime(dt);
    return '${f.year}/${f.month.toString().padLeft(2, '0')}/${f.day.toString().padLeft(2, '0')}';
  }

  List<shecast> _getPatientsForDay(DateTime day) {
    return samples.where((p) => isSameDay(p.dateTime, day)).toList();
  }

  Map<DateTime, List<shecast>> mapByDate(List<shecast> slist) {
    Map<DateTime, List<shecast>> events = {};

    for (var samp in slist) {
      final dateKey = DateTime(
        samp.dateTime.year,
        samp.dateTime.month,
        samp.dateTime.day,
      );

      if (events.containsKey(dateKey)) {
        events[dateKey]!.add(samp);
      } else {
        events[dateKey] = [samp];
      }
    }

    return events;
  }

  // List<shecast> get allPatients => patients;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 800) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 600),
                    width: double.infinity,
                    child: calen(
                      focusedDay: _focusedDay,
                      events: mapByDate(samples),
                      onDaySelected: (day) {
                        setState(() {
                          _selectedDay = day;
                          _patientsForSelectedDay = _getPatientsForDay(day);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: FListing(
                      patientsForSelectedDay: _patientsForSelectedDay,
                      allSamples: samples, // <-- لیست کامل نمونه‌ها را اینجا پاس دهید
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // سمت چپ: تقویم
                Expanded(
                  flex: 2,
                  child: calen(
                    focusedDay: _focusedDay,
                    events: mapByDate(samples),
                    onDaySelected: (day) {
                      setState(() {
                        _selectedDay = day;
                        _patientsForSelectedDay = _getPatientsForDay(day);
                      });
                    },
                  ),
                ),
                // سمت راست: لیست جلسات
                Expanded(
                  flex: 3,
                  child: FListing(
                    patientsForSelectedDay: _patientsForSelectedDay,
                    allSamples: samples, // <-- لیست کامل نمونه‌ها را اینجا پاس دهید
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
class FListing extends StatelessWidget {
  const FListing({
    super.key,
    required this.patientsForSelectedDay,
    required this.allSamples,
  });

  final List<shecast> patientsForSelectedDay;
  final List<shecast> allSamples;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child:
          // 'patientsForSelectedDay' به جای '_patientsForSelectedDay'
          patientsForSelectedDay.isEmpty 
              ? const Center(child: Text('هیچ جلسه‌ای برای این روز وجود ندارد'))
              : ListView.builder(
                  // 'patientsForSelectedDay' به جای '_patientsForSelectedDay'
                  itemCount: patientsForSelectedDay.length,
                  itemBuilder: (context, index) {
                    // 'patientsForSelectedDay' به جای '_patientsForSelectedDay'
                    final p = patientsForSelectedDay[index];
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          p.project,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'نوع نمونه‌گیری: تست ${p.after} ${p.sampeling}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              'تعداد قالب:${p.tedad} عدد',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        leading: Icon(
                          Icons.build,
                          color: Theme.of(context).primaryColor,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          final String projectName = p.project;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('در حال آماده‌سازی برای ناوبری به پروژه: $projectName'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class calen extends StatefulWidget {
  const calen({
    super.key,
    // required List<shecast> patientsForSelectedDay,
    required this.focusedDay,
    required this.events,
    required this.onDaySelected,
  });

  // final List<shecast> _patientsForSelectedDay;
  final DateTime focusedDay;
  final void Function(DateTime)? onDaySelected;
  final Map<DateTime, List<dynamic>>? events;

  @override
  State<calen> createState() => _calenState();
}

class _calenState extends State<calen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade300, Colors.blue.shade400],
          ),
          borderRadius: BorderRadius.circular(12), // حاشیه گرد
        ),
        child: JalaliTableCalendar(
          customHolyDays: [],
          direction: TextDirection.rtl,
          initialDate: widget.focusedDay,
          range: false,
          useOfficialHolyDays: true,
          option: JalaliTableCalendarOption(
            showHeader: true, // نمایش هدر تقویم
            showHeaderArrows: true, // نمایش فلش‌های ناوبری برای تغییر ماه
            headerStyle: TextStyle(
              color: Colors.white, // رنگ متن هدر
              fontSize: 20, // اندازه قلم
              fontWeight: FontWeight.bold, // ضخامت قلم
              letterSpacing: 1.2, // فاصله بین حروف
            ),
            daysOfWeekStyle: TextStyle(
              color: Colors.blueGrey[800], // رنگ روزهای هفته (ملایم و مدرن)
              fontSize: 16, // اندازه قلم روزهای هفته
              fontWeight: FontWeight.w600, // ضخامت قلم روزهای هفته
            ),
            daysStyle: TextStyle(
              color: Colors.black87, // رنگ روزهای ماه (تیره و خوانا)
              fontSize: 16, // اندازه قلم روزهای ماه
              fontWeight: FontWeight.w400, // ضخامت قلم روزهای ماه
            ),
            currentDayColor:
                Colors.teal[400], // رنگ روز جاری (آبی فیروزه‌ای ملایم)
            selectedDayColor:
                Colors.deepPurple[600], // رنگ روز انتخاب شده (بنفش تیره)
            selectedDayShapeColor:
                Colors.deepPurple[200], // رنگ حاشیه روز انتخاب شده (بنفش روشن)
            daysOfWeekTitles: [
              'ش',
              'ی',
              'د',
              'س',
              'چ',
              'پ',
              'ج',
            ], // عنوان روزهای هفته به فارسی
            headerPadding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ), // حاشیه هدر
          ),

          events: widget.events,
          onDaySelected: widget.onDaySelected,
          marker: (date, event) {
            if (event.isNotEmpty) {
              // print(
              //   event[0].last
              //       .fold(0, (sum, item) => sum + item.tedad)
              //       .toString(),
              // );
              return Positioned(
                top: -2,
                left: 1,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal,
                  ),
                  child: Text(
                    event[0].last
                        .fold(0, (sum, item) => sum + item.tedad)
                        .toString(),
                  ),
                  // child: Text(event[0].last.length.toString()),
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
