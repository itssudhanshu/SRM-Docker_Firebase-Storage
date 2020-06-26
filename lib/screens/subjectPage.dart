import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:srm_notes/components/models/loading.dart';
import 'package:srm_notes/pages/question.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class SubjectPage extends StatefulWidget {
  var sub;
  SubjectPage(this.sub);
  @override
  _SubjectPageState createState() => _SubjectPageState(this.sub);
}

class _SubjectPageState extends State<SubjectPage> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: "Notes"),
    Tab(text:"Question Paper"),
  ];
  var _searchedText;
  var subject;
  _SubjectPageState(this.subject);

  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;
  Size size;
  var data;

  String _version = 'Unknown';
  String preview;

  Future<void> getFilteredList() async {}


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
          child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: isSearchEmpty
              ? Text("$subject", style: TextStyle(color: Colors.white))
              : TextField(
                  style: TextStyle(color: Colors.white),
                  controller: searchController,
                  onChanged: (text) {
                    setState(() {
                      _searchedText = text.toLowerCase();
                    });
                  },
                  // autofocus: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
          backgroundColor: kPrimaryColor,
          leading: !isSearchEmpty
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      _searchedText = null;
                      this.isSearchEmpty = !this.isSearchEmpty;
                    });
                  })
              : null,
          actions: <Widget>[
            IconButton(
                icon: isSearchEmpty ? Icon(Icons.search) : Icon(Icons.cancel),
                color: isSearchEmpty ? Colors.white : Colors.white,
                onPressed: () {
                  setState(() {
                    cancelSearch();
                    _searchedText = null;
                    this.isSearchEmpty = !this.isSearchEmpty;
                  });
                })
          ],
          

 bottom: new TabBar(
              tabs: <Widget>[
                new Tab(
                  text: "Notes",
                ),
                new Tab(
                  text: "Question Paper",
                ),
              ],
            ),
          ),
          body: new TabBarView(
            children: <Widget>[
              new Container(
                child: Text("data"),
              ),
              new Container(
                child: new Center(
                  child: Text("data"),
                ),
              ),
            ],
          ),
      ),
    );
  }
  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }

  void handleSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isSearchEmpty = false;
      });
    } else {
      setState(() {
        isSearchEmpty = true;
      });
    }
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
