import 'package:flutter/material.dart';
import 'package:food_delivery/src/widgets/CustomPaint.dart';
import 'package:food_delivery/src/widgets/constants.dart';
import 'package:food_delivery/src/widgets/customAppBar.dart';
import 'package:food_delivery/src/widgets/search_file.dart';

class AddPaymentMethodPage extends StatefulWidget {
  @override
  _AddPaymentMethodPageState createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;

  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.search;
  var appBarText = "Add New Card";
  var replaceRightIcon = false;
  Widget replacedRightWidget;

  leftIconCallback() {
    Navigator.pop(context);
  }

  rightIconHandleClick() {
    setState(() {
      replaceRightIcon = !replaceRightIcon;
      replacedRightWidget = SearchField(
        textFieldColor: Color(0xffc1ffe9),
        hinttext: "Search",
        iconcolor: Color(0xffc1ffe9),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            alignment: Alignment.center,
            // height: 200,
            child: Column(
              children: <Widget>[
                // Text(
                //   '$appBarText',
                //   style: TextStyle(
                //       color: Color(0xff006c00),
                //       fontSize: 28,
                //       fontStyle: FontStyle.italic),
                // ),
                // SizedBox(
                //   height: 100,
                // ),
                Text(
                  'Please Enter Card Details',
                  style: TextStyle(fontFamily: 'ABeeZeeItalic',),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5.0,
                  child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: kTextFieldStyle,
                            decoration: InputDecoration(
                              hintText: "Name on Card",
                              hintStyle: kTextFieldHintStyle,
                            ),
                          ),
                          TextFormField(
                            style: kTextFieldStyle,
                            decoration: InputDecoration(
                              hintText: "Card Number",
                              hintStyle: kTextFieldHintStyle,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 16,
                          ),
                          TextFormField(
                            style: kTextFieldStyle,
                            decoration: InputDecoration(
                              hintText: "Expiry Date",
                              hintStyle: kTextFieldHintStyle,
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                          TextFormField(
                            style: kTextFieldStyle,
                            decoration: InputDecoration(
                              hintText: "CVV",
                              hintStyle: kTextFieldHintStyle,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 50,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: RaisedButton(
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(fontFamily: 'ABeeZeeItalic',color: ButtonTextColor),
                        ),
                        color:ButtonColor,
                      ),
                    )),
              ],
            ),
          ),
      //   ),
      // ),
    );
  }
}
