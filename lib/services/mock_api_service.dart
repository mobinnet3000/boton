import 'dart:convert';
import '../models/api_response_model.dart';

class MockApiService {
  Future<ApiResponse> fetchData() async {
    // شبیه‌سازی تاخیر شبکه
    await Future.delayed(const Duration(seconds: 1));

    // داده‌ی JSON اینجا قرار می‌گیرد تا از کنترلر جدا باشد
    const String fakeJsonResponse = """{
    "user": {
        "id": 4,
        "username": "finaluser",
        "first_name": "کاربر",
        "last_name": "نهایی",
        "email": "final@example.com",
        "lab_profile": {
            "id": 3,
            "lab_name": "آزمایشگاه جامع تهران",
            "lab_phone_number": "",
            "lab_mobile_number": "09121112233",
            "lab_address": "تهران، میدان آزادی",
            "province": "تهران",
            "city": "تهران",
            "telegram_id": null,
            "first_name": "کاربر",
            "last_name": "نهایی",
            "email": "final@example.com",
            "user": 4
        }
    },
    "projects": [
        {
            "id": 1,
            "created_at": "2025-06-10T10:00:00Z",
            "file_number": "P-101",
            "project_name": "پروژه برج میلاد (با تراکنش)",
            "client_name": "شهرداری تهران",
            "client_phone_number": "0211111",
            "supervisor_name": "مهندس رضایی",
            "supervisor_phone_number": "0912111",
            "requester_name": "درخواست دهنده ۱",
            "requester_phone_number": "0910111",
            "municipality_zone": "منطقه ۲",
            "address": "بزرگراه همت",
            "project_usage_type": "تجاری",
            "floor_count": 20,
            "cement_type": "تیپ ۵",
            "occupied_area": 2500.0,
            "mold_type": "فلزی",
            "contract_price": "1200000000.00",
            "owner": 3,
            "samples": [
                {
                    "id": 7,
                    "date": "2025-09-10T10:00:00Z",
                    "test_type": "فشاری",
                    "sampling_volume": "4 m3",
                    "cement_grade": "C25",
                    "category": "فونداسیون",
                    "weather_condition": "معتدل",
                    "concrete_factory": "بتن شرق",
                    "project": 1,
                    "series": [
                        {
                            "id": 14,
                            "name": "سری نمونه 1",
                            "molds": [],
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.0,
                            "range": "7",
                            "air_percentage": 5.0,
                            "has_additive": false,
                            "sample": 7
                        },
                        {
                            "id": 15,
                            "name": "سری نمونه 2",
                            "molds": [
                                {
                                    "id": 7,
                                    "age_in_days": 7,
                                    "mass": 8.1,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-12T21:56:13.955493Z",
                                    "completed_at": null,
                                    "deadline": "2025-09-17T10:00:00Z",
                                    "sample_identifier": "W-7-1",
                                    "extra_data": { "note": "first mold" },
                                    "series": 15
                                }
                            ],
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "sample": 7
                        }
                    ]
                }
            ],
            "transactions": [
                {
                    "id": 1,
                    "project": 1,
                    "type": "income",
                    "description": "پرداخت اولیه قرارداد",
                    "amount": "500000000.00",
                    "date": "2025-06-11T10:00:00Z"
                },
                {
                    "id": 2,
                    "project": 1,
                    "type": "expense",
                    "description": "هزینه تجهیز کارگاه",
                    "amount": "50000000.00",
                    "date": "2025-06-15T14:00:00Z"
                }
            ],
            "total_income": 500000000.0,
            "total_expense": 50000000.0,
            "balance": 450000000.0
        },
        {
            "id": 2,
            "created_at": "2025-05-01T12:00:00Z",
            "file_number": "P-102",
            "project_name": "پروژه مسکونی الهیه",
            "client_name": "شرکت آرمان سازه",
            "client_phone_number": "02122222222",
            "supervisor_name": "مهندس شریفی",
            "supervisor_phone_number": "09122222222",
            "requester_name": "آقای کریمی",
            "requester_phone_number": "09102222222",
            "municipality_zone": "منطقه 1",
            "address": "تهران، الهیه",
            "project_usage_type": "مسکونی",
            "floor_count": 15,
            "cement_type": "تیپ 1",
            "occupied_area": 800.0,
            "mold_type": "چوبی",
            "contract_price": "750000000.00",
            "owner": 3,
            "samples": [],
            "transactions": [],
            "total_income": 0.0,
            "total_expense": 0.0,
            "balance": 0.0
        }
    ]
}
""";
    final Map<String, dynamic> data = json.decode(fakeJsonResponse);
    return ApiResponse.fromJson(data);
  }
}
