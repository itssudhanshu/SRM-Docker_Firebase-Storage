import 'package:flutter/material.dart';
import 'package:srm_notes/constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryLightColor,
      child: Center(
        child:Image.asset(
                "assets/images/logobg.png",
              ),
        // SpinKitChasingDots(
        //   color: kPrimaryColor,
        //   size: 50.0,
        //   )
      ),
    );
  }
}