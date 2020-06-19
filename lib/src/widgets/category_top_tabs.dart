import 'package:flutter/material.dart';
import '../widgets/constants.dart';

class CategoryTab extends StatelessWidget {
  var tabDetail;
  CategoryTab({this.tabDetail});
  var image;

  @override
  Widget build(BuildContext context) {
    print(tabDetail[1].runtimeType);
    if (tabDetail[1].runtimeType != String) {
      image = "assets/images/kiranaIcon.png";
    } else {
      image = tabDetail[1];
    }
    return Container(
      // color: Colors.white70,
      margin: EdgeInsets.fromLTRB(7, 0, 10, 10),
      //height: 100,
      child: Container(
        color: Colors.white70,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.all(
                  Radius.circular(11.0) //         <--- border radius here
                  ),
              shape: BoxShape.rectangle,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${tabDetail[0] != null ? tabDetail[0] : ""}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'ABeeZee',),
                ),
              ],
            ),
          ),
        ),
      ),

      decoration: BoxDecoration(
        //border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.all(
            Radius.circular(11.0) //         <--- border radius here
            ),
        shape: BoxShape.rectangle,
        color: Colors.white,
        image: DecorationImage(
            image: NetworkImage(
              image,
            ),
            fit: BoxFit.contain),
        boxShadow: [
          new BoxShadow(
            color: Colors.black38,
//            spreadRadius: 3,
//            offset: new Offset(0, 10),
            blurRadius: 4.0,
          )
        ],
      ),
//          child: Image.asset(
//            'assets/images/hide_and_seek.jpg',
//            fit: BoxFit.contain,
//          ),
      constraints: BoxConstraints(maxWidth: 90, minWidth: 90),
    );
  }
}
