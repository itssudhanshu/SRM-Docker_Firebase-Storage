import 'package:flutter/material.dart';
import 'package:food_delivery/src/pages/profile_page.dart';
import 'package:food_delivery/src/widgets/constants.dart';
import '../pages/sigin_page.dart';
import '../widgets/MediaQueryGetSize.dart';
import '../pages/profile_page.dart';
import 'package:flutter/services.dart';
//
//class OnBoardPage extends StatefulWidget {
//  bool isSignedIn = false;
//  OnBoardPage({this.isSignedIn});
//  @override
//  _OnBoardPageState createState() => _OnBoardPageState(isSignedIn: isSignedIn);
//}
//
//class _OnBoardPageState extends State<OnBoardPage> {
//  var mainIdea = "";
//}

class HelpPage extends StatefulWidget {
  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(appBarColor),
                Colors.teal[300],
                Colors.teal[500],
                Colors.teal[900],
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
//                Container(
//                  alignment: Alignment.centerRight,
//                  child: FlatButton(
//                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
//                        MaterialPageRoute(builder: (context) => SignInPage()),
//                        (Route<dynamic> route) => false),
//                    child: Text(
//                      '',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 20.0,
//                      ),
//                    ),
//                  ),
//                ),
                Container(
                  height: MediaQuery.of(context).size.height - 180,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/1.png',
                                ),
                                height: 300.0,
                                width: 300.0,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Get discovered',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Come rain or shine,\nwe help customers\nreach you',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/2.png',
                                ),
                                height: 300.0,
                                width: 300.0,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Hassle free management',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Managing your business has never been this easy',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/images/3.png',
                                ),
                                height: 220.0,
                                width: 300.0,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'Secure platform',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'We use cutting edge\ntechnology to secure your\nbusiness transactions',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 55.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Center(
                  child: Text(
                    'Back to Profile',
                    style: TextStyle(
                      color: Color(0xFF5B16D0),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
