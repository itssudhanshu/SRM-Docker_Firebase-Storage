import 'package:flutter/material.dart';
import 'package:srm_notes/constants.dart';

class ConstAppbar extends StatelessWidget {
  final String title;
  const ConstAppbar({
    Key key, this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      centerTitle: true,
      elevation: 0,
      title: Text(title,
      style: TextStyle(
        color: Colors.white,
      ),
      ),
      backgroundColor: kPrimaryColor,
    );
  }
}
