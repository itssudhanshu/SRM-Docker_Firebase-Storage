import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:srm_notes/components/appbar.dart';
import 'package:srm_notes/constants.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard>
    with SingleTickerProviderStateMixin {
  bool _isAppbar = true;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        appBarStatus(false);
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        appBarStatus(true);
      }
    });
  }

  void appBarStatus(bool status) {
    setState(() {
      _isAppbar = status;
    });
  }

  final double _borderRadius = 24;

  var items = [
    PlaceInfo('Sudhanshu Kushwaha', Color(0xff6DC8F3), Color(0xff73A1F9), 4.4,
        'RA171102011424', 500, 1500),
    PlaceInfo('Sudhanshu Kushwaha', Color(0xff6DC8F3), Color(0xff73A1F9), 4.4,
        'RA171102011424', 500, 1500),
    PlaceInfo('Sudhanshu Kushwaha', Color(0xff6DC8F3), Color(0xff73A1F9), 4.4,
        'RA171102011424', 500, 1500),
    PlaceInfo('Sudhanshu Kushwaha', Color(0xff6DC8F3), Color(0xff73A1F9), 4.4,
        'RA171102011424', 500, 1500),
    PlaceInfo('Sudhanshu Kushwaha', Color(0xff6DC8F3), Color(0xff73A1F9), 4.4,
        'RA171102011424', 500, 1500),
    PlaceInfo('Sudhanshu Kushwaha', Color(0xff6DC8F3), Color(0xff73A1F9), 4.4,
        'RA171102011424', 500, 1500),
    PlaceInfo('Sudhanshu Kushwaha', Color(0xff6DC8F3), Color(0xff73A1F9), 4.4,
        'RA171102011424', 500, 1500),
    PlaceInfo('Sudhanshu Kushwaha', Color(0xff6DC8F3), Color(0xff73A1F9), 4.4,
        'RA171102011424', 500, 1500),
    PlaceInfo('Sudhanshu Kushwaha', Color(0xff6DC8F3), Color(0xff73A1F9), 4.4,
        'RA171102011424', 500, 1500),
    PlaceInfo('Sudhanshu Kushwaha', Color(0xff6DC8F3), Color(0xff73A1F9), 4.4,
        'RA171102011424', 500, 1500),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AnimatedContainer(
          // height: _isAppbar ? 70.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: ConstAppbar(title: "Leaderboard"),
        ),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
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
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(_borderRadius),
                                gradient: LinearGradient(
                                    colors: [
                                      // items[index].startColor,
                                      // items[index].endColor
                                      kPrimaryColor,
                                      kPrimaryLightColor
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        kPrimaryLightColor, //items[index].endColor,
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              top: 0,
                              child: CustomPaint(
                                size: Size(100, 150),
                                painter: CustomCardShapePainter(
                                    _borderRadius,
                                    // items[index].startColor, items[index].endColor
                                    kPrimaryColor,
                                    kPrimaryLightColor),
                              ),
                            ),
                            Positioned.fill(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: CircleAvatar(
                                      radius: 30,
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg',
                                          // height: 50,
                                          width: 60,
                                          // fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          items[index].name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: 'Avenir',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          items[index].regno,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Avenir',
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: <Widget>[
                                            // SizedBox(width: 20),
                                            Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Uploads",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.0),
                                                  Text(
                                                    "5200",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Container(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Uploads",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.0),
                                                  Text(
                                                    "5200",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          items[index].rating.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Avenir',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        RatingBar(rating: items[index].rating),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

// Shape cards with custom colors

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

// User Details

class PlaceInfo {
  final String name;
  final String regno;
  final int uploadno;
  final int likeno;
  final double rating;
  final Color startColor;
  final Color endColor;

  PlaceInfo(this.name, this.startColor, this.endColor, this.rating, this.regno,
      this.uploadno, this.likeno);
}

//Rating stars

class RatingBar extends StatelessWidget {
  final double rating;

  const RatingBar({Key key, this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rating.floor(), (index) {
        return Icon(
          Icons.star,
          color: Colors.white,
          size: 16,
        );
      }),
    );
  }
}
