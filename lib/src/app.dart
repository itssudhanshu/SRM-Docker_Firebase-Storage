import 'package:flutter/material.dart';
import 'package:food_delivery/src/pages/change_password_otp.dart';
import 'package:food_delivery/src/pages/change_password_page.dart';
import 'package:food_delivery/src/pages/forgotPassword_page.dart';
import 'package:food_delivery/src/pages/manageAddress_page.dart';
import 'package:food_delivery/src/pages/sigin_page.dart';
//import 'package:food_delivery/src/models/food_model.dart';
import 'package:food_delivery/src/scoped_models/food_model.dart';
import 'package:food_delivery/src/screens/onBoarding_screen.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'pages/otp_page.dart';
// import 'pages/otp_page.dart';
import 'pages/signup_page.dart';
// import 'pages/signup_page.dart';
import 'screens/main_screen.dart';
import 'screens/onBoarding_screen.dart';
import 'widgets/constants.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'pages/launcher.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AppState();
  }
}

class AppState extends State<App> {
  final FoodModel foodModel = FoodModel();
  bool isSignedIn = false;
  bool firstTimeLogin = true;
  bool isComputingDone = false;

  checkUserLoggedIn() async {
    var custId = await storage.read(key: 'cust_id');
    print('custId in app.dart ${custId.runtimeType}');
    if (custId == null) {
      isSignedIn = false;
    } else {
      if (custId == '-1') {
        setState(() {
          firstTimeLogin = false;
        });
      } else {
        setState(() {
          isSignedIn = true;
        });
      }
    }
    setState(() {
      isComputingDone = true;
    });
  }

  setPendingOrder() async {
    var id = await storage.read(key: 'pendingOrders');

    if (id == null) {
      //dint initialise yet
      storage.write(key: 'pendingOrders', value: '0');
      storage.write(key: 'pendingCancelled', value: '0');
    }
    //print('custId in app.dart ${custId.runtimeType}');
  }

  @override
  void initState() {
    super.initState();
    setPendingOrder();
    checkUserLoggedIn();
    //if(jwt)
  }

  Future<Widget> screenLoad() async {
    //await
    return isSignedIn
        ? MainScreen()
        : firstTimeLogin ? OnBoardPage() : SignInPage();
  }

  @override
  Widget build(BuildContext context) {
//    var jwt = storage.read(key: 'jwt');
//    print(jwt);
    return ScopedModel<FoodModel>(
      model: foodModel,
      child: GetMaterialApp(
          routes: {
            OTPpage.routeName: (context) => OTPpage(),
            SignUpPage.routeName: (context) => SignUpPage(),
            ForgotPasswordPage.routeName: (context) => ForgotPasswordPage(),
            ChangePasswordPage.routeName: (context) => ChangePasswordPage(),
            ChangePasswordPageOTP.routeName: (context) =>ChangePasswordPageOTP(),
            AddressPage.routeName: (context) => AddressPage(),
          },
          debugShowCheckedModeBanner: false,
          title: "Food Delivery App",
          theme: ThemeData(primaryColor: Colors.blueAccent),
          home: isComputingDone
              ? isSignedIn
                  ? MainScreen()
                  : firstTimeLogin
                      ? OnBoardPage(
                          isSignedIn: false,
                        )
                      : SignInPage()
              : Launcher()
//            : Scaffold(body: Text('')
////                body: Center(
////                    child: Column(
////                  mainAxisSize: MainAxisSize.min,
////                  children: <Widget>[
////                    Image.asset('assets/images/kiranaIcon.png'),
////                    Text('Kirana'),
////                  ],
////                )),
//                ),
          ),
    );
  }
}
