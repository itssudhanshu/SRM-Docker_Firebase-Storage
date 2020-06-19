import 'package:flutter/material.dart';

class BoughtFood extends StatefulWidget {
  final String name;
  final String imagePath;
  final String address;
  final double distance;
  final double ratings;

  BoughtFood(
      {
      this.name,
      this.imagePath,
      this.address,
      this.distance,
      this.ratings});

  @override
  _BoughtFoodState createState() => _BoughtFoodState();
}

class _BoughtFoodState extends State<BoughtFood> {
  var cardText = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,fontFamily: 'ABeeZee',);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/cheeseburger.png"),
                height: 65.0,
                width: 65.0,
              ),
              SizedBox(width: 20.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,fontFamily: 'ABeeZee',),),
                  Text(widget.address,style: TextStyle(fontFamily: 'ABeeZee',),),
                  Divider(
                    color: Colors.black,
                  ),
                  Row(
                    children: <Widget>[
                      Text(widget.distance.toString(),style: TextStyle(color: Colors.green,fontFamily: 'ABeeZee',)),
                      SizedBox(width: 20.0),
                      Text(widget.ratings.toString()+" stars",style: TextStyle(color: Colors.green,fontFamily: 'ABeeZee',))
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}