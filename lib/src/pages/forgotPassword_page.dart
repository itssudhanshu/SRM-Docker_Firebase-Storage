import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/src/pages/change_password_otp.dart';
import 'package:food_delivery/src/pages/otp_page.dart';
import 'package:food_delivery/src/widgets/CustomPaint.dart';
import 'package:food_delivery/src/widgets/customAppBar.dart';
import 'package:http/http.dart' as http;
import '../widgets/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot-password';
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool result;
  Future<dynamic> checkOTP(String userId) async {
    final url = "$serverIp/api/v1/forgot_password/?id=$userId";

    final response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "otp": _otpController.text,
        }));
    final responseBody = json.decode(response.body);
    setState(() {
      result = responseBody["verified"];
    });
    print(responseBody);
  }

  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;

  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.search;
  var appBarText = "Forgot Password";
  var replaceRightIcon = false;
  Widget replacedRightWidget;

  leftIconCallback() {
    Navigator.pop(context);
  }

  var _otpController = TextEditingController();

  Widget _buildOTPfield() {
    return TextFormField(
      controller: _otpController,
      decoration: InputDecoration(
        hintText: "Enter OTP",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: CustomAppBarWithoutSliver(
        rightIcon: rightIcon,
        hasLeftIcon: true,
        hasRightIcon: false,
        appBarText: "",
        leftIcon: leftIcon,
        leftIconOnPressCallbackFunction: this.leftIconCallback,
        rightIconIsCart: false,
      ),
      body: CustomPaint(
        painter: DrawCustomAppBar(),
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
                  fontFamily: 'ABeeZee'),
                ),
                SizedBox(
                  height: 200,
                ),
                Text(
                  'Please Enter The OTP sent to registered Phone Number',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: _buildOTPfield(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 50,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: RaisedButton(
                        textColor: Colors.white,
                        onPressed: () {
                          checkOTP(args.otp);
                          result == true
                              ? Navigator.of(context).pushNamed(
                                  ChangePasswordPageOTP.routeName,
                                  arguments: ScreenArguments(
                                      otp: _otpController.text,
                                      phoneNumber: args.phoneNumber))
                              : AlertDialog(
                                  title: Text('Error'),
                                );
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Color(0xff006c00),
                          ),
                        ),
                        color: Color(0xffc1ffe9),
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
