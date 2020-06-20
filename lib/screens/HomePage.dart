import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:srm_notes/screens/subjectPage.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;
  Size size;
  var data;

  Widget _cardWidget(title, code) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SubjectPage(title);
            },
          ),
        );
      },
      child: Container(
        // height: 100,
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: kPrimaryLightColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 6),
              blurRadius: 10,
              color: kPrimaryColor.withOpacity(0.5),
            ),
          ],
        ),

        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              right: 0,
              bottom: 0,
              top: 20,
              child: CustomPaint(
                size: Size(100, 150),
                painter: CustomCardShapePainter(
                    10,
                    // items[index].startColor, items[index].endColor
                    kPrimaryColor,
                    kPrimaryLightColor),
              ),
            ),
            Column(
                // fit: StackFit.expand,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.01),
                  ClipRRect(
                    // borderRadius: BorderRadius.circular(10.0),
                    // child: CircleAvatar(
                    //   backgroundColor: Colors.white,
                    child: Icon(
                      Icons.folder,
                      size: 60,
                      color: kPrimaryColor,
                    ),
                  ),
                  // )),
                  SizedBox(height: size.height * 0.01),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          code,
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  var _searchedText;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: isSearchEmpty
            ? Text("Home", style: TextStyle(color: Colors.white))
            : TextField(
                style: TextStyle(color: Colors.white),
                controller: searchController,
                onChanged: (text) {
                  setState(() {
                    _searchedText = text.toLowerCase();
                  });
                },
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
                  this.isSearchEmpty = !this.isSearchEmpty;
                });
              })
        ],
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
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
            Container(
              child: Column(
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: _fireStore.collection('Subjects').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Icon(
                          Icons.flight_takeoff,

                          ///[logo]
                          size: 40,
                        );
                      }
                      var doc = snapshot.data;
                      final messages = snapshot.data.documents.reversed;
                      List<Widget> wid = [];
                      for (var message in messages) {
                        final name = message.data['name'];
                        final code = message.data['code'];
                        final mw = _cardWidget(name, code);
                        if (_searchedText == null ||
                            name.toLowerCase().contains(_searchedText)) {
                          wid.add(mw);
                        }
                      }
                      return Expanded(
                          child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: (((size.height) / 2) / size.width),
                        padding: EdgeInsets.all(10),
                        children: wid,
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void cancelSearch() {
    setState(() {
      _searchedText = null;
    });
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
