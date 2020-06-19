//import 'dart:js';

import 'package:flutter/material.dart';
import 'constants.dart';
import 'MediaQueryGetSize.dart';

class DrawCustomAppBar extends CustomPainter {
  var height;
  BuildContext context;

  DrawCustomAppBar({this.height = 17, this.context});
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final pagesize = context != null ? SizeConfig().init(context) : 0;
    final paint = Paint();
    // set the paint color to be white
    paint.color = Colors.white;
    paint.color = Color(appBarColor);
    var center = Offset(size.width / 2, 0);
    print('${size.width} ${size.height}');
    var rect =
        Rect.fromLTWH(0, 0, size.width, SizeConfig.blockSizeVertical * height);
    var rect1 = Rect.fromLTWH(
        0, 0, size.width, SizeConfig.blockSizeVertical * height / 2);
    var paintUpperarc = Paint();
    paintUpperarc.color = Color(textColor);
    canvas.drawRect(rect1, paint);
    canvas.drawArc(rect, 220, 150, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
