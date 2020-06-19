import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/sigin_page.dart';
import '../widgets/MediaQueryGetSize.dart';
class OnBoardPage extends StatefulWidget {
  bool isSignedIn = false;
  OnBoardPage({this.isSignedIn});
  @override
  _OnBoardPageState createState() => _OnBoardPageState(isSignedIn: isSignedIn);
}

class _OnBoardPageState extends State<OnBoardPage> {
  var mainIdea = "";
  var breifIdea = "";
  var image;
  var buttonText = "";
  var pageIndex = 0;
  var numberOfOnBoardScreens = 3;
  var swipeLeft = false;

  var data = [
    [
      'assets/images/onb1.png',
      'Hassle Free Grocery Shopping',
      'Shopping Can be this easy and convenient from the comfort of your home'
    ],
    [
      'assets/images/onb2.png',
      'Delivered to your doorstp',
      'Sit back and relax while we deliver them to your home'
    ],
    [
      'assets/images/onb3.png',
      'Quality Supplies ensured',
      'Your peace of mind and our standard is guranteed'
    ]
  ];
  bool isSignedIn;
  _OnBoardPageState({this.isSignedIn});
  handleClick(direction) {
    print('handle click :$direction');
    if (direction == -1) //moving left
    {
      if (pageIndex > 0) {
        setState(() {
          pageIndex -= 1;
        });
      }
    } else if (numberOfOnBoardScreens - 1 > pageIndex) {
      setState(() {
        pageIndex += 1;
        print('isSignedIn ${this.isSignedIn}\n');
        isSignedIn
            ? buttonText = numberOfOnBoardScreens - 1 == pageIndex
                ? "Back to profile page."
                : "NEXT"
            : buttonText =
                numberOfOnBoardScreens - 1 == pageIndex ? "REGISTER" : "NEXT";
      });
    } else {
      print('isSignedIn $isSignedIn\n');
      isSignedIn
          ? Navigator.pop(context)
          : Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignInPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text("Press back button once again to exit the app"),
        ),
        child: GestureDetector(
            //onHorizontalDragEnd: handleClick(1),
            onPanEnd: (details) {
              if (swipeLeft) {
                handleClick(1);
              } else
                handleClick(-1);
            },
            onPanUpdate: (details) {
              if (details.delta.dx > 0) {
                swipeLeft = false;
              } else {
                //print("Dragging in -X direction");
                swipeLeft = true;
              }
            },
            child: OnBoardingScreenWidgetState(
              image: data[pageIndex][0],
              breifIdea: data[pageIndex][2],
              mainIdea: data[pageIndex][1],
              handleClick: this.handleClick,
            )),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.pink,
          child: RaisedButton(
            elevation: 0,
            color: Colors.pink,
            onPressed: () {
              handleClick(1);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                numberOfOnBoardScreens - 1 == pageIndex
                    ? isSignedIn ? "Back to profile page" : "Get Started"
                    : "Next",
                style: TextStyle(
                    fontFamily: 'ABeeZeeItalic',
                    fontSize: 20,
                    color: Colors.white70),
              ),
            ),
          )),
    );
  }
}

//class OnBoardingScreenWidget extends StatefulWidget {
//  var mainIdea = "";
//  var breifIdea;
//  var image = null;
//  var buttonText = "";
//  var handleClick;
////  onBoardingScreenWidget(
////      image, var mainIdea, var breifIdea, var buttonText, var handleClick) {
////    this.image = image;
////    this.mainIdea = mainIdea;
////    this.breifIdea = breifIdea;
////    this.buttonText = buttonText;
////    this.handleClick = handleClick;
////  }
//
//  OnBoardingScreenWidget(
//      {this.image,
//      this.breifIdea,
//      this.mainIdea,
//      this.buttonText,
//      this.handleClick});
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return OnBoardingScreenWidgetState(
//        image: this.image,
//        breifIdea: this.breifIdea,
//        buttonText: this.buttonText,
//        handleClick: this.handleClick,
//        mainIdea: this.mainIdea);
//  }
//}

class OnBoardingScreenWidgetState extends StatelessWidget {
  var mainIdea = "";
  final breifIdea;
  var image;
  var handleClick;
  var currentScreen = 1;
  OnBoardingScreenWidgetState(
      {this.image, this.breifIdea, this.mainIdea, this.handleClick}) {}
  var sizeconfig = SizeConfig();
  var leftPadding = SizeConfig.blockSizeHorizontal;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).viewPadding.top,
        ),
        Image.asset(
          image,
        ),
        Center(
          child: Text(
            '$mainIdea',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'ABeeZee',),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(100, 10, 90, 60),
            child: Center(
              child: Text('$breifIdea',style: TextStyle(fontFamily: 'ABeeZee'),),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildButton(0),
              _buildButton(0),
              _buildButton(0)
            ],
          ),
        )
      ],
    );
  }

  Widget _buildButton(btnState) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          height: 10,
          width: 10,
          child: RaisedButton(
            padding: EdgeInsets.all(20),
            shape: CircleBorder(),
            color: btnState > 0 ? Colors.blueAccent : Colors.cyanAccent,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
