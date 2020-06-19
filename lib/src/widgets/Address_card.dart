import 'package:flutter/material.dart';
import 'package:food_delivery/src/pages/editAddress_page.dart';
import 'package:food_delivery/src/pages/manageAddress_page.dart';
import 'package:food_delivery/src/widgets/constants.dart';
import '../pages/addAddress_page.dart';

class Address_card extends StatefulWidget {
  String name;
  String line1;
  String line2;
  bool needCheckBox;
  bool checkboxValue;
  String buttonText;
  var buttonCallback;
  Address_card(
      {this.needCheckBox,
      this.checkboxValue = true,
      this.buttonText = "",
      this.buttonCallback,
      this.line1,
      this.line2,
      this.name});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Address_card_state(
        checkboxValue: this.checkboxValue,
        needCheckBox: this.needCheckBox,
        buttonText: this.buttonText,
        buttonCallback: this.buttonCallback);
  }
}

class Address_card_state extends State<Address_card> {
  bool checkboxValue = true;
  bool needCheckBox;
  String buttonText;
  var buttonCallback;

  Address_card_state(
      {this.needCheckBox = false,
      this.checkboxValue = true,
      this.buttonText = "",
      this.buttonCallback});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.name,
                  style: TextStyle(
                      fontFamily: 'ABeeZeeItalic',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,),
                ),
                FlatButton(
                  child: Text(
                    '$buttonText',
                    style: TextStyle(color: Color(textColor),fontFamily: 'ABeeZee',),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddressPage()));
                  },
                )
              ],
            ),
            Text(
              widget.line1,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15,fontFamily: 'ABeeZee',),
            ),
            Text(
              widget.line2,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15,fontFamily: 'ABeeZee',),
            ),
            needCheckBox
                ? Row(
                    children: <Widget>[
                      Checkbox(
                        activeColor: Color(0xffc1ffe9),
                        tristate: true,
                        value: checkboxValue,
                        checkColor: Color(0xff006c00),
                        onChanged: (bool newValue) {
                          setState(() {
                            checkboxValue = false;
                          });
                        },
                      ),
                      Text('Use As Shipping Address',style: TextStyle(fontFamily: 'ABeeZee',),)
                    ],
                  )
                : Text(''),
          ],
        ),
      ),
    );
  }
}
