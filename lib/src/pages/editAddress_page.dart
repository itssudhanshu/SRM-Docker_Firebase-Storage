import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery/src/widgets/CustomPaint.dart';
import 'package:food_delivery/src/widgets/authentication.dart';
import 'package:food_delivery/src/widgets/constants.dart';
import 'package:food_delivery/src/widgets/customAppBar.dart';
import 'package:food_delivery/src/widgets/search_file.dart';
import 'package:http/http.dart';

import 'manageAddress_page.dart';

class EditAddressPage extends StatefulWidget {
  final String name;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final int pincode;
  final int id;
  Function func;
  EditAddressPage(
      {this.pincode,
      this.city,
      this.line1,
      this.line2,
      this.name,
      this.state,
      this.id,
      this.func});
  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;

  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.search;
  var appBarText = "Add Address";
  var replaceRightIcon = false;
  Widget replacedRightWidget;

  addAddress(String id) async {
    final url = '$serverIp/api/v1/manage_address/?loc_id=$id';
    var token = await storage.read(key: 'accessToken');
    var response = await put(url, headers: {
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
    if (response.statusCode == 401) //expired
        {
      //refresh token
      await refreshToken();
      var token = await storage.read(key: 'accessToken');

      response = await put(url, headers: {
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

  Widget _buildTextfield(String text, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      style: kTextFieldStyle,
      controller: controller,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: kTextFieldHintStyle,
      ),
      keyboardType: inputType,
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _addlin1Controller.text = widget.line1;
    _addLine2Controller.text = widget.line2;
    _stateController.text = widget.state;
    _cityController.text = widget.city;
    _pincodeController.text = widget.pincode.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Container(
        alignment: Alignment.center,
        // height: 200,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                'Please Enter New Address',
                style: TextStyle(fontFamily: 'ABeeZee'),
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
                          _buildTextfield('LandMark', _addLine2Controller),
                          _buildTextfield('City', _cityController),
                          _buildTextfield(
                              'State/Province/Region', _stateController),
                          _buildTextfield(
                              'Zip Code(Postal Code)', _pincodeController),
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
                      onPressed: () {
                        if (_nameController.text == null ||
                            _addLine2Controller.text == null ||
                            _addlin1Controller.text == null ||
                            _cityController.text == null ||
                            _stateController.text == null ||
                            _pincodeController.text.length != 6) {
                          Fluttertoast.showToast(
                              msg: 'Invalid Text Field(s)',
                              backgroundColor: Colors.red);
                        } else{
                          addAddress(widget.id.toString());
                          widget.func();
                          Navigator.pop(context);
                        }

                        // Navigator.of(context).pop();
                      },
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: ButtonTextColor,
                          fontFamily: 'ABeeZeeItalic',
                        ),
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
    );
  }
}
