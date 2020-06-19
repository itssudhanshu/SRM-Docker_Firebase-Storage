import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

loader(BuildContext context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            title: Text(
              'Please wait',
              softWrap: true,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                plainLoader(),
              ],
            ));
      });
}

Widget plainLoader({height = 40, width = 60}) {
  return AbsorbPointer(
    absorbing: true,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
//          child: CircularProgressIndicator(),
          child: SpinKitCircle(
            color: Colors.green,
            size: 50,
          ),
//          height: 40,
//          width: 40,
        ),
      ),
    ),
  );
}

Widget ChasingDots() {
  return Center(
    child: SpinKitCircle(
      color: Colors.green,
      size: 50,
    ),
  );
}
