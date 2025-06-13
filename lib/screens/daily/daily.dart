import 'package:boton/controllers/base_controller.dart';
import 'package:boton/models/mold_model.dart';
import 'package:boton/pages/mold_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalali_table_calendar_plus/jalali_table_calendar_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

//======================================================================
// ۱. مدل CalendarEvent اصلاح شده
//======================================================================
class CalendarEvent {
  final String project;
  final DateTime dateTime;
  final String after;
  final int tedad;
  final List<Mold> molds; // ✅ این فیلد برای نگهداری قالب‌ها اضافه شد

  CalendarEvent({
    required this.project,
    required this.dateTime,
    required this.after,
    required this.tedad,
    required this.molds, // ✅ در کانستراکتور هم اضافه شد
  });
}

//======================================================================
// ۲. ویجت اصلی صفحه
//======================================================================
class Daily extends StatefulWidget {
  const Daily({super.key});

  @override
  _PersianCalendarPageState createState() => _PersianCalendarPageState();
}

class _PersianCalendarPageState extends State<Daily> {
  late final ProjectController _controller;
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<CalendarEvent> _calendarEvents = [];
  List<CalendarEvent> _eventsForSelectedDay = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    // پیدا کردن کنترلر با GetX
    // مطمئن شوید که ProjectController قبلا در جایی از برنامه put شده باشد
    if (Get.isRegistered<ProjectController>()) {
      _controller = Get.find<ProjectController>();
      _processControllerData();

      // گوش دادن به تغییرات در breakageGroups
      _controller.breakageGroups.listen((_) {
        if (mounted) {
          _processControllerData();
        }
      });
    } else {
      // هندل کردن حالتی که کنترلر وجود ندارد
      print("ProjectController not found!");
    }
  }

  void _processControllerData() {
    final newEvents =
        _controller.breakageGroups
            .map((group) {
              if (group.molds.isEmpty) return null;
              return CalendarEvent(
                project: group.projectName,
                dateTime: group.deadline,
                after: "${group.molds.first.ageInDays} روزه",
                tedad: group.molds.length,
                molds: group.molds, // ✅ لیست قالب‌ها اینجا پاس داده می‌شود
              );
            })
            .whereType<CalendarEvent>()
            .toList();

    if (mounted) {
      setState(() {
        _calendarEvents = newEvents;
        if (_selectedDay != null) {
          _eventsForSelectedDay = _getEventsForDay(_selectedDay!);
        }
      });
    }
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _calendarEvents
        .where((event) => isSameDay(event.dateTime, day))
        .toList();
  }

  Map<DateTime, List<CalendarEvent>> _mapEventsByDate(
    List<CalendarEvent> eventList,
  ) {
    // ... این متد بدون تغییر باقی می‌ماند ...
    Map<DateTime, List<CalendarEvent>> events = {};
    for (var event in eventList) {
      final dateKey = DateTime(
        event.dateTime.year,
        event.dateTime.month,
        event.dateTime.day,
      );
      if (events.containsKey(dateKey)) {
        events[dateKey]!.add(event);
      } else {
        events[dateKey] = [event];
      }
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // استفاده از Obx برای واکنش به isLoading کنترلر
          return Obx(() {
            if (Get.isRegistered<ProjectController>() &&
                Get.find<ProjectController>().isLoading.isTrue) {
              return const Center(child: CircularProgressIndicator());
            }

            final isDesktop = constraints.maxWidth >= 800;
            final calendarWidget = Calen(
              focusedDay: _focusedDay,
              events: _mapEventsByDate(_calendarEvents),
              allCalendarEvents: _calendarEvents,
              onDaySelected: (day) {
                setState(() {
                  _selectedDay = day;
                  _eventsForSelectedDay = _getEventsForDay(day);
                });
              },
            );

            // ✅ ویجت لیستینگ حالا context را هم دریافت می‌کند تا بتواند BottomSheet را نمایش دهد
            final listingWidget = FListing(
              eventsForSelectedDay: _eventsForSelectedDay,
              buildContext: context,
            );

            if (isDesktop) {
              return Row(
                children: [
                  Expanded(flex: 2, child: calendarWidget),
                  Expanded(flex: 3, child: listingWidget),
                ],
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: calendarWidget,
                    ),
                    SizedBox(height: 500, child: listingWidget),
                  ],
                ),
              );
            }
          });
        },
      ),
    );
  }
}

//======================================================================
// ۳. ویجت لیستینگ که منطق نمایش قالب‌ها به آن اضافه شده
//======================================================================
class FListing extends StatelessWidget {
  const FListing({
    super.key,
    required this.eventsForSelectedDay,
    required this.buildContext,
  });

  final List<CalendarEvent> eventsForSelectedDay;
  final BuildContext buildContext; // context برای نمایش BottomSheet

  // متد برای نمایش پنل پایینی لیست قالب‌ها
  void _showMoldListSheet(BuildContext context, CalendarEvent event) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'قالب‌های پروژه: ${event.project}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'آزمون ${event.after}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(height: 24),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: event.molds.length,
                  itemBuilder: (context, index) {
                    final mold = event.molds[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(mold.ageInDays.toString()),
                        ),
                        title: Text('شناسه: ${mold.sampleIdentifier}'),
                        subtitle: Text(
                          'ددلاین: ${DateFormat('yyyy/MM/dd').format(mold.deadline)}',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // بستن BottomSheet
                          Navigator.pop(ctx);
                          // رفتن به صفحه جزئیات قالب
                          Get.to(() => MoldDetailPage(mold: mold));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child:
          eventsForSelectedDay.isEmpty
              ? const Center(
                child: Text('هیچ آزمونی برای این روز ثبت نشده است'),
              )
              : ListView.builder(
                itemCount: eventsForSelectedDay.length,
                itemBuilder: (context, index) {
                  final event = eventsForSelectedDay[index];
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
                        event.project,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'نوع تست: ${event.after}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            'تعداد قالب: ${event.tedad} عدد',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      leading: Icon(
                        Icons.build_circle_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Colors.grey,
                      ),
                      // ✅✅✅ تغییر اصلی اینجاست ✅✅✅
                      onTap: () {
                        // با کلیک روی هر رویداد، لیست قالب‌های آن نمایش داده می‌شود
                        _showMoldListSheet(buildContext, event);
                      },
                    ),
                  );
                },
              ),
    );
  }
}

//======================================================================
// ۴. ویجت تقویم (بدون تغییر)
//======================================================================

class Calen extends StatelessWidget {
  const Calen({
    super.key,
    required this.focusedDay,
    required this.events,
    required this.allCalendarEvents,
    required this.onDaySelected,
  });

  final DateTime focusedDay;
  final Map<DateTime, List<dynamic>>? events;
  final List<CalendarEvent> allCalendarEvents; // لیست کامل برای جستجو
  final void Function(DateTime)? onDaySelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade300, Colors.blue.shade400],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: JalaliTableCalendar(
          initialDate: focusedDay,
          onDaySelected: onDaySelected,
          events: events,
          marker: (date, eventsReceivedFromPackage) {
            // ما eventsReceivedFromPackage را نادیده می‌گیریم!
            // و در لیست خودمان جستجو می‌کنیم.
            final correctEventsForThisDay =
                allCalendarEvents
                    .where((event) => isSameDay(event.dateTime, date))
                    .toList();

            if (correctEventsForThisDay.isNotEmpty) {
              final totalMolds = correctEventsForThisDay.fold<int>(
                0,
                (sum, item) => sum + item.tedad,
              );

              if (totalMolds > 0) {
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
                      totalMolds.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }
            }
            return null;
          },
        ),
      ),
    );
  }
}
