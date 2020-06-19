import 'package:flutter/material.dart';
import 'package:food_delivery/src/pages/change_password_page.dart';
import 'package:food_delivery/src/widgets/customAppBar.dart';
import 'package:food_delivery/src/widgets/search_file.dart';
import '../widgets/constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitchedSales = true;
  bool isSwitchedArrivals = true;
  bool isSwitchedStatus = true;
  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;

  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.search;
  var appBarText = "Settings";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//appBar: CustomAppBar(
//          rightIcon: Icons.search,
//          hasLeftIcon: true,
//          hasRightIcon: true,
//          appBarText: "",
//          leftIcon: Icons.arrow_back_ios,
//          leftIconOnPressCallbackFunction: this.leftIconCallback,
//          rightIconIsCart: false,
//          rightIconOnPressCallbackFunction: this.rightIconHandleClick,
//          replaceRightIcon: replaceRightIcon,
//          replacedRightWidget: replacedRightWidget,
//        ),
      body: CustomPaint(
        //painter: DrawCustomAppBar(),
        child: CustomScrollView(
          slivers: <Widget>[
            CustomAppBar(
              rightIcon: Icons.search,
              hasLeftIcon: true,
              hasRightIcon: false,
              appBarText: "Settings",
              leftIcon: Icons.arrow_back_ios,
              leftIconOnPressCallbackFunction: this.leftIconCallback,
              rightIconIsCart: false,
              rightIconOnPressCallbackFunction: this.rightIconHandleClick,
              replaceRightIcon: replaceRightIcon,
              replacedRightWidget: replacedRightWidget,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              // Padding(
              //   padding: EdgeInsets.only(top: 0.0, left: 10.0, right: 20.0),
              //   child: Text(
              //     "Personal Information",
              //     style: TextStyle(fontSize: 20.0),
              //     textAlign: TextAlign.left,
              //   ),
              // ),
              Container(
                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {}),
                    //SizedBox(height: 40),

                    // SizedBox(height: 40),
                    // TextField(
                    //   decoration: InputDecoration(
                    //     fillColor: Colors.white,
                    //     filled: true,
                    //     hintText: "Full Name",
                    //     hintStyle: TextStyle(
                    //       color: Color(0xFFBDC2CB),
                    //       fontSize: 18.0,
                    //       fontStyle: FontStyle.italic,
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Color(0xFFBDC2CB),
                    //       ),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Color(0xFFBDC2CB),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 40),
                    // TextField(
                    //   decoration: InputDecoration(
                    //     fillColor: Colors.white,
                    //     filled: true,
                    //     hintText: "DOB",
                    //     hintStyle: TextStyle(
                    //       color: Color(0xFFBDC2CB),
                    //       fontSize: 18.0,
                    //       fontStyle: FontStyle.italic,
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Color(0xFFBDC2CB),
                    //       ),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Color(0xFFBDC2CB),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 40),
                    Row(
                      children: <Widget>[
                        Text("Password",
                            style: TextStyle(
                                fontFamily: 'ABeeZee',
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                        Expanded(child: SizedBox(width: 180)),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(ChangePasswordPage.routeName);
                          },
                          child: Text(
                            "Change",
                            style: TextStyle(fontSize: 16.0,fontFamily: 'ABeeZee',),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 40),
                    Text("Notifications",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold,fontFamily: 'ABeeZee',)),
                    SizedBox(height: 40),
                    Row(
                      children: <Widget>[
                        Text("Sales",
                            style: TextStyle(
                                fontFamily: 'ABeeZee',
                                fontSize: 15.0, fontWeight: FontWeight.bold)),
                        Expanded(child: SizedBox(width: 270)),
                        Switch(
                          value: isSwitchedSales,
                          onChanged: (value) {
                            setState(() {
                              isSwitchedSales = value;
                            });
                          },
                          activeTrackColor: Color(appBarColor),
                          activeColor: Color(appBarColor),
                        ),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Text("New Arrivals",
                            style: TextStyle(
                                fontFamily: 'ABeeZee',
                                fontSize: 15.0, fontWeight: FontWeight.bold)),
                        Expanded(child: SizedBox(width: 225)),
                        Switch(
                          value: isSwitchedArrivals,
                          onChanged: (value) {
                            setState(() {
                              isSwitchedArrivals = value;
                            });
                          },
                          activeTrackColor: Color(appBarColor),
                          activeColor: Color(appBarColor),
                        ),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Text("Delivery status changes",
                            style: TextStyle(
                                fontFamily: 'ABeeZee',
                                fontSize: 15.0, fontWeight: FontWeight.bold)),
                        Expanded(child: SizedBox(width: 150)),
                        Switch(
                          value: isSwitchedStatus,
                          onChanged: (value) {
                            setState(() {
                              isSwitchedStatus = value;
                            });
                          },
                          activeTrackColor: Color(appBarColor),
                          activeColor: Color(appBarColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ])),
          ],
        ),
      ),
    );
  }
}
