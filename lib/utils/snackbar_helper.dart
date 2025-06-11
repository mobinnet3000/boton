// lib/utils/snackbar_helper.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// یک کلاس کمکی برای نمایش اسنک‌بارهای شیشه‌ای و سفارشی در سراسر برنامه.
/// این کلاس از متدهای استاتیک استفاده می‌کند تا نیازی به ساخت نمونه از آن نباشد.
class SnackbarHelper {
  /// نمایش اسنک‌بار موفقیت (سبز رنگ)
  static void showSuccess({
    required String message,
    String title = 'موفقیت', // عنوان پیش‌فرض
  }) {
    _showGlassSnackbar(
      title: title,
      message: message,
      color: Colors.green.shade700, // رنگ موفقیت
      icon: Icons.check_circle_outline,
    );
  }

  /// نمایش اسنک‌بار خطا (قرمز رنگ)
  static void showError({
    required String message,
    String title = 'خطا', // عنوان پیش‌فرض
  }) {
    _showGlassSnackbar(
      title: title,
      message: message,
      color: Colors.red.shade700, // رنگ خطا
      icon: Icons.error_outline,
    );
  }

  /// نمایش اسنک‌بار هشدار (نارنجی رنگ)
  static void showWarning({
    required String message,
    String title = 'هشدار', // عنوان پیش‌فرض
  }) {
    _showGlassSnackbar(
      title: title,
      message: message,
      color: Colors.orange.shade700, // رنگ هشدار
      icon: Icons.warning_amber_rounded,
    );
  }

  // این یک متد خصوصی است که منطق اصلی ساخت اسنک‌بار شیشه‌ای را در خود دارد
  static void _showGlassSnackbar({
    required String title,
    required String message,
    required Color color,
    required IconData icon,
  }) {
    Get.snackbar(
      '', // عنوان اصلی را خالی می‌گذاریم تا از titleText سفارشی استفاده کنیم
      '', // پیام اصلی را خالی می‌گذاریم تا از messageText سفارشی استفاده کنیم
      titleText: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: Colors.white, size: 24),
        ],
      ),
      messageText: Text(
        message,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Colors.white70, // کمی شفاف‌تر برای خوانایی بهتر
          fontSize: 14,
        ),
      ),
      snackPosition: SnackPosition.TOP, // نمایش در بالای صفحه
      backgroundColor: color.withOpacity(0.4), // پس‌زمینه نیمه‌شفاف
      barBlur: 15.0, // افکت اصلی بلور و شیشه‌ای شدن
      overlayBlur: 1.5, // بلور کردن محتوای زیر اسنک‌بار

      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      borderRadius: 15,

      borderColor: color.withOpacity(0.8), // یک حاشیه برای تاکید بیشتر
      borderWidth: 1.5,

      duration: const Duration(seconds: 2), // مدت زمان نمایش
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }
}


// // lib/utils/snackbar_helper.dart

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SnackbarHelper {
  
//   static void showSuccess({ required String message, String title = 'موفقیت' }) {
//     _showStyledSnackbar(
//       title: title,
//       message: message,
//       gradient: LinearGradient(colors: [Colors.green.shade600, Colors.green.shade800], begin: Alignment.topLeft, end: Alignment.bottomRight),
//       icon: Icons.check_circle,
//     );
//   }

//   static void showError({ required String message, String title = 'خطا' }) {
//     _showStyledSnackbar(
//       title: title,
//       message: message,
//       gradient: LinearGradient(colors: [Colors.red.shade600, Colors.red.shade800], begin: Alignment.topLeft, end: Alignment.bottomRight),
//       icon: Icons.error,
//     );
//   }

//   static void showWarning({ required String message, String title = 'هشدار' }) {
//     _showStyledSnackbar(
//       title: title,
//       message: message,
//       gradient: LinearGradient(colors: [Colors.orange.shade600, Colors.orange.shade800], begin: Alignment.topLeft, end: Alignment.bottomRight),
//       icon: Icons.warning_amber_rounded,
//     );
//   }

//   static void _showStyledSnackbar({
//     required String title,
//     required String message,
//     required Gradient gradient,
//     required IconData icon,
//   }) {
//     Get.snackbar(
//       '', '',
//       titleText: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Text(title, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//           const SizedBox(width: 8),
//           Icon(icon, color: Colors.white, size: 24),
//         ],
//       ),
//       // *** خط اصلاح شده اینجاست ***
//       messageText: Text(
//         message,
//         textAlign: TextAlign.right,
//         style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
//       ),
//       backgroundGradient: gradient,
//       barBlur: 5.0,
//       boxShadows: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.4),
//           offset: const Offset(0, 5),
//           blurRadius: 15,
//         )
//       ],
//       snackPosition: SnackPosition.TOP,
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
//       borderRadius: 15,
//       duration: const Duration(seconds: 4),
//       animationDuration: const Duration(milliseconds: 500),
//       isDismissible: true,
//       forwardAnimationCurve: Curves.easeOutBack,
//       reverseAnimationCurve: Curves.easeInBack,
//     );
//   }
// }
