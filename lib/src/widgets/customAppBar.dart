import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/src/app.dart';
import '../widgets/MediaQueryGetSize.dart';
import '../widgets/constants.dart';
import '../pages/myCart.dart';

//There are 2 implementation of appBar
//  1. With Sliver . (CustomAppBar)
//  2.Without Sliver. (CustomAppBarWithoutSliver)
// Try 2nd to just paint the background. Use the 1st appBar, To move the appBar as the user scrolls ,

class CustomAppBar extends StatelessWidget {
  var leftIcon;
  var hasLeftIcon = false;
  var hasRightIcon = false;
  var rightIcon;
  var appBarText;
  var rightIconIsCart = false;
  var replaceRightIcon = false;
  var rightIconOnPressCallbackFunction;
  var leftIconOnPressCallbackFunction;
  Widget replacedRightWidget;
  bool hasTextOnBottomOfAppBar;
  Widget widgetOnBottomAppbar;
  var widgetOnBottomAppbarHeight;
  var appBarHeight;
  var title;
  CustomAppBar(
      {this.leftIcon,
      this.hasLeftIcon = false,
      this.hasRightIcon = false,
      this.rightIcon,
      this.appBarText = "",
      this.rightIconIsCart = false,
      this.rightIconOnPressCallbackFunction,
      this.replaceRightIcon = false,
      this.replacedRightWidget,
      this.leftIconOnPressCallbackFunction,
      this.widgetOnBottomAppbar,
      this.widgetOnBottomAppbarHeight = 20,
      this.hasTextOnBottomOfAppBar = true,
      this.appBarHeight = 25,
      this.title = ""});

  String appBarName = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var pageSize = SizeConfig().init(context);
    return SliverAppBar(
      //stretch: true,
      title: replaceRightIcon
          ? replacedRightWidget
          : Text('$title',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 28, color: Color(textColor),fontFamily: 'ABeeZee',)),

      pinned: true,
      expandedHeight: SizeConfig.blockSizeVertical * appBarHeight,
      flexibleSpace: hasTextOnBottomOfAppBar
          ? Container(
              padding: EdgeInsets.fromLTRB(60, 23, 20, 20),
              height: SizeConfig.blockSizeVertical * 50,
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              child: Text(
                '$appBarText',
                style: TextStyle(
                    color: Color(0xff006c00),
                    fontSize: 28,
                fontFamily: 'ABeeZee'),
              ))
          : FlexibleSpaceBar(
              background: Container(
                //color: Color(appBarColor),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    widgetOnBottomAppbar,
                  ],
                ),
                padding: EdgeInsets.fromLTRB(
                    10,
                    SizeConfig.blockSizeVertical * widgetOnBottomAppbarHeight,
                    10,
                    4),
                height:
                    SizeConfig.blockSizeVertical * widgetOnBottomAppbarHeight,
                width: double.infinity,
                //alignment: Alignment.bottomLeft,
              ),
            ),

      centerTitle: true,
      backgroundColor: Color(0xffc1ffe9),
      floating: false,
//      shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.only(
//              bottomRight: Radius.elliptical(100, 100),
//              bottomLeft: Radius.elliptical(100, 100))),
      shape: ContinuousRectangleBorder(
        borderRadius: new BorderRadius.vertical(
            bottom:
                Radius.elliptical(MediaQuery.of(context).size.width, 250.0)),
      ),
//
//              ),
      actions: <Widget>[
        hasRightIcon
            ? replaceRightIcon
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                    ),
                    onPressed: () => (rightIconOnPressCallbackFunction()),
                    color: Colors.green,
                  )
                : IconButton(
                    icon: Icon(
                      rightIcon,
                      color: Color(textColor),
                    ),
                    onPressed: () => (rightIconOnPressCallbackFunction()),
                  )
            : Text(''),
      ],
      leading: hasLeftIcon
          ? IconButton(
              icon: Icon(
                leftIcon,
                color: Color(textColor),
              ),
              onPressed: () => (leftIconOnPressCallbackFunction()),
            )
          : Text(''),
    );
  }
}

class CustomAppBarWithoutSliver extends StatelessWidget
    implements PreferredSizeWidget {
  var leftIcon;
  var hasLeftIcon = false;
  var hasRightIcon = false;
  var rightIcon;
  var appBarText;
  var rightIconIsCart = false;
  var replaceRightIcon = false;
  var rightIconOnPressCallbackFunction;
  var leftIconOnPressCallbackFunction;
  Widget replacedRightWidget;
  CustomAppBarWithoutSliver(
      {this.leftIcon,
      this.hasLeftIcon = false,
      this.hasRightIcon = false,
      this.rightIcon,
      this.appBarText = "",
      this.rightIconIsCart = false,
      this.rightIconOnPressCallbackFunction,
      this.replaceRightIcon = false,
      this.replacedRightWidget,
      this.leftIconOnPressCallbackFunction});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    if (!rightIconIsCart && hasRightIcon) {
//      rightIcon = Icons.search;
//    }
    return AppBar(
      elevation: 0,
      backgroundColor: Color(appBarColor),
      title: replaceRightIcon
          ? replacedRightWidget
          : Text('$appBarText', style: TextStyle(color: Color(textColor),fontFamily: 'ABeeZee',)),
      centerTitle: true,
      leading: hasLeftIcon
          ? IconButton(
              icon: Icon(
                leftIcon,
                color: Color(textColor),
              ),
              onPressed: () => (leftIconOnPressCallbackFunction()),
            )
          : Text(''),
      actions: <Widget>[
        hasRightIcon
            ? replaceRightIcon
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                    ),
                    onPressed: () => (rightIconOnPressCallbackFunction()),
                    color: Colors.redAccent,
                  )
                : IconButton(
                    icon: Icon(
                      rightIcon,
                      color: Color(textColor),
                    ),
                    onPressed: () => (rightIconOnPressCallbackFunction()),
                  )
            : Text(''),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
