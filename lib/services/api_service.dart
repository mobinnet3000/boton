import 'dart:convert';

import 'package:boton/models/ProjectForCreation_model.dart';
import 'package:boton/models/Sample_model.dart';
import 'package:boton/models/mold_model.dart';
import 'package:boton/models/project_model.dart';
import 'package:boton/models/sampling_serie_model.dart';
import 'package:boton/models/ticket_model.dart';
import 'package:boton/models/transaction_model.dart';
import 'package:boton/models/user_model.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import '../models/api_response_model.dart'; // اطمینان حاصل کنید که این مدل را ساخته‌اید

class ApiService {
  final Dio _dio;

  // سازنده کلاس که یک نمونه از Dio را دریافت می‌کند
  ApiService(this._dio);
  Future<Mold> updateMold(int moldId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(
        '/api/molds/$moldId/', // اندپوینت آپدیت قالب
        data: data,
      );
      // پاسخ موفق را به صورت یک شیء Mold برمی‌گردانیم
      return Mold.fromJson(response.data);
    } on DioException catch (e) {
      // خطا را برای مدیریت در کنترلر، دوباره پرتاب می‌کنیم
      print('ApiService Error updating mold: ${e.response?.data}');
      throw Exception('Failed to update mold');
    }
  }

  // متد برای دریافت داده‌های جامع کاربر
  Future<ApiResponse> getFullUserData() async {
    try {
      // ارسال درخواست GET به اندپوینت full-data
      final response = await _dio.get('https://django.chbk.app/api/full-data/');

      // بررسی موفقیت‌آمیز بودن پاسخ (کد 200)
      if (response.statusCode == 200) {
        // تبدیل پاسخ JSON به مدل ApiResponse
        return ApiResponse.fromJson(response.data);
      } else {
        // در صورت بروز خطای غیرمنتظره در پاسخ
        throw Exception(
          'Failed to load data, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // مدیریت خطاهای احتمالی Dio یا خطاهای شبکه
      // می‌توانید اینجا لاگ بگیرید یا خطای مشخص‌تری را برگردانید
      print('Error fetching full data: $e');
      throw Exception('Failed to connect to the server or process data.');
    }
  }

  Future<Project> createProject(ProjectForCreation newProjectData) async {
    try {
      // درخواست POST به اندپوینت پروژه‌ها ارسال می‌شود.
      // متد toJson که ساختید، داده‌ها را برای ارسال آماده می‌کند.
      final response = await _dio.post(
        'https://django.chbk.app/api/projects/',
        data: newProjectData.toJson(),
      );

      // اگر سرور با کد 201 (Created) پاسخ دهد، یعنی پروژه با موفقیت ساخته شده.
      if (response.statusCode == 201) {
        // سرور، پروژه کامل (با id و تاریخ) را برمی‌گرداند.
        // ما آن را به مدل کامل Project تبدیل کرده و برمی‌گردانیم.
        return Project.fromJson(response.data);
      } else {
        // اگر کد وضعیت دیگری دریافت شد، خطا پرتاب می‌کنیم.
        throw Exception(
          'Failed to create project. Status Code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // مدیریت خطاهای شبکه از Dio
      print('Dio Error creating project: ${e.response?.data ?? e.message}');
      throw Exception('خطا در ارتباط با سرور.');
    } catch (e) {
      // مدیریت خطاهای دیگر
      print('Unexpected Error creating project: $e');
      throw Exception('خطای پیش‌بینی نشده.');
    }
  }

  Future<Project> updateProject(int projectId, Project projectToUpdate) async {
    try {
      // ما از مدل ProjectForCreation استفاده می‌کنیم تا فقط فیلدهای قابل ویرایش ارسال شوند
      // این کار باعث می‌شود فیلدهای read-only مانند samples یا transactions ارسال نشوند.
      final updateData = ProjectForCreation(
        fileNumber: projectToUpdate.fileNumber,
        projectName: projectToUpdate.projectName,
        clientName: projectToUpdate.clientName,
        clientPhoneNumber: projectToUpdate.clientPhoneNumber,
        supervisorName: projectToUpdate.supervisorName,
        supervisorPhoneNumber: projectToUpdate.supervisorPhoneNumber,
        requesterName: projectToUpdate.requesterName,
        requesterPhoneNumber: projectToUpdate.requesterPhoneNumber,
        municipalityZone: projectToUpdate.municipalityZone,
        address: projectToUpdate.address,
        projectUsageType: projectToUpdate.projectUsageType,
        floorCount: projectToUpdate.floorCount,
        cementType: projectToUpdate.cementType,
        occupiedArea: projectToUpdate.occupiedArea,
        moldType: projectToUpdate.moldType,
        contractPrice: projectToUpdate.contractPrice,
      );

      // ارسال درخواست PUT به اندپوینت مشخص شده با ID پروژه
      final response = await _dio.put(
        '/api/projects/$projectId/',
        data: updateData.toJson(),
      );

      if (response.statusCode == 200) {
        // سرور پروژه کامل و به‌روز شده را برمی‌گرداند
        return Project.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to update project. Status Code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('خطا در ارتباط با سرور: ${e.message}');
    } catch (e) {
      throw Exception('خطای پیش‌بینی نشده در به‌روزرسانی پروژه.');
    }
  }

  Future<LabProfile> updateLab(int profileId, LabProfile labToUpdate) async {
    try {
      // ما از مدل ProjectForCreation استفاده می‌کنیم تا فقط فیلدهای قابل ویرایش ارسال شوند
      // این کار باعث می‌شود فیلدهای read-only مانند samples یا transactions ارسال نشوند.
      final updateData = LabProfile(
        id: labToUpdate.id,
        labName: labToUpdate.labName,
        labPhoneNumber: labToUpdate.labPhoneNumber,
        labMobileNumber: labToUpdate.labMobileNumber,
        labAddress: labToUpdate.labAddress,
        province: labToUpdate.province,
        city: labToUpdate.city,
        firstName: labToUpdate.firstName,
        lastName: labToUpdate.lastName,
        email: labToUpdate.email,
        userId: labToUpdate.userId,
      );

      // ارسال درخواست PUT به اندپوینت مشخص شده با ID پروژه
      final response = await _dio.put(
        '/api/profiles/$profileId/',
        data: updateData.toJson(),
      );

      if (response.statusCode == 200) {
        // سرور پروژه کامل و به‌روز شده را برمی‌گرداند
        return LabProfile.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to update project. Status Code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('خطا در ارتباط با سرور: ${e.message}');
    } catch (e) {
      throw Exception('خطای پیش‌بینی نشده در به‌روزرسانی پروژه.');
    }
  }

  Future<LabProfile> updateProfile(
    int profileId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _dio.put(
        'api/profiles/$profileId/',
        data: profileData,
      );
      if (response.statusCode == 200) {
        return LabProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to update profile');
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?.toString() ?? e.message ?? 'خطای ناشناخته';
      throw Exception('خطا در آپدیت پروفایل: $errorMessage');
    }
  }

  Future<Sample> createSample(Map<String, dynamic> sampleData) async {
    try {
      // ارسال درخواست POST به اندپوینت نمونه‌ها
      final response = await _dio.post('/api/samples/', data: sampleData);

      if (response.statusCode == 201) {
        // پاسخ موفقیت‌آمیز را به مدل Sample تبدیل کرده و برمی‌گردانیم
        return Sample.fromJson(response.data);
      } else {
        throw Exception('Failed to create sample on server');
      }
    } on DioException catch (e) {
      // مدیریت خطاهای شبکه و نمایش پیام واضح‌تر
      print('Dio Error creating sample: ${e.response?.data ?? e.message}');
      throw Exception('خطا در ارتباط با سرور هنگام ایجاد نمونه.');
    }
  }

  Future<Ticket> createtiket(Map<String, dynamic> tiketData) async {
    try {
      // ارسال درخواست POST به اندپوینت نمونه‌ها
      final response = await _dio.post('/api/tickets/', data: tiketData);

      if (response.statusCode == 201) {
        // پاسخ موفقیت‌آمیز را به مدل Sample تبدیل کرده و برمی‌گردانیم
        return Ticket.fromJson(response.data);
      } else {
        throw Exception('Failed to create sample on server');
      }
    } on DioException catch (e) {
      // مدیریت خطاهای شبکه و نمایش پیام واضح‌تر
      print('Dio Error creating sample: ${e.response?.data ?? e.message}');
      throw Exception('خطا در ارتباط با سرور هنگام ایجاد تیکت.');
    }
  }

  Future<TicketMessage> createtiketmas(
    Map<String, dynamic> tiketmasData,
  ) async {
    try {
      // ارسال درخواست POST به اندپوینت نمونه‌ها
      final response = await _dio.post(
        '/api/ticket-messages/',
        data: tiketmasData,
      );

      if (response.statusCode == 201) {
        // پاسخ موفقیت‌آمیز را به مدل Sample تبدیل کرده و برمی‌گردانیم
        return TicketMessage.fromJson(response.data);
      } else {
        throw Exception('Failed to create sample on server');
      }
    } on DioException catch (e) {
      // مدیریت خطاهای شبکه و نمایش پیام واضح‌تر
      print('Dio Error creating sample: ${e.response?.data ?? e.message}');
      throw Exception('خطا در ارتباط با سرور هنگام ایجاد تیکت.');
    }
  }

  Future<Transaction> createTrans(Map<String, dynamic> sampleData) async {
    try {
      // ارسال درخواست POST به اندپوینت نمونه‌ها
      final response = await _dio.post('/api/transactions/', data: sampleData);

      if (response.statusCode == 201) {
        // پاسخ موفقیت‌آمیز را به مدل Sample تبدیل کرده و برمی‌گردانیم
        return Transaction.fromJson(response.data);
      } else {
        throw Exception('Failed to create transactions on server');
      }
    } on DioException catch (e) {
      // مدیریت خطاهای شبکه و نمایش پیام واضح‌تر
      print(
        'Dio Error creating transactions: ${e.response?.data ?? e.message}',
      );
      throw Exception('خطا در ارتباط با سرور هنگام ایجاد نمونه.');
    }
  }

  // در کلاس ApiService

  Future<SamplingSerie> createSerie(Map<String, dynamic> serieData) async {
    // ۲. تعریف آدرس کامل و هدرها به صورت دستی
    // مطمئن شوید IP و پورت صحیح است
    final url = Uri.parse('https://django.chbk.app/api/series/');

    // توکن خود را مستقیماً اینجا قرار دهید
    const String authToken = '1a9a3c2b359a18bdb1ea2a32bb0b3e4dc28128b9';

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $authToken',
    };

    // ۳. تبدیل بدنه درخواست به رشته JSON
    final body = json.encode(serieData);

    print('Sending request to: $url');
    print('With body: $body');

    try {
      // ۴. ارسال درخواست با پکیج http
      final response = await http.post(url, headers: headers, body: body);

      // ۵. بررسی پاسخ سرور
      if (response.statusCode == 201) {
        // برای پشتیبانی از کاراکترهای فارسی، پاسخ را با utf8 دیکود می‌کنیم
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        return SamplingSerie.fromJson(responseBody);
      } else {
        // اگر سرور پاسخ خطا داد، آن را نمایش می‌دهیم
        print('Server Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('خطای سرور: ${response.statusCode}');
      }
    } catch (e) {
      // این بخش خطاهای اتصال شبکه را مدیریت می‌کند
      print('HTTP Client Error: $e');
      throw Exception(
        'خطا در برقراری ارتباط با سرور. لطفاً اتصال و آدرس را چک کنید.',
      );
    }
  }
}

class DioClient {
  // توکن احراز هویت شما
  static const String _manualAuthToken =
      '1a9a3c2b359a18bdb1ea2a32bb0b3e4dc28128b9';

  // نمونه Singleton از Dio
  static final Dio _dio = Dio(
      BaseOptions(
        // ✅✅✅ تنها تغییر لازم اینجاست ✅✅✅
        // پیشوند /api به انتهای آدرس پایه اضافه شد
        baseUrl: 'https://django.chbk.app',

        connectTimeout: const Duration(seconds: 25),
        receiveTimeout: const Duration(seconds: 25),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $_manualAuthToken',
          'User-Agent': 'PostmanRuntime/7.29.2',
          'Accept': '*/*',
        },
      ),
    )
    ..interceptors.add(
      // Interceptor برای لاگ کردن درخواست‌ها (بسیار مفید و عالی)
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

  // Getter برای دسترسی به نمونه Dio
  static Dio get instance => _dio;
}
