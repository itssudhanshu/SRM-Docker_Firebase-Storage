import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:food_delivery/src/pages/change_password_page.dart';
import 'package:food_delivery/src/pages/signup_page.dart';
import 'package:food_delivery/src/widgets/CustomPaint.dart';
import 'package:food_delivery/src/widgets/customAppBar.dart';
import 'package:food_delivery/src/widgets/search_file.dart';
import 'package:http/http.dart' as http;
import '../widgets/constants.dart';

import '../widgets/constants.dart';
import '../widgets/constants.dart';
import 'signup_page.dart';

class ScreenArguments {
  int phoneNumber;
  String otp;
  ScreenArguments({this.phoneNumber, this.otp});
}

class OTPpage extends StatefulWidget {
  static const routeName = '/otp-screen';
  @override
  _OTPpageState createState() => _OTPpageState();
}

class _OTPpageState extends State<OTPpage> {
  GlobalKey _globalKey;
  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;

  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.search;
  var appBarText = "Sign Up";
  var replaceRightIcon = false;
  Widget replacedRightWidget;

  leftIconCallback() {
    Navigator.pop(context);
  }

  rightIconHandleClick() {
    setState(() {
      replaceRightIcon = !replaceRightIcon;
      replacedRightWidget = SearchField(
        textFieldColor: Color(0xffc1ffe9),
        hinttext: "Search",
        iconcolor: Color(0xffc1ffe9),
      );
    });
  }

  var otpController = TextEditingController();

  Widget _buildOTPfield() {
    return TextField(
      controller: otpController,
      style: kTextFieldStyle,
      keyboardType: TextInputType.number,
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "OTP",
          hintStyle: kTextFieldHintStyle,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
    );
  }

  @override
  Widget build(BuildContext context) {
    String _isVerified;
    var number = ModalRoute.of(context).settings.arguments;
    Future<String> verifyOTP() async {
      final url = "$serverIp/api/v1/verification/";

      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({
            "phone": number,
            "otp": int.parse(otpController.text),
          }));
      final responseBody = json.decode(response.body);
      print(responseBody);
      return responseBody['verification'];
    }

    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomPadding: false,
      appBar: CustomAppBarWithoutSliver(
        rightIcon: rightIcon,
        hasLeftIcon: true,
        hasRightIcon: true,
        appBarText: "",
        leftIcon: leftIcon,
        leftIconOnPressCallbackFunction: this.leftIconCallback,
        rightIconIsCart: false,
        rightIconOnPressCallbackFunction: this.rightIconHandleClick,
        replaceRightIcon: replaceRightIcon,
        replacedRightWidget: replacedRightWidget,
      ),
      body: CustomPaint(
        painter: DrawCustomAppBar(context: context),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            alignment: Alignment.center,
            // height: 200,
            child: Column(
              children: <Widget>[
                Text(
                  '$appBarText',
                  style: TextStyle(
                      color: Color(0xff006c00),
                      fontSize: 28,
                      fontFamily: 'ABeeZee',),
                ),
                SizedBox(
                  height: 200,
                ),
                Text(
                  'Please Enter OTP sent to your mobile',
                  style: TextStyle(fontFamily: 'ABeeZeeItalic'),
                ),
                SizedBox(
                  height: 30,
                ),
                _buildOTPfield(),
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 50,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: RaisedButton(
                        textColor: Colors.white,
                        onPressed: () async {
                          // Find the Scaffold in the widget tree and use
                          // it to show a SnackBar.

                          _isVerified = await verifyOTP();

                          if (_isVerified == 'success') {
                            Navigator.of(context)
                                .pushNamed(SignUpPage.routeName,
                                    arguments: ScreenArguments(
                                      phoneNumber: int.parse(number),
                                      otp: otpController.text,
                                    ));
                          } else if (_isVerified == "otp expired") {
                            Fluttertoast.showToast(
                                msg: "OTP Expired. Try Again After Some Time",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            Fluttertoast.showToast(
                                msg: "OTP Invalid",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontFamily: 'ABeeZeeItalic',
                            color: Color(0xff006c00),
                              fontSize: 18.0
                          ),
                        ),
                        color: Color(0xffA7F2D7),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
