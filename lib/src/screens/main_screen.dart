import 'package:flutter/material.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:food_delivery/src/scoped_models/food_model.dart';
import 'package:food_delivery/src/widgets/constants.dart';
import '../pages/home_page.dart';
import '../pages/order_page.dart';
import '../pages/myCart.dart';
import '../pages/favorite_page.dart';
import '../pages/profile_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  int pageToDisplay;
  MainScreen({this.pageToDisplay});
  @override
  _MainScreenState createState() =>
      _MainScreenState(pageToDisplay: pageToDisplay);
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  // Pages
  HomePage homePage;
  OrderPage orderPage;
  FavoritePage favoritePage;
  ProfilePage profilePage;
  MyCartPage myCartPage;

  List<Widget> pages;
  Widget currentPage;
  int pageToDisplay;
  _MainScreenState({this.pageToDisplay});
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<String> sendInfo() async {
    try {
      var token = await storage.read(key: 'accessToken');
      var device_token = await storage.read(key: 'device_token');
      var response =
          await http.post(Uri.encodeFull('$serverIp/api/v1/register_device/'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              },
              body: '{ "fcm_token" : "$device_token" } ');
      print(response.statusCode);
      print(response.body);
      //  print(response.body);
      return 'Success';
    } catch (e) {
      print("error in deregistering device for notifications");
    }
  }

  _getToken() {
    _firebaseMessaging.getToken().then((token) async {
      print("Device Token: $token");
      await storage.write(key: "device_token", value: "$token");
      sendInfo();
    });
  }

//  _configureFirebaseListeners() {
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print('onMessage: $message');
//        // _setMessage(message);
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print('onLaunch: $message');
//        //_setMessage(message);
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print('onResume: $message');
//        // _setMessage(message);
//      },
//    );
//    _firebaseMessaging.requestNotificationPermissions(
//      const IosNotificationSettings(sound: true, badge: true, alert: true),
//    );
//  }
  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('hey');
        print("onMessage: $message");
//        showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//            content: ListTile(
//              title: Text(message['notification']['title']),
//              subtitle: Text(message['notification']['body']),
//            ),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Ok'),
//                onPressed: () => Navigator.of(context).pop(),
//              ),
//            ],
//          ),
//        );
        Get.snackbar(
          message['notification']['title'],
          message['notification']['body'],
        );
        // _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        //_setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        // _setMessage(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

  @override
  void initState() {
    // call the fetch method on food
    // widget.foodModel.fetchFoods();
    super.initState();
    _getToken();
    _configureFirebaseListeners();
    homePage = HomePage();
    orderPage = OrderPage();
    favoritePage = FavoritePage();
    myCartPage = MyCartPage();
    profilePage = ProfilePage();
    pages = [homePage, myCartPage, profilePage];
    print("pageToDisp $pageToDisplay");
    switch (pageToDisplay) {
      case 0:
        currentPage = homePage;
        currentTab = 0;
        break;
      case 1:
        currentPage = myCartPage;
        currentTab = 1;
        break;
      case 2:
        currentPage = profilePage;
        currentTab = 2;
        break;
      default:
        currentPage = homePage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(textColor),
        //selectedItemColor: Color(0xffc1ffe9),
        currentIndex: currentTab,
        onTap: (index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_basket,
            ),
            title: Text(
              "Order",
              style: TextStyle(
                fontFamily: 'ABeeZee',
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
            ),
            title: Text(
              "Cart",
              style: TextStyle(
                fontFamily: 'ABeeZee',
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text(
              "Profile",
              style: TextStyle(
                fontFamily: 'ABeeZee',
              ),
            ),
          ),
        ],
      ),
      body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text("Press back button once again to exit the app"),
          ),
          child: currentPage),
    );
  }
}
