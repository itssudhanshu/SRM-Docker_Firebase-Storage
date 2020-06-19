import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget{

  final String categoryName;
  final String imagePath;
  final int numberOfItems;

  FoodCard({this.categoryName, this.imagePath, this.numberOfItems});

  @override
  Widget build(BuildContext context){
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
        child: Text(
          'Hello World',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'ABeeZee',
            color: Colors.black87,
          ),
        ),
      ),
      
      width: MediaQuery.of(context).size.width*0.9,
      height: 130.0,
      margin: EdgeInsets.only(right: 20.0),
      
    );
  }
}