import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const MyAppBar({this.title = 'Eczane Kapında', super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F8FB),
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/ic_launcher.png',
            height: 40,
          ),
          const SizedBox(width: 10),
          Text('$title'),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Badge(child: Icon(Icons.notifications_none_outlined)),
        ),
      ],
    );
  }
}
