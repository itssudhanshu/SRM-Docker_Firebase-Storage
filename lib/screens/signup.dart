import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:srm_notes/components/already_have_an_account_acheck.dart';
import 'package:srm_notes/components/rounded_button.dart';

import 'package:srm_notes/screens/HomePage.dart';
import 'package:srm_notes/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  bool isSpinner = false;
  String _name;
  String _reg;
  String _email;
  String _pass;
  String _confirmPass;
  String error = '';
  bool _obscureText = true;
  createUser() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _pass);
      if (newUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        displayDialog(context, 'Error', 'Some error occured.');
      }
    } catch (e) {
      displayDialog(context, 'Error', 'Some error occured.');
      print(e);
    }
  }

  addUser() async {
    var response = await _fireStore
        .collection('users')
        .document('$_email')
        .setData({'name': _name, 'email': _email, 'regno': _reg});
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: isSpinner,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // leading: Icon(null),
          backgroundColor: kPrimaryColor,
          title: Center(
            child: Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
        body: Container(
          height: size.height,
          width: double.infinity,
          // Here i can use size.width but use double.infinity because both work as a same
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/signup_top.png",
                  width: size.width * 0.35,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/main_bottom.png",
                  width: size.width * 0.25,
                ),
              ),

              // Positioned(
              //   top: 50,
              //   left: 100,
              //   child: SvgPicture.asset(
              //     "assets/icons/signup.svg",
              //     height: size.height * 0.35,
              //   ),
              // ),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Positioned(
                        top: 50,
                        left: 100,
                        child: SvgPicture.asset(
                          "assets/icons/signup.svg",
                          height: size.height * 0.25,
                        ),
                      ),
                      Container(
                        width: size.width * 0.8,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              TextFormField(
                                  //                     decoration: textInputDecoration.copyWith(hintText:'Your Name',labelText: "Name",prefixIcon: Icon(
                                  //                             Icons.person,
                                  // color: kPrimaryColor,
                                  //                           ),),
                                  decoration: InputDecoration(
                                    fillColor: kPrimaryLightColor,
                                    filled: true,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 0.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(29),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(29),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.purple)),
                                    hintText: "Your Name",
                                    labelText: "Name",
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Icon(
                                        Icons.person,
                                        color: kPrimaryColor,
                                      ), // icon is 48px widget.
                                    ),
                                  ),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter your name' : null,
                                  onChanged: (val) {
                                    setState(() => _name = val);
                                  }),
                              SizedBox(height: 20.0),
                              TextFormField(
                                  decoration: InputDecoration(
                                    fillColor: kPrimaryLightColor,
                                    filled: true,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 0.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(29),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(29),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.purple)),
                                    hintText: "RA...",
                                    labelText: "Enter your Reg. No.",
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Icon(
                                        Icons.perm_identity,
                                        color: kPrimaryColor,
                                      ), // icon is 48px widget.
                                    ),
                                  ),
                                  validator: (val) => val.isEmpty
                                      ? 'Enter your Reg. No.'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => _reg = val);
                                  }),
                              SizedBox(height: 20.0),
                              TextFormField(
                                  decoration: InputDecoration(
                                    fillColor: kPrimaryLightColor,
                                    filled: true,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 0.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(29),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(29),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.purple)),
                                    hintText: "Enter your college id",
                                    labelText: "Email",
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Icon(
                                        Icons.mail,
                                        color: kPrimaryColor,
                                      ), // icon is 48px widget.
                                    ),
                                  ),

                                  // decoration: textInputDecoration.copyWith(hintText:'Email'),
                                  validator: (val) =>
                                      !val.endsWith('@srmist.edu.in')
                                          ? 'Email must end with @srmist.edu.in'
                                          : null,
                                  onChanged: (val) {
                                    setState(() => _email = val);
                                  }),
                              SizedBox(height: 20.0),
                              TextFormField(
                                  decoration: InputDecoration(
                                    fillColor: kPrimaryLightColor,
                                    filled: true,
                                    contentPadding:
                                        new EdgeInsets.symmetric(vertical: 0.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(29),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.green)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(29),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.purple)),
                                    hintText: "Enter password",
                                    labelText: "Password",
                                    suffixIcon: Container(
                                      child: IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          onPressed: () {
                                            _toggle();
                                          }),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  validator: (val) => val.length < 6
                                      ? 'Password must be longer than 6 chars'
                                      : null,
                                  obscureText: _obscureText,
                                  onChanged: (valpass) {
                                    setState(() => _pass = valpass);
                                  }),
                              SizedBox(height: 20.0),
                              TextFormField(
                                  decoration: InputDecoration(
                                    fillColor: kPrimaryLightColor,
                                    filled: true,
                                    contentPadding:
                                        new EdgeInsets.symmetric(vertical: 0.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(29),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.green)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(29),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.purple)),
                                    hintText: "retype password again",
                                    labelText: "Confirm Password",
                                    suffixIcon: Container(
                                      child: IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          onPressed: () {
                                            _toggle();
                                          }),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val.isEmpty) return 'Retype password';
                                    if (val != _pass) return 'Not Match';
                                  },
                                  obscureText: _obscureText,
                                  onChanged: (val) {
                                    _confirmPass = val;
                                    // setState(() => _pass = val);
                                  }),
                              SizedBox(height: 20.0),
                              RoundedButton(
                                text: "SIGNUP",
                                press: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      isSpinner = true;
                                    });
                                    print('inside');
                                    await createUser();
                                    await addUser();
                                    setState(() {
                                      isSpinner = false;
                                    });
                                  }
                                },
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                error,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: size.height * 0.03),
                              AlreadyHaveAnAccountCheck(
                                login: false,
                                press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LoginScreen();
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
