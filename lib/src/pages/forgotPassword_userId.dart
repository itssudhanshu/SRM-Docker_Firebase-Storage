import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:food_delivery/src/pages/change_password_page.dart';
import 'package:food_delivery/src/pages/forgotPassword_page.dart';
import 'package:food_delivery/src/pages/otp_page.dart';
import 'package:food_delivery/src/widgets/CustomPaint.dart';
import 'package:food_delivery/src/widgets/customAppBar.dart';
// import 'package:food_delivery/src/widgets/search_file.dart';
import 'package:http/http.dart' as http;
import '../widgets/constants.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';

class ForgotPasswordUserName extends StatefulWidget {
  @override
  _ForgotPasswordUserNameState createState() => _ForgotPasswordUserNameState();
}

class _ForgotPasswordUserNameState extends State<ForgotPasswordUserName> {
  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;

  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.search;
  var appBarText = "Forgot Password";
  var replaceRightIcon = false;
  Widget replacedRightWidget;
  int userId;

  sendRequest() async {
    final url = "$serverIp/api/v1/forgot_password/";

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(<String, dynamic>{
          'reset_method': 'mobile',
          'phone': int.parse(_usernameController.text),
        }));
    final responseBody = json.decode(response.body);
    print(responseBody['user_id']);
    setState(() {
      userId = responseBody['user_id'];
    });
  }

  leftIconCallback() {
    Navigator.pop(context);
  }

  var _usernameController = TextEditingController();

  Widget _buildOTPfield() {
    return TextFormField(
      style: kTextFieldStyle,
      controller: _usernameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: "Enter Mobile Number",
        hintStyle: kTextFieldHintStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//      resizeToAvoidBottomPadding: false,
//      appBar: CustomAppBarWithoutSliver(
//        rightIcon: rightIcon,
//        hasLeftIcon: true,
//        hasRightIcon: false,
//        appBarText: "",
//        leftIcon: leftIcon,
//        leftIconOnPressCallbackFunction: this.leftIconCallback,
//        rightIconIsCart: false,
//      ),
//      body: CustomPaint(
//        painter: DrawCustomAppBar(
//          context: context,
//        ),
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
//                  fontFamily: 'ABeeZee'),
//                ),
//                SizedBox(
//                  height: 200,
//                ),
//                Text(
//                  'Please Mobile Number',
//                  style: TextStyle(fontFamily: 'ABeeZeeItalic'),
//                ),
//                SizedBox(
//                  height: 20,
//                ),
//                Card(
//                  elevation: 5.0,
//                  child: Padding(
//                    padding: EdgeInsets.all(20.0),
//                    child: _buildOTPfield(),
//                  ),
//                ),
//                SizedBox(
//                  height: 20,
//                ),
//                Container(
//                    height: 50,
//                    width: double.infinity,
//                    child: ClipRRect(
//                      borderRadius: BorderRadius.circular(30),
//                      child: RaisedButton(
//                        textColor: Colors.white,
//                        onPressed: () {
//                          sendRequest();
//                          Navigator.of(context).pushNamed(
//                              ForgotPasswordPage.routeName,
//                              arguments: ScreenArguments(
//                                  phoneNumber:
//                                      int.parse(_usernameController.text),
//                                  otp: '$userId'));
//                        },
//                        child: Text(
//                          'SUBMIT',
//                          style: TextStyle(
//                            color: ButtonTextColor,
//                            fontFamily: 'ABeeZeeItalic',
//                            fontSize: 18
//                          ),
//                        ),
//                        color: ButtonColor,
//                      ),
//                    )),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }

    return Scaffold(
//      appBar: CustomAppBarWithoutSliver(
//        rightIcon: rightIcon,
//        hasLeftIcon: true,
//        hasRightIcon: false,
//        appBarText: "",
//        leftIcon: leftIcon,
//        leftIconOnPressCallbackFunction: this.leftIconCallback,
//        rightIconIsCart: false,
//        rightIconOnPressCallbackFunction: this.rightIconHandleClick,
//        replaceRightIcon: replaceRightIcon,
//        replacedRightWidget: replacedRightWidget,
//      ),
      body: CustomPaint(
        // painter: DrawCustomAppBar(),
        child: CustomScrollView(slivers: <Widget>[
          // Image.asset('assets/images/icon.png'),
//          SliverAppBar(
//            // flexibleSpace: Text('Welcome To Kirana'),
//            shape: ContinuousRectangleBorder(
//              borderRadius: new BorderRadius.vertical(
//                  bottom: Radius.elliptical(
//                      MediaQuery.of(context).size.width, 250.0)),
//            ),
//            backgroundColor: Color(appBarColor),
//            title: Padding(
//              padding: const EdgeInsets.all(20.0),
//              child: Container(
//                width: double.infinity,
//                child: Column(
//                  children: [
//                    Image.asset('assets/images/icon.png',height: 50,width: 50,),
//                    // Text(
//                    //   'Kirana',
//                    //   style: TextStyle(color: Colors.teal[900], fontSize: 40.0),
//                    // ),
//                  ],
//                ),
//              ),
//            ),
//            pinned: true,
//            centerTitle: true,
//                        flexibleSpace: Text('Welcome To Kirana'),
//
//            expandedHeight: 170.0,
//          ),
// Image.asset('assets/images/icon.png'),
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
                          padding: const EdgeInsets.only(top: 30),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: leftIconCallback,
                              icon: Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Center(child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Colors.teal[900],
                            fontSize: 28,
                            fontFamily: 'ABeeZee',),
                        ),)
                      ],
                    )),
                SizedBox(
                  height: 100,
                ),
                Text(
                  'Please Enter Mobile Number',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'ABeeZeeItalic'),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 5.0,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: _buildOTPfield(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      height: 50,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: RaisedButton(
                          textColor: Colors.white,
                          onPressed: () {
                            sendRequest();
                            Navigator.of(context).pushNamed(
                                ForgotPasswordPage.routeName,
                                arguments: ScreenArguments(
                                    phoneNumber:
                                    int.parse(_usernameController.text),
                                    otp: '$userId'));
                          },
                          child: Text(
                            'SUBMIT',
                            style: TextStyle(
                                color: ButtonTextColor,
                                fontFamily: 'ABeeZeeItalic',
                                fontSize: 18
                            ),
                          ),
                          color: ButtonColor,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

