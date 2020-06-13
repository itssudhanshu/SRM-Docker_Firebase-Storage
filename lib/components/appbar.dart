import 'package:flutter/material.dart';

class ConstAppbar extends StatelessWidget {
  final String title;
  const ConstAppbar({
    Key key, this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
    );
  }
}
