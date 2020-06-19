import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_delivery/src/scoped_models/food_model.dart';
import 'package:flutter/material.dart';

var appBarColor = 0xffc1ffe9;
//var appBarColor = 0xffb3ffcc;
String name;
String phone;
String email;
String defaultAddress;
int defaultAddressId;
bool freshLogin = false;
var textColor = 0xff006c00;
var storage = FlutterSecureStorage();
const serverIp = 'http://13.233.33.65'; //52.66.200.83';//13.233.33.65
final FoodModel foodModel = FoodModel();
Map cartItems = new Map();
//cartItems[prodId] = [vendorId, quantity,cartId];
bool haveLocalCartItems = false;
Map localCartItemsInProductsPage = new Map();
Map localCartItemsIndexInProductsPage = new Map();
var TotalproductList;
var totalproductListLength = 0;
Map productsLocalCache = new Map();
Map cartLocalCache = new Map();
Map cartLocalCacheForCartPage = new Map();
final kTitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 26.0,
  height: 1.5,
);

final kSubtitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  height: 1.2,
);

final kTextFieldStyle = TextStyle(fontFamily: 'AbeeZeeItalic');

final kTextFieldHintStyle = TextStyle(
  color: Color(0xFFBDC2CB),
  fontFamily: 'AbeeZee',
  fontSize: 18.0,
);

final Color ButtonColor = Color(0xFFA7F2D7);
final Color ButtonTextColor = Colors.teal[900];
