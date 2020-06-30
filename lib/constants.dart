import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);


void displaySuccessBox(context, title, text) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.green),
          ),
          Icon(Icons.check,size: 27, color: Colors.green,)
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          heightFactor: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom : 18.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      )),
);


void displayDialog(context, title, text) => showDialog(
  context: context,
  builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          heightFactor: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                text,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 20),
                child: Text(
                  'Please try again',
                  style: TextStyle(color: Colors.redAccent),
                ),
              )
            ],
          ),
        ),
      )),
);
