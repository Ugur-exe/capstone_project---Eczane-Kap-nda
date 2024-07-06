import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyListTileWidget extends StatelessWidget {
  String type;
  Icon icon;
  final VoidCallback function;
  MyListTileWidget(
      {required this.type,
      required this.icon,
      required this.function,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(type),
      onTap: () {
        function();
      },
    );
  }
}
