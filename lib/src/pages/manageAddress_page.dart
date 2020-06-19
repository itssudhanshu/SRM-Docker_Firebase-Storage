import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery/src/pages/editAddress_page.dart';
import 'package:food_delivery/src/widgets/Loader.dart';
import 'package:food_delivery/src/widgets/constants.dart';
// import 'package:food_delivery/src/widgets/CustomPaint.dart';
import 'package:food_delivery/src/widgets/customAppBar.dart';
import 'package:food_delivery/src/widgets/search_file.dart';
import 'package:http/http.dart';
import '../widgets/constants.dart';
import 'addAddress_page.dart';

class AddressPage extends StatefulWidget {
  static const routeName = '/manage-address';
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  var textColor = 0xff006c00;

  var appColor = 0xffc1ffe9;

  var leftIcon = Icons.arrow_back_ios;

  var rightIcon = Icons.search;

  var appBarText = "Manage Addresses";

  var replaceRightIcon = false;

  Widget replacedRightWidget;

  List _addresses = [];
  int addressId;
  bool load = true;

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
  void initState() {
    fetchAndSetAddresses();
    // Timer(Duration(seconds: 2), fetchAndSetAddresses());
    super.initState();
  }

  void fetchAndSetAddresses() async {
    final url = '$serverIp/api/v1/manage_address/';
    var token = await storage.read(key: 'accessToken');
    defaultAddressId = (await storage.read(key: 'address_id')) != null
        ? int.parse(await storage.read(key: 'address_id'))
        : null;
    print(defaultAddressId);
    addressId = defaultAddressId;
    var response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      Fluttertoast.showToast(msg: "");
    }
    setState(() {
      _addresses = json.decode(response.body);
      load = false;
      // _addressId = json.decode(response.body)['id'];
    });
  }

  deleteaddress(String id) async {
    if (id != null && defaultAddressId == int.parse(id)) {
      storage.delete(key: 'default_address');
      storage.delete(key: 'address_id');
    }
    final url = '$serverIp/api/v1/manage_address/?loc_id=$id';
    var token = await storage.read(key: 'accessToken');

    final response = await delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    final responseBody = jsonDecode(response.body);
    print(responseBody);
  }

  Widget _addressCard(Map address) {
    return GestureDetector(
      onTap: () {
        var selectedAddress =
            "${address['name']}:${address['line1']}:${address['line2']}:${address['pincode'].toString()}:${address['city']}:${address['state']}";
        storage.write(key: "selectedAddress", value: selectedAddress);
        Navigator.pop(context);
      },
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    address['name'],
                    style: TextStyle(
                        fontFamily: 'ABeeZee',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontStyle: FontStyle.italic),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Color(0xff006c00),
                            fontFamily: 'ABeeZee',
                          ),
                        ),
                        onPressed: () {
                          _editAddress(
                            context,
                            address,
                          );
                          fetchAndSetAddresses();
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          deleteaddress(address['id'].toString());
                          storage.write(key: "selectedAddress", value: "");
                          fetchAndSetAddresses();
                        },
                        icon: Icon(Icons.delete),
                        color: Color(0xff006c00),
                      )
                    ],
                  ),
                ],
              ),
              Text(
                address['line1'],
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  fontFamily: 'ABeeZee',
                ),
              ),
              Text(
                address['line2'],
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  fontFamily: 'ABeeZee',
                ),
              ),
              Text(
                address['city'],
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  fontFamily: 'ABeeZee',
                ),
              ),
              Text(
                address['state'],
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  fontFamily: 'ABeeZee',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                address['pincode'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'ABeeZee',
                ),
              ),
              Row(
                children: [
                  Radio(
                    autofocus: true,
                    activeColor: Color(0xff006c00),
                    value: address['id'],
                    groupValue: addressId,
                    onChanged: (value) {
                      setState(() {
                        addressId = address['id'];
                        defaultAddress =
                            "${address['name']}:${address['line1']}:${address['line2']}:${address['pincode'].toString()}:${address['city']}:${address['state']}";
                        defaultAddressId = address['id'];
                        storage.write(
                            key: 'default_address', value: defaultAddress);
                        storage.write(
                            key: 'address_id', value: addressId.toString());
                      });
                    },
                  ),
                  Text(
                    'Set as Default Address',
                    style: TextStyle(
                      fontFamily: 'ABeeZee',
                    ),
                  )
                ],
              ),
              // Row(
              //   children: <Widget>[
              //     Radio(
              //       activeColor: Color(0xff006c00),
              //       value: SelectedAddress.First,
              //       groupValue: _selectedAddress,
              //       onChanged: (SelectedAddress value) {
              //         setState(() {
              //           _selectedAddress = value;
              //         });
              //       },
              //     ),
              //     Text('Use As Shipping Address')
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return Container(
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddAddressPage(func: fetchAndSetAddresses)),
          );
        });
  }

  void _editAddress(BuildContext ctx, Map address) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return Container(
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: EditAddressPage(
                  func: fetchAndSetAddresses,
                  name: address['name'],
                  line1: address['line1'],
                  line2: address['line2'],
                  city: address['city'],
                  state: address['state'],
                  pincode: address['pincode'],
                  id: address['id'],
                )),
          );
        });
  }

  // SelectedAddress _selectedAddress = SelectedAddress.Second;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _startAddNewTransaction(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xffc1ffe9),
        foregroundColor: Color(0xff006c00),
      ),
      body: CustomPaint(
        // painter: DrawCustomAppBar(),
        child: load == true
            ? Center(child: ChasingDots())
            : CustomScrollView(
                slivers: <Widget>[
                  CustomAppBar(
                    leftIcon: leftIcon,
                    rightIcon: rightIcon,
                    hasLeftIcon: true,
                    hasRightIcon: false,
                    appBarHeight: 20,
                    appBarText: "Manage Addresses",
                    rightIconIsCart: false,
                    leftIconOnPressCallbackFunction: this.leftIconCallback,
                    rightIconOnPressCallbackFunction: this.rightIconHandleClick,
                    replaceRightIcon: replaceRightIcon,
                    replacedRightWidget: replacedRightWidget,
                  ),
                  SliverList(
                    delegate: _addresses.length == 0
                        ? SliverChildListDelegate(
                            [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Container(
                                    child: Text(
                                      'No Address added',
                                      style: TextStyle(
                                          fontFamily: 'ABeeZee', fontSize: 20),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : SliverChildBuilderDelegate(
                            (context, index) => _addressCard(_addresses[index]),
                            childCount: _addresses.length,
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
