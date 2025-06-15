import 'dart:convert';
import '../models/api_response_model.dart';

class MockApiService {
  Future<ApiResponse> fetchData() async {
    // شبیه‌سازی تاخیر شبکه
    await Future.delayed(const Duration(seconds: 1));

    // داده‌ی JSON اینجا قرار می‌گیرد تا از کنترلر جدا باشد
    const String fakeJsonResponse = """{
    "user": {
        "id": 1,
        "username": "mobin",
        "first_name": "نام جدید کاربر",
        "last_name": "فامیلی جدید کاربر",
        "email": "new.email.final@example.com",
        "lab_profile": {
            "id": 1,
            "lab_name": "آزمایشگاه آپدیت شده",
            "lab_phone_number": "",
            "lab_mobile_number": "09129998877",
            "lab_address": "آدرس جدید آزمایشگاه",
            "province": "استان جدید",
            "city": "شهر جدید",
            "telegram_id": null,
            "first_name": "نام جدید کاربر",
            "last_name": "فامیلی جدید کاربر",
            "email": "new.email.final@example.com",
            "user": 1
        },
        "tickets": [
            {
                "id": 1,
                "title": "مشکل در اتصال به API",
                "user": 1,
                "username": "mobin",
                "status": "open",
                "status_display": "باز",
                "priority": "high",
                "priority_display": "بالا",
                "created_at": "2025-06-15T11:36:09.849581Z",
                "updated_at": "2025-06-15T11:36:09.849667Z",
                "messages": [
                    {
                        "id": 1,
                        "ticket": 1,
                        "user": 1,
                        "username": "mobin",
                        "message": "سلام، من با خطای CORS مواجه شده‌ام. لطفا راهنمایی کنید.",
                        "created_at": "2025-06-15T11:36:26.966461Z"
                    }
                ]
            }
        ]
    },
    "projects": [
        {
            "id": 1,
            "owner": 1,
            "created_at": "2025-06-15T10:31:24",
            "file_number": "P-1",
            "project_name": "پروژه دوم",
            "client_name": "شرکت سازنده نوین",
            "client_phone_number": "02188888888",
            "supervisor_name": "مهندس احمدی",
            "supervisor_phone_number": "09121234567",
            "requester_name": "آقای محمدی",
            "requester_phone_number": "09101234567",
            "municipality_zone": "منطقه 5",
            "address": "تهران، جنت آباد",
            "project_usage_type": "مسکونی",
            "floor_count": 12,
            "cement_type": "تیپ 2",
            "occupied_area": 1500.5,
            "mold_type": "پلاستیکی",
            "contract_price": "800000000.00",
            "samples": [
                {
                    "id": 1,
                    "series": [
                        {
                            "id": 1,
                            "name": "سری نمونه 1",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [
                                {
                                    "id": 3,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:10:40.699551Z",
                                    "completed_at": null,
                                    "deadline": "2025-09-17T10:00:00Z",
                                    "sample_identifier": "W-7-1",
                                    "extra_data": null,
                                    "series": 1
                                },
                                {
                                    "id": 4,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:10:51.733564Z",
                                    "completed_at": null,
                                    "deadline": "2025-09-17T10:00:00Z",
                                    "sample_identifier": "W-7-1",
                                    "extra_data": {
                                        "note": "first mold"
                                    },
                                    "series": 1
                                }
                            ],
                            "sample": 1
                        },
                        {
                            "id": 2,
                            "name": "سری نمونه 2",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 1
                        },
                        {
                            "id": 3,
                            "name": "سری نمونه 3",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 1
                        },
                        {
                            "id": 4,
                            "name": "سری نمونه 4",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 1
                        }
                    ],
                    "date": "2025-09-10T10:00:00Z",
                    "test_type": "فشاری",
                    "sampling_volume": "4 m3",
                    "cement_grade": "C25",
                    "category": "دیوار برشی",
                    "weather_condition": "معتدل",
                    "concrete_factory": "بتن شرق",
                    "project": 1
                },
                {
                    "id": 2,
                    "series": [
                        {
                            "id": 5,
                            "name": "سری نمونه 1",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 2
                        },
                        {
                            "id": 6,
                            "name": "سری نمونه 2",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 2
                        },
                        {
                            "id": 7,
                            "name": "سری نمونه 3",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 2
                        },
                        {
                            "id": 8,
                            "name": "سری نمونه 4",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 2
                        },
                        {
                            "id": 9,
                            "name": "سری نمونه 5",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 2
                        }
                    ],
                    "date": "2025-09-10T10:00:00Z",
                    "test_type": "فشاری",
                    "sampling_volume": "4 m3",
                    "cement_grade": "C25",
                    "category": "فنداسیون",
                    "weather_condition": "معتدل",
                    "concrete_factory": "بتن شرق",
                    "project": 1
                },
                {
                    "id": 7,
                    "series": [],
                    "date": "2025-09-10T10:00:00Z",
                    "test_type": "فشاری",
                    "sampling_volume": "4 m3",
                    "cement_grade": "C25",
                    "category": "ستون اول",
                    "weather_condition": "معتدل",
                    "concrete_factory": "بتن شرق",
                    "project": 1
                },
                {
                    "id": 8,
                    "series": [],
                    "date": "2025-09-10T10:00:00Z",
                    "test_type": "فشاری",
                    "sampling_volume": "4 m3",
                    "cement_grade": "C25",
                    "category": "سقف اول",
                    "weather_condition": "معتدل",
                    "concrete_factory": "بتن شرق",
                    "project": 1
                }
            ],
            "transactions": [],
            "total_income": 0.0,
            "total_expense": 0.0,
            "balance": 0.0
        },
        {
            "id": 2,
            "owner": 1,
            "created_at": "2025-06-15T10:33:40",
            "file_number": "P-2",
            "project_name": "پروژه جدید از Postman",
            "client_name": "شرکت سازنده نوین",
            "client_phone_number": "02188888888",
            "supervisor_name": "مهندس احمدی",
            "supervisor_phone_number": "09121234567",
            "requester_name": "آقای محمدی",
            "requester_phone_number": "09101234567",
            "municipality_zone": "منطقه 5",
            "address": "تهران، جنت آباد",
            "project_usage_type": "مسکونی",
            "floor_count": 12,
            "cement_type": "تیپ 2",
            "occupied_area": 1500.5,
            "mold_type": "پلاستیکی",
            "contract_price": "500000000.00",
            "samples": [
                {
                    "id": 3,
                    "series": [
                        {
                            "id": 10,
                            "name": "سری نمونه 1",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 3
                        },
                        {
                            "id": 11,
                            "name": "سری نمونه 2",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 3
                        },
                        {
                            "id": 12,
                            "name": "سری نمونه 3",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 3
                        },
                        {
                            "id": 13,
                            "name": "سری نمونه 4",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 3
                        },
                        {
                            "id": 14,
                            "name": "سری نمونه 5",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 3
                        }
                    ],
                    "date": "2025-09-10T10:00:00Z",
                    "test_type": "فشاری",
                    "sampling_volume": "4 m3",
                    "cement_grade": "C25",
                    "category": "فنداسیون",
                    "weather_condition": "معتدل",
                    "concrete_factory": "بتن شرق",
                    "project": 2
                },
                {
                    "id": 6,
                    "series": [],
                    "date": "2025-09-10T10:00:00Z",
                    "test_type": "فشاری",
                    "sampling_volume": "4 m3",
                    "cement_grade": "C25",
                    "category": "ستون اول",
                    "weather_condition": "معتدل",
                    "concrete_factory": "بتن شرق",
                    "project": 2
                },
                {
                    "id": 9,
                    "series": [
                        {
                            "id": 23,
                            "name": "سری نمونه 1",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [
                                {
                                    "id": 17,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:49:03.831226Z",
                                    "completed_at": null,
                                    "deadline": "2025-06-22T11:49:03.830829Z",
                                    "sample_identifier": "سقف اول-7d-1",
                                    "extra_data": null,
                                    "series": 23
                                },
                                {
                                    "id": 18,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:49:03.831276Z",
                                    "completed_at": null,
                                    "deadline": "2025-06-22T11:49:03.830829Z",
                                    "sample_identifier": "سقف اول-7d-2",
                                    "extra_data": null,
                                    "series": 23
                                },
                                {
                                    "id": 19,
                                    "age_in_days": 28,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:49:03.831304Z",
                                    "completed_at": null,
                                    "deadline": "2025-07-13T11:49:03.830829Z",
                                    "sample_identifier": "سقف اول-28d-3",
                                    "extra_data": null,
                                    "series": 23
                                },
                                {
                                    "id": 20,
                                    "age_in_days": 90,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:49:03.831329Z",
                                    "completed_at": null,
                                    "deadline": "2025-09-13T11:49:03.830829Z",
                                    "sample_identifier": "سقف اول-90d-4",
                                    "extra_data": null,
                                    "series": 23
                                }
                            ],
                            "sample": 9
                        }
                    ],
                    "date": "2025-09-10T10:00:00Z",
                    "test_type": "فشاری",
                    "sampling_volume": "4 m3",
                    "cement_grade": "C25",
                    "category": "سقف اول",
                    "weather_condition": "معتدل",
                    "concrete_factory": "بتن شرق",
                    "project": 2
                }
            ],
            "transactions": [],
            "total_income": 0.0,
            "total_expense": 0.0,
            "balance": 0.0
        },
        {
            "id": 3,
            "owner": 1,
            "created_at": "2025-06-15T10:34:33",
            "file_number": "P-5",
            "project_name": "پروژه میلاد",
            "client_name": "شرکت سازنده نوین",
            "client_phone_number": "02188888888",
            "supervisor_name": "مهندس احمدی",
            "supervisor_phone_number": "09121234567",
            "requester_name": "آقای محمدی",
            "requester_phone_number": "09101234567",
            "municipality_zone": "منطقه 5",
            "address": "تهران، جنت آباد",
            "project_usage_type": "مسکونی",
            "floor_count": 12,
            "cement_type": "تیپ 2",
            "occupied_area": 1500.5,
            "mold_type": "پلاستیکی",
            "contract_price": "1000000000.00",
            "samples": [
                {
                    "id": 4,
                    "series": [
                        {
                            "id": 15,
                            "name": "سری نمونه 1",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 4
                        },
                        {
                            "id": 16,
                            "name": "سری نمونه 2",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 4
                        },
                        {
                            "id": 17,
                            "name": "سری نمونه 3",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [],
                            "sample": 4
                        },
                        {
                            "id": 18,
                            "name": "سری نمونه 4",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [
                                {
                                    "id": 1,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:03:22.589091Z",
                                    "completed_at": null,
                                    "deadline": "2025-09-17T10:00:00Z",
                                    "sample_identifier": "W-7-1",
                                    "extra_data": {
                                        "note": "first mold"
                                    },
                                    "series": 18
                                }
                            ],
                            "sample": 4
                        },
                        {
                            "id": 19,
                            "name": "سری نمونه 5",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [
                                {
                                    "id": 2,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:04:06.559788Z",
                                    "completed_at": "2025-06-15T11:03:22.589091Z",
                                    "deadline": "2025-09-17T10:00:00Z",
                                    "sample_identifier": "W-7-1",
                                    "extra_data": {
                                        "note": "first mold"
                                    },
                                    "series": 19
                                }
                            ],
                            "sample": 4
                        }
                    ],
                    "date": "2025-09-10T10:00:00Z",
                    "test_type": "فشاری",
                    "sampling_volume": "4 m3",
                    "cement_grade": "C25",
                    "category": "فنداسیون",
                    "weather_condition": "معتدل",
                    "concrete_factory": "بتن شرق",
                    "project": 3
                },
                {
                    "id": 5,
                    "series": [
                        {
                            "id": 20,
                            "name": "سری نمونه 1",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [
                                {
                                    "id": 5,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:47:51.540227Z",
                                    "completed_at": null,
                                    "deadline": "2025-06-22T11:47:51.539430Z",
                                    "sample_identifier": "ستون اول-7d-1",
                                    "extra_data": null,
                                    "series": 20
                                },
                                {
                                    "id": 6,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:47:51.540335Z",
                                    "completed_at": null,
                                    "deadline": "2025-06-22T11:47:51.539430Z",
                                    "sample_identifier": "ستون اول-7d-2",
                                    "extra_data": null,
                                    "series": 20
                                },
                                {
                                    "id": 7,
                                    "age_in_days": 28,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:47:51.540385Z",
                                    "completed_at": null,
                                    "deadline": "2025-07-13T11:47:51.539430Z",
                                    "sample_identifier": "ستون اول-28d-3",
                                    "extra_data": null,
                                    "series": 20
                                },
                                {
                                    "id": 8,
                                    "age_in_days": 90,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:47:51.540430Z",
                                    "completed_at": null,
                                    "deadline": "2025-09-13T11:47:51.539430Z",
                                    "sample_identifier": "ستون اول-90d-4",
                                    "extra_data": null,
                                    "series": 20
                                }
                            ],
                            "sample": 5
                        }
                    ],
                    "date": "2025-09-10T10:00:00Z",
                    "test_type": "فشاری",
                    "sampling_volume": "4 m3",
                    "cement_grade": "C25",
                    "category": "ستون اول",
                    "weather_condition": "معتدل",
                    "concrete_factory": "بتن شرق",
                    "project": 3
                },
                {
                    "id": 10,
                    "series": [
                        {
                            "id": 21,
                            "name": "سری نمونه 1",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [
                                {
                                    "id": 9,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:48:08.167422Z",
                                    "completed_at": null,
                                    "deadline": "2025-06-22T11:48:08.166835Z",
                                    "sample_identifier": "سقف اول-7d-1",
                                    "extra_data": null,
                                    "series": 21
                                },
                                {
                                    "id": 10,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:48:08.167515Z",
                                    "completed_at": null,
                                    "deadline": "2025-06-22T11:48:08.166835Z",
                                    "sample_identifier": "سقف اول-7d-2",
                                    "extra_data": null,
                                    "series": 21
                                },
                                {
                                    "id": 11,
                                    "age_in_days": 28,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:48:08.167565Z",
                                    "completed_at": null,
                                    "deadline": "2025-07-13T11:48:08.166835Z",
                                    "sample_identifier": "سقف اول-28d-3",
                                    "extra_data": null,
                                    "series": 21
                                },
                                {
                                    "id": 12,
                                    "age_in_days": 90,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:48:08.167614Z",
                                    "completed_at": null,
                                    "deadline": "2025-09-13T11:48:08.166835Z",
                                    "sample_identifier": "سقف اول-90d-4",
                                    "extra_data": null,
                                    "series": 21
                                }
                            ],
                            "sample": 10
                        },
                        {
                            "id": 22,
                            "name": "سری نمونه 2",
                            "concrete_temperature": 29.0,
                            "ambient_temperature": 31.0,
                            "slump": 7.5,
                            "range": "7-9",
                            "air_percentage": 2.0,
                            "has_additive": false,
                            "molds": [
                                {
                                    "id": 13,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:48:14.007658Z",
                                    "completed_at": null,
                                    "deadline": "2025-06-22T11:48:14.007284Z",
                                    "sample_identifier": "سقف اول-7d-1",
                                    "extra_data": null,
                                    "series": 22
                                },
                                {
                                    "id": 14,
                                    "age_in_days": 7,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:48:14.007711Z",
                                    "completed_at": null,
                                    "deadline": "2025-06-22T11:48:14.007284Z",
                                    "sample_identifier": "سقف اول-7d-2",
                                    "extra_data": null,
                                    "series": 22
                                },
                                {
                                    "id": 15,
                                    "age_in_days": 28,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:48:14.007741Z",
                                    "completed_at": null,
                                    "deadline": "2025-07-13T11:48:14.007284Z",
                                    "sample_identifier": "سقف اول-28d-3",
                                    "extra_data": null,
                                    "series": 22
                                },
                                {
                                    "id": 16,
                                    "age_in_days": 90,
                                    "mass": 0.0,
                                    "breaking_load": 0.0,
                                    "created_at": "2025-06-15T11:48:14.007767Z",
                                    "completed_at": null,
                                    "deadline": "2025-09-13T11:48:14.007284Z",
                                    "sample_identifier": "سقف اول-90d-4",
                                    "extra_data": null,
                                    "series": 22
                                }
                            ],
                            "sample": 10
                        }
                    ],
                    "date": "2025-09-10T10:00:00Z",
                    "test_type": "فشاری",
                    "sampling_volume": "4 m3",
                    "cement_grade": "C25",
                    "category": "سقف اول",
                    "weather_condition": "معتدل",
                    "concrete_factory": "بتن شرق",
                    "project": 3
                }
            ],
            "transactions": [],
            "total_income": 0.0,
            "total_expense": 0.0,
            "balance": 0.0
        }
    ]
}""";
    final Map<String, dynamic> data = json.decode(fakeJsonResponse);
    return ApiResponse.fromJson(data);
  }
}
