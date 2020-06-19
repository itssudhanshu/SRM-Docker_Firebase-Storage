import 'dart:convert';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/pages/forgotPassword_userId.dart';
import 'package:food_delivery/src/pages/signIn_mobile.dart';
import 'package:food_delivery/src/widgets/search_file.dart';
import 'package:http/http.dart' as http;
import '../widgets/constants.dart';
import '../screens/main_screen.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import '../widgets/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool load = false;
  bool _toggleVisibility = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<String> attemptLogIn(String username, String password) async {
    var getresponse;
    try {
      getresponse = await http
          .get('$serverIp/api/v1/user_group/?name=$username', headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
    } catch (e) {
      //print(e);

      Fluttertoast.showToast(
          msg: 'Connection Error', toastLength: Toast.LENGTH_LONG);

      return "-2";
    }
    var getCustData = jsonDecode(getresponse.body);
    if (getCustData['group'] != "customer") {
      return "-1";
    }

    var res = await http.post("$serverIp/api/token/",
        body: {"username": username, "password": password});
    if (res.statusCode == 200) return res.body;
    return null;
  }

  Widget _emailField() {
    return Material(
      shadowColor: Color.fromRGBO(0, 0, 0, 0.5),
      elevation: 8,
      child: TextField(
        controller: _usernameController,
        style: kTextFieldStyle,
        obscureText: false,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Username",
            hintStyle: kTextFieldHintStyle,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Material(
      shadowColor: Color.fromRGBO(0, 0, 0, 0.5),
      elevation: 8,
      child: TextField(
        controller: _passwordController,
        style: kTextFieldStyle,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
          hintText: "Password",
          hintStyle: kTextFieldHintStyle,
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
      ),
    );
  }

  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;
  bool signingIn = true;
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

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                heightFactor: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      text,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        'Please try again',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    )
                  ],
                ),
              ),
            )),
      );

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Signing-In...")
          ],
        ),
        action: SnackBarAction(
            label: 'Hide', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text("Press back button once again to exit the app"),
        ),
        child: CustomPaint(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
//
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
//                            Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text('             ')),
                              Expanded(
                                child: SizedBox(
                                  height: 500,
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 50,
                                child: Image.asset('assets/images/icon.png'),
                                backgroundColor: Color(appBarColor),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Welcome to Kirana',
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.teal[900],
                                    fontFamily: 'ABeeZee',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: IconButton(
//                            icon: Icon(
//                              Icons.arrow_back,
//                              color: Color(appBarColor),
//                            ),
//                          ),
//                        )
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
//                          Text(
//                            "Login",
//                            style: TextStyle(
//                              fontSize: 40.0,
//                              fontWeight: FontWeight.bold,
//                            ),
//                          ),
                            SizedBox(
                              height: 30.0,
                            ),

                            _emailField(),
                            SizedBox(
                              height: 20,
                            ),
                            _buildPasswordTextField(),
                            SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) =>
                                            ForgotPasswordUserName(),
                                      ),
                                    );
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  child: Text(
                                    "Forgot your password?",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'ABeeZee',
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) => SignInPhone()));
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  child: Text(
                                    "Don't have an account ? Sign Up",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontFamily: 'ABeeZee',
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Builder(
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () async {
                                    signingIn = true;
                                    var username = _usernameController.text;
                                    var password = _passwordController.text;
                                    if (signingIn) _showToast(context);
                                    var jwt =
                                        await attemptLogIn(username, password);
                                    print(jwt);
                                    if (jwt != null &&
                                        jwt != "-1" &&
                                        jwt != "-2") {
                                      print('$jwt');
                                      var jwtdata = jsonDecode(jwt);
                                      print(jwtdata);
                                      storage.write(key: "jwt", value: jwt);
                                      storage.write(
                                          key: "accessToken",
                                          value: jwtdata['access']);
                                      storage.write(
                                          key: "refreshToken",
                                          value: jwtdata['refresh']);
                                      storage.write(
                                          key: 'uname', value: username);
                                      //print(await storage.read(key: "accessToken"));
                                      freshLogin = true;

//                                    Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                            builder: (context) =>
//                                                (MainScreen(foodModel))));

                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen()),
                                          (Route<dynamic> route) => false);
                                    } else {
                                      signingIn = false;
                                      if (jwt == null) {
                                        displayDialog(
                                            context,
                                            "An Error Occurred",
                                            "Wrong username or password ! ");
                                      } else {
                                        if (jwt == "-1") {
                                          Get.snackbar(
                                            'Login',
                                            'Not a valid Customer',
                                          );
                                        }
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFA7F2D7),
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    child: Center(
                                      child: Text(
                                        "LOGIN",
                                        style: TextStyle(
                                          color: Colors.teal[900],
                                          fontSize: 18.0,
                                          fontFamily: 'ABeeZeeItalic',
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ])),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
