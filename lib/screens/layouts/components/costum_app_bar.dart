import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  // Constructor برای دریافت عنوان اپ بار
  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title , style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white, // رنگ پس‌زمینه اپ بار
      elevation: 8, // افزایش ارتفاع برای ایجاد سایه
      shadowColor: const Color.fromARGB(115, 0, 0, 0),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh), // آیکون جستجو
          onPressed: () {
            // عملکردی که هنگام زدن آیکون جستجو انجام می‌شود
            print('Search clicked');
          },
        ),
        IconButton(
          icon: Icon(Icons.logout_outlined), // آیکون اعلان‌ها
          onPressed: () {
            // عملکردی که هنگام زدن آیکون اعلان‌ها انجام می‌شود
            print('Notifications clicked');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // ارتفاع اپ بار
}
