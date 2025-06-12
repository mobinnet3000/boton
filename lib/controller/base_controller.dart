// project_controller.dart

import 'dart:convert';

import 'package:get/get.dart';
import 'package:collection/collection.dart';

// ... (مسیر مدل‌های خود را اینجا به درستی ایمپورت کنید)
import '../models/user_model.dart';
import '../models/project_model.dart';
import '../models/breakage_group_model.dart';
import '../models/mold_model.dart';


// کلاس کمکی که قبلا تعریف کردیم
class _MoldWithProjectInfo {
  final Mold mold;
  final String projectId;
  final String projectName;
  _MoldWithProjectInfo({ required this.mold, required this.projectId, required this.projectName });
}


class ProjectController extends GetxController {
  // --- وضعیت‌ها ---
  var isLoading = true.obs;
  var user = Rxn<User>();
  var projects = <Project>[].obs;
  var breakageGroups = <BreakageGroup>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("ProjectController onInit called. Fetching data..."); // برای دیباگ
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(seconds: 2));

      // ... (جیسون کامل اینجا قرار دارد)
      const String fakeJsonResponse = """{ "user": { "id": "user-a1b2c3", "phoneNumber": "021-88776655", "firstName": "علی", "lastName": "رضایی", "labName": "آزمایشگاه بتن تهران", "labPhoneNumber": "021-44556677", "labMobileNumber": "09123456789", "labAddress": "تهران، خیابان آزادی، کوچه شماره ۵، پلاک ۱۰", "province": "تهران", "city": "تهران", "telegramId": "@alirezaei_lab" }, "projects": [ { "id": "proj-001", "fileNumber": "SH-98-110", "projectName": "پروژه مسکونی برج امید", "clientName": "شرکت ساختمانی آینده", "clientPhoneNumber": "09121112233", "supervisorName": "مهندس محمدی", "supervisorPhoneNumber": "09124445566", "requesterName": "آقای احمدی", "requesterPhoneNumber": "09127778899", "municipalityZone": "منطقه ۲", "address": "تهران، سعادت آباد، میدان کاج، برج امید", "projectUsageType": "مسکونی", "floorCount": 15, "cementType": "تیپ ۲", "occupiedArea": 850.5, "moldType": "فلزی مکعبی", "samples": [ { "id": "sample-p1-01", "date": "2025-06-10T10:00:00Z", "testType": "فشاری", "samplingVolume": "2.5 متر مکعب", "cementGrade": "C30", "category": "بتن سقف", "weatherCondition": "آفتابی", "concreteFactory": "بتن آماده پاسارگاد", "series": [ { "id": "serie-p1s1-01", "concreteTemperature": 28.5, "ambientTemperature": 31.0, "slump": 8.0, "range": "7-9", "airPercentage": 2.1, "hasAdditive": 1, "molds": [ { "id": "mold-A-01", "ageInDays": 7, "mass": 8.1, "breakingLoad": 25.5, "createdAt": "2025-06-10T10:00:00Z", "completedAt": null, "deadline": "2025-06-17T10:00:00Z", "sampleIdentifier": "A-7-1", "extraData": { "notes": "سطح صاف و بدون ترک" } }, { "id": "mold-A-02", "ageInDays": 28, "mass": 8.2, "breakingLoad": 0.0, "createdAt": "2025-06-10T10:00:00Z", "completedAt": null, "deadline": "2025-07-08T10:00:00Z", "sampleIdentifier": "A-28-1", "extraData": {} } ] } ] } ] }, { "id": "proj-002", "fileNumber": "TJ-01-250", "projectName": "پروژه تجاری آریا", "clientName": "هلدینگ آریا", "clientPhoneNumber": "09151112233", "supervisorName": "مهندس شریفی", "supervisorPhoneNumber": "09154445566", "requesterName": "آقای حسینی", "requesterPhoneNumber": "09157778899", "municipalityZone": "منطقه ۱", "address": "مشهد، بلوار سجاد، مرکز خرید آریا", "projectUsageType": "تجاری", "floorCount": 5, "cementType": "تیپ ۵", "occupiedArea": 2500.0, "moldType": "پلاستیکی استوانه‌ای", "samples": [ { "id": "sample-p2-01", "date": "2025-05-20T14:30:00Z", "testType": "کششی", "samplingVolume": "5 متر مکعب", "cementGrade": "C40", "category": "بتن فونداسیون", "weatherCondition": "ابری", "concreteFactory": "بتن شرق", "series": [ { "id": "serie-p2s1-01", "concreteTemperature": 25.0, "ambientTemperature": 22.5, "slump": 10.0, "range": "9-11", "airPercentage": 1.8, "hasAdditive": 0, "molds": [ { "id": "mold-B-01", "ageInDays": 7, "mass": 12.5, "breakingLoad": 0.0, "createdAt": "2025-05-20T14:30:00Z", "completedAt": null, "deadline": "2025-06-17T10:00:00Z", "sampleIdentifier": "B-7-1", "extraData": {} } ] } ] } ] } ] }""";
      
      final data = json.decode(fakeJsonResponse) as Map<String, dynamic>;
      user.value = User.fromJson(data['user'] as Map<String, dynamic>);
      final projectsData = data['projects'] as List<dynamic>;
      projects.value = projectsData.map((p) => Project.fromJson(p as Map<String, dynamic>)).toList();
      
      print("Data parsing complete. User: ${user.value?.fullName}"); // برای دیباگ

      groupMoldsForBreakage();

    } catch (e, stacktrace) {
      Get.snackbar('خطا!', 'یک خطا در حین پردازش داده‌ها رخ داد.');
      print("Error in fetchData: $e"); // برای دیباگ
      print("Stacktrace: $stacktrace"); // برای دیباگ
    } finally {
      isLoading(false);
      print("isLoading is now false."); // برای دیباگ
    }
  }

  void groupMoldsForBreakage() {
    // ... (منطق گروه‌بندی مثل قبل، دست نخورده باقی می‌ماند)
    final List<_MoldWithProjectInfo> allMoldsWithInfo = [];
    for (var project in projects) { for (var sample in project.samples) { for (var serie in sample.series) { for (var mold in serie.molds) { allMoldsWithInfo.add(_MoldWithProjectInfo(mold: mold, projectId: project.id, projectName: project.projectName)); } } } }
    final groupedData = groupBy(allMoldsWithInfo, (info) => '${info.projectId}-${info.mold.deadline.toIso8601String()}');
    final List<BreakageGroup> result = [];
    groupedData.forEach((key, groupItems) { if (groupItems.isNotEmpty) { result.add(BreakageGroup(projectId: groupItems.first.projectId, projectName: groupItems.first.projectName, deadline: groupItems.first.mold.deadline, molds: groupItems.map((info) => info.mold).toList())); } });
    result.sort((a, b) => a.deadline.compareTo(b.deadline));
    breakageGroups.value = result;
    print("Grouping complete. Found ${breakageGroups.length} breakage groups."); // برای دیباG
  }
}