import 'package:flutter/material.dart';
import 'package:food_delivery/src/widgets/constants.dart';
import 'package:food_delivery/src/scoped_models/food_model.dart';
import '../widgets/constants.dart';
import '../screens/main_screen.dart';

class Successful_page extends StatelessWidget {
  //final FoodModel foodModel = FoodModel();

  takeToMainScreen(context) {
//    Navigator.pop(context);
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => (MainScreen(
//                  foodModel,
//                ))));
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        children: <Widget>[
          Image.asset('assets/images/success.png'),
          Text('\n\nSUCCESS !',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(
              '\nYour order will be delivered soon.\nThank You for choosing our app!',
              style: TextStyle(fontSize: 17,fontFamily: 'ABeeZee',)),
          RaisedButton(
            color: Color(appBarColor),
            child: Text('Continue Shopping',style: TextStyle(fontFamily: 'ABeeZee',),),
            onPressed: () => (takeToMainScreen(context)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          )
        ],
      ),
    );
  }
}
