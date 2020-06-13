import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:srm_notes/constants.dart';
import 'package:srm_notes/pages/account.dart';
import 'package:srm_notes/pages/leaderboard.dart';
import 'package:srm_notes/pages/upload.dart';
import 'package:srm_notes/screens/HomePage.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      UploadPage(),
      Leaderboard(),
      AccountPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColor: Colors.blue,
        activeContentColor: kPrimaryColor,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.file_upload),
        title: ("Upload"),
        activeColor: Colors.teal,
        activeContentColor: kPrimaryColor,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.message),
        title: ("Leaderboard"),
        activeColor: Colors.deepOrange,
        activeContentColor: kPrimaryColor,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        title: ("Account"),
        activeColor: Colors.indigo,
        activeContentColor: kPrimaryColor,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        showElevation: true,
        controller: _controller,
        screens: _buildScreens(),
        items:
            _navBarsItems(), // Redundant here but defined to demonstrate for other than custom style
        confineInSafeArea: true,
        backgroundColor: Colors.grey[200],
        handleAndroidBackButtonPress: true,
        navBarCurve: NavBarCurve.upperCorners,
        onItemSelected: (int) {
          setState(
            () {},
          ); // This is required to update the nav bar if Android back button is pressed
        },
        itemCount: 4,
        navBarStyle:
            NavBarStyle.style5 // Choose the nav bar style with this property
        );
  }
}
