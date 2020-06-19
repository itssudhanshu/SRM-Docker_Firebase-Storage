import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery/src/pages/manageAddress_page.dart';
import 'package:food_delivery/src/widgets/Loader.dart';
import 'package:food_delivery/src/widgets/authentication.dart';
// import 'package:food_delivery/src/widgets/CustomPaint.dart';
import 'package:food_delivery/src/widgets/constants.dart';
// import 'package:food_delivery/src/widgets/customAppBar.dart';
import 'package:food_delivery/src/widgets/search_file.dart';
import 'package:http/http.dart';

import '../widgets/constants.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';
import '../widgets/constants.dart';

class AddAddressPage extends StatefulWidget {
  Function func;
  AddAddressPage({this.func});
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;

  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.search;
  var appBarText = "Add Address";
  var replaceRightIcon = false;
  bool load = false;
  Widget replacedRightWidget;

  Future<void> addAddress() async {
    final url = '$serverIp/api/v1/manage_address/';
    var token = await storage.read(key: 'accessToken');
    var response = await post(url, headers: {
      // "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    }, body: <String, dynamic>{
      'name': _nameController.text,
      'line1': _addlin1Controller.text,
      'line2': _addLine2Controller.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'pincode': _pincodeController.text,
    });
    print('statusCode${response.statusCode}');
    if (response.statusCode == 401) //expired
    {
      //refresh token
      await refreshToken();
      var token = await storage.read(key: 'accessToken');

      response = await post(url, headers: {
        // "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      }, body: <String, dynamic>{
        'name': _nameController.text,
        'line1': _addlin1Controller.text,
        'line2': _addLine2Controller.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'pincode': _pincodeController.text,
      });
    }
    var responsebody = json.decode(response.body);
    print(responsebody);
    if (response.statusCode != 200 &&
        response.statusCode != 401 &&
        response.statusCode != 201) {
      Fluttertoast.showToast(msg: 'Error in adding address');
    } else {
      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: 'Successfully added new address');
      }
    }
  }

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

  var _nameController = TextEditingController();
  var _addlin1Controller = TextEditingController();
  var _addLine2Controller = TextEditingController();
  var _cityController = TextEditingController();
  var _stateController = TextEditingController();
  var _pincodeController = TextEditingController();

  Widget _buildTextfield(
    String text,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        style: kTextFieldStyle,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: text,
          hintStyle: kTextFieldHintStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
        ),
        // keyboardType: inputType,
      ),
    );
  }

  Widget _buildPincodeField(
    String text,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: kTextFieldStyle,
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: kTextFieldHintStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
        maxLengthEnforced: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return load != true
        ? Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              alignment: Alignment.center,
              // height: 200,
              child: SingleChildScrollView(
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
                      'Please Enter New Address',
                      style:
                          TextStyle(fontFamily: 'ABeeZeeItalic', fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SingleChildScrollView(
                        child: Card(
                          elevation: 10.0,
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                _buildTextfield('Full Name', _nameController),
                                _buildTextfield('Address', _addlin1Controller),
                                _buildTextfield(
                                    'LandMark', _addLine2Controller),
                                _buildTextfield('City', _cityController),
                                _buildTextfield(
                                    'State/Province/Region', _stateController),
                                _buildPincodeField(
                                  'Zip Code(Postal Code)',
                                  _pincodeController,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                            onPressed: () async {
                              if (_nameController.text == null ||
                                  _addLine2Controller.text == null ||
                                  _addlin1Controller.text == null ||
                                  _cityController.text == null ||
                                  _stateController.text == null ||
                                  _pincodeController.text.length != 6) {
                                Fluttertoast.showToast(
                                    msg: 'Invalid Text Field(s)',
                                    backgroundColor: Colors.red);
                              } else {
                                setState(() {
                                  load = true;
                                });
                                await addAddress();
                                setState(() {
                                  load = false;
                                });
                                widget.func();
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'SUBMIT',
                              style: TextStyle(
                                  color: ButtonTextColor,
                                  fontFamily: 'ABeeZeeItalic',
                                  fontSize: 18),
                            ),
                            color: ButtonColor,
                          ),
                        )),
                  ],
                ),
              ),
            ),
            // ),

            // ),
          )
        : ChasingDots();
  }
}
