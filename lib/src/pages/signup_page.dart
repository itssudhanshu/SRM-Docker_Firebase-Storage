import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery/src/pages/otp_page.dart';
import 'package:food_delivery/src/pages/sigin_page.dart';
// import 'package:food_delivery/src/pages/sigin_page.dart';
import 'package:food_delivery/src/widgets/CustomPaint.dart';
import 'package:food_delivery/src/widgets/customAppBar.dart';
import 'package:food_delivery/src/widgets/search_file.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/sign-up';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _toggleVisibility = true;
  bool _toggleConfirmVisibility = true;
  var _nameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _emailController = TextEditingController();
  var _confirmPasswordController = TextEditingController();
  var _usernameController = TextEditingController();
  var _focusNode = FocusNode();

  String userId;

  Widget _buildFormField(
    String hintText,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      // style: ,
      obscureText: false,
      style: kTextFieldStyle,
      keyboardType: TextInputType.emailAddress,
      // textCapitalization: TextCapitalization.characters,
      // style: TextStyle(color: ),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hintText,
          hintStyle: kTextFieldHintStyle,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
    );
  }

  Widget _buildPasswordField(
    String hintText,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      style: kTextFieldStyle,
      // style: TextStyle(color: ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: hintText,
        hintStyle: kTextFieldHintStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _toggleVisibility = !_toggleVisibility;
            });
          },
          icon: _toggleVisibility
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ),
      ),
      obscureText: _toggleVisibility,
    );
  }

  Widget _buildConfirmPasswordField(
    String hintText,
    TextEditingController controller,
  ) {
    return TextField(
      focusNode: _focusNode,
      controller: controller,
      style: kTextFieldStyle,
      // style: TextStyle(color: ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: hintText,
        hintStyle: kTextFieldHintStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _toggleConfirmVisibility = !_toggleConfirmVisibility;
            });
          },
          icon: _toggleConfirmVisibility
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ),
      ),
      obscureText: _toggleConfirmVisibility,
    );
  }

  attemptSignUp(
    String email,
    String password,
    String name,
    int phoneNumber,
    String username,
    String otp,
  ) async {
//    final serverIp = "http://54.197.216.47";

    var res = await http.post(
      '$serverIp/api/v1/register/',
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
        "email": email,
        "is_customer": true,
        "is_vendor": false,
        "is_admin": false,
        "name": name,
        "ph_no": phoneNumber,
        "otp": otp.toString(),
      }),
    );
    final responseBody = await json.decode(res.body);
    print(responseBody);
    setState(() {
      userId = responseBody['user_id'];
    });
  }

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

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: CustomScrollView(
        // painter: DrawCustomAppBar(),
        slivers: <Widget>[
          CustomAppBar(
            rightIcon: rightIcon,
            hasLeftIcon: true,
            hasRightIcon: false,
            appBarText: "Sign Up",
            rightIconIsCart: false,
            rightIconOnPressCallbackFunction: this.rightIconHandleClick,
            replaceRightIcon: replaceRightIcon,
            replacedRightWidget: replacedRightWidget,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            _buildFormField('Name', _nameController),
                            SizedBox(
                              height: 20.0,
                            ),
                            _buildFormField('Email', _emailController),
                            SizedBox(
                              height: 20.0,
                            ),
                            _buildFormField('Username', _usernameController),
                            SizedBox(
                              height: 20.0,
                            ),
                            _buildPasswordField(
                              'Password',
                              _passwordController,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            _buildConfirmPasswordField(
                              'Confirm Password',
                              _confirmPasswordController,
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          if (!isLowercase(_usernameController.text)) {
                            Fluttertoast.showToast(
                                msg: "Username cannot have capital letters",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            Fluttertoast.showToast(
                                msg: "Passwords Do Not Match",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else if (!validateStructure(
                              _passwordController.text)) {
                            Fluttertoast.showToast(
                                msg:
                                    "Password Should have atleast an Uppercase, a Lowercase, a Number and a Special Character",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            attemptSignUp(
                                _emailController.text,
                                _passwordController.text,
                                _nameController.text,
                                args.phoneNumber,
                                _usernameController.text,
                                args.otp);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignInPage()));
                          }
                        },
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Color(0xffc1ffe9),
                              borderRadius: BorderRadius.circular(25.0)),
                          child: Center(
                            child: Text(
                              "SIGN UP",
                              style: TextStyle(
                                color: Colors.teal[900],
                                fontFamily: 'AbeeZeeItalic',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                                color: Color(0xFFBDC2CB),
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          SizedBox(width: 10.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Color(0xffc1ffe9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
