import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:food_delivery/src/pages/change_password_page.dart';
import 'package:food_delivery/src/pages/otp_page.dart';
import 'package:food_delivery/src/widgets/CustomPaint.dart';
import 'package:food_delivery/src/widgets/constants.dart';
import 'package:food_delivery/src/widgets/customAppBar.dart';
import 'package:food_delivery/src/widgets/search_file.dart';
import 'package:http/http.dart' as http;

import '../widgets/constants.dart';
import '../widgets/constants.dart';
import 'otp_page.dart';

class SignInPhone extends StatefulWidget {
  @override
  _SignInPhoneState createState() => _SignInPhoneState();
}

class _SignInPhoneState extends State<SignInPhone> {
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

  Future<bool> handleSignUpOtp(int number) async {
//    final serverIp = 'http://54.197.216.47';
    final url = "$serverIp/api/v1/verification/?register=1";

    final response = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String, dynamic>{
          "phone": number,
        }));
    final responseBody = json.decode(response.body);
    var status;
    print(responseBody);
    responseBody['message'] == 'sent' ? status = true : status = false;
    return status;
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

  var numberController = TextEditingController();

  Widget _buildOTPfield() {
    return TextField(
      controller: numberController,
      obscureText: false,
      maxLength: 10,
      maxLengthEnforced: true,
      keyboardType: TextInputType.number,
      style: kTextFieldStyle,
      // style: TextStyle(color: ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Mobile Number",
          hintStyle: kTextFieldHintStyle,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
    );
  }

  Future<bool> success = null;
  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//      resizeToAvoidBottomPadding: false,
//      appBar: CustomAppBarWithoutSliver(
//        rightIcon: rightIcon,
//        hasLeftIcon: true,
//        hasRightIcon: false,
//        leftIcon: leftIcon,
//        leftIconOnPressCallbackFunction: this.leftIconCallback,
//        rightIconIsCart: false,
//        rightIconOnPressCallbackFunction: this.rightIconHandleClick,
//        replaceRightIcon: replaceRightIcon,
//        replacedRightWidget: replacedRightWidget,
//      ),
//      body: CustomPaint(
//        painter: DrawCustomAppBar(context: context),
//        child: Padding(
//          padding: const EdgeInsets.all(25.0),
//          child: Container(
//            alignment: Alignment.center,
//            // height: 200,
//            child: Column(
//              children: <Widget>[
//                Text(
//                  '$appBarText',
//                  style: TextStyle(
//                      color: Color(0xff006c00),
//                      fontSize: 28,
//                      fontStyle: FontStyle.italic),
//                ),
//                SizedBox(
//                  height: 200,
//                ),
//                Text(
//                  'Please Enter Your Mobile Number',
//                  style: TextStyle(fontStyle: FontStyle.italic),
//                ),
//                SizedBox(
//                  height: 30,
//                ),
//                _buildOTPfield(),
//                SizedBox(
//                  height: 30,
//                ),
//                Container(
//                    height: 50,
//                    width: double.infinity,
//                    child: ClipRRect(
//                      borderRadius: BorderRadius.circular(30),
//                      child: RaisedButton(
//                        textColor: Colors.white,
//                        onPressed: () async {
//                          success =
//                              handleSignUpOtp(int.parse(numberController.text));
//                          // if (await success != null) {
//                          if (await success) {
//                            Navigator.of(context).pushNamed(
//                              OTPpage.routeName,
//                              arguments: numberController.text,
//                            );
//                          } else {
//                            Fluttertoast.showToast(
//                                msg:
//                                    "You already have an account please Log In",
//                                toastLength: Toast.LENGTH_SHORT,
//                                gravity: ToastGravity.BOTTOM,
//                                timeInSecForIosWeb: 1,
//                                backgroundColor: Colors.red,
//                                textColor: Colors.white,
//                                fontSize: 16.0);
//                          }
//                        },
//                        child: Text(
//                          'Submit',
//                          style: TextStyle(
//                            color: Color(0xff006c00),
//                          ),
//                        ),
//                        color: Color(0xffc1ffe9),
//                      ),
//                    )),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//
  return Scaffold(
    body: CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                  width: double.infinity,
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: Color(appBarColor),
                    borderRadius: new BorderRadius.vertical(
                        bottom: new Radius.elliptical(
                            MediaQuery.of(context).size.width, 100.0)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: IconButton(
                          icon: Icon(
                            leftIcon,
                            color: Color(textColor),
                          ),
                          onPressed:leftIconCallback
                        ),
                      ),
                      Center(
                        child: Text(
                        '$appBarText',
                        style: TextStyle(
                          fontFamily: 'AbeeZee',
                        color: Colors.teal[900],
                        fontSize: 28,),
                ),
                      ),
                    ],
                  )),
              Container(
                alignment: Alignment.center,
                // height: 200,
                child: Column(
                  children: <Widget>[

                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      'Please Enter Your Mobile Number',
                      style: TextStyle(fontFamily: 'AbeeZeeItalic'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildOTPfield(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 50,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Material(
                              shadowColor: Color.fromRGBO(0, 0, 0, 0.05),
                              child: RaisedButton(
                                elevation: 20,
                                textColor: Colors.white,
                                onPressed: () async {
                                  success =
                                      handleSignUpOtp(int.parse(numberController.text));
                                  // if (await success != null) {
                                  if (await success) {
                                    Navigator.of(context).pushNamed(
                                      OTPpage.routeName,
                                      arguments: numberController.text,
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                        "You already have an account please Log In",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                },
                                child: Text(
                                  'SEND',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                    color: Color(0xff006c00),
                                    fontFamily: 'ABeeZeeItalic'
                                  ),
                                ),
                                color: Color(0xFFA7F2D7),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ]
          ),
        )
      ],
    ),
  );
  }
}
