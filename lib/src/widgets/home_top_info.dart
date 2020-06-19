import 'package:flutter/material.dart';

class HomeTopInfo extends StatelessWidget{

  final textStyle = TextStyle(fontSize: 32.0,color: Color.fromRGBO(0, 102, 102, 10),fontFamily: 'ABeeZee',);
  
  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Kirana", style: textStyle),
            ],
          ),
          
        ],
      ),
    );
  }
}