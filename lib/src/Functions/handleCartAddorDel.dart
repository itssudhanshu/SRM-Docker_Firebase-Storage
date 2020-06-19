import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery/src/widgets/constants.dart';
import 'package:http/http.dart' as http;
import '../widgets/constants.dart';
import '../widgets/authentication.dart';

addItemToCart(vendorId, prodId, custId, quantity) async {
  print('Adding to cart');
  var cartId;
  print(
      'Adding to cart : V: $vendorId P: $prodId CustId: $custId Q: $quantity');
  var token = await storage.read(key: 'accessToken');

  print('$token');
  var addToCart;
  try {
    addToCart = await http.post('$serverIp/api/v1/cart/',
        body:
            '[{"customer_id": $custId, "vendor_id": $vendorId, "product_id": $prodId, "quantity": $quantity}]',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
  } catch (e) {
    Fluttertoast.showToast(
        msg: 'Connection Error!', toastLength: Toast.LENGTH_LONG);
    return;
  }

  if (addToCart.statusCode == 401) //expired
  {
    //refresh token
    print('Trying to get refresh access token');
    await refreshToken();

    token = await storage.read(key: 'accessToken');
    try {
      addToCart = await http.post('$serverIp/api/v1/cart/',
          body:
              '[{"customer_id": $custId, "vendor_id": $vendorId, "product_id": $prodId, "quantity": $quantity}]',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Connection Error!', toastLength: Toast.LENGTH_LONG);
      return;
    }
  }
  cartLocalCache.remove('cartList');
  cartLocalCacheForCartPage.remove('cartList');
  var cartData = jsonDecode(addToCart.body);
  print(addToCart.statusCode);
  print(addToCart.body);
  try {
    print(jsonDecode(addToCart.body)['message']);
    Fluttertoast.showToast(msg: jsonDecode(addToCart.body)['message']);
  } catch (e) {
    print(e);
  }
  print(cartData['id']);
  return [cartData['id'], addToCart.statusCode];
}

updateQuantity(cartId, quantity) async {
  print('Updating Quantity');
  //var cartId;
  print('C: $cartId Q : $quantity');
  var updateCart;
  var token = await storage.read(key: 'accessToken');
  try {
    updateCart = await http.put('$serverIp/api/v1/cart/',
        body: '[{"cart_id": $cartId, "quantity": $quantity}]',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });
  } catch (e) {
    Fluttertoast.showToast(
        msg: 'Connection Error!', toastLength: Toast.LENGTH_LONG);
    return;
  }

  if (updateCart.statusCode == 401) //expired
  {
    //refresh token
    print('Trying to get refresh access token');
    await refreshToken();
    token = await storage.read(key: 'accessToken');
    try {
      updateCart = await http.put('$serverIp/api/v1/cart/',
          body: '{"cart_id": $cartId, "quantity": $quantity}',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Connection Error!', toastLength: Toast.LENGTH_LONG);
      return;
    }
  }
  print(updateCart.statusCode);
  try {
    print(jsonDecode(updateCart.body)['message']);
    Fluttertoast.showToast(msg: jsonDecode(updateCart.body)['message']);
  } catch (e) {
    print(e);
  }
  cartLocalCache.remove('cartList');
  cartLocalCacheForCartPage.remove('cartList');
  return updateCart.statusCode;
}

deleteFromCart(cartId) async {
  print('Delete from cart');
  //var cartId;
  var token = await storage.read(key: 'accessToken');
  var deleteFromCart;
  try {
    deleteFromCart =
        await http.delete('$serverIp/api/v1/cart/?cart_id=$cartId', headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
  } catch (e) {
    Fluttertoast.showToast(
        msg: 'Connection Error!', toastLength: Toast.LENGTH_LONG);
    return;
  }

  if (deleteFromCart.statusCode == 401) //expired
  {
    //refresh token
    print('Trying to get refresh access token');
    await refreshToken();
    token = await storage.read(key: 'accessToken');
    try {
      deleteFromCart =
          await http.delete('$serverIp/api/v1/cart/?cart_id=$cartId', headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Connection Error!', toastLength: Toast.LENGTH_LONG);
      return;
    }

    print(deleteFromCart.statusCode);
    print(deleteFromCart.body);
  }
  print(deleteFromCart.statusCode);
  print(deleteFromCart.statusCode.runtimeType);
  print(deleteFromCart.body);
  try {
    print(jsonDecode(deleteFromCart.body)['message']);
    Fluttertoast.showToast(msg: jsonDecode(deleteFromCart.body)['message']);
  } catch (e) {
    print(e);
  }
  cartLocalCache.remove('cartList');
  cartLocalCacheForCartPage.remove('cartList');
  return deleteFromCart.statusCode;
}

handleCartAddorDel(
    {vendorId, prodId, custId, quantity, typeOfReq, cartId}) async {
  print('Handling Add cart click cartId: $cartId');

  switch (typeOfReq) {
    case 1:
      custId = await storage.read(key: 'cust_id');
      var cartId = addItemToCart(vendorId, prodId, custId, quantity);
      return cartId;
      break;
    case 2:
      var status = updateQuantity(cartId, quantity);
      return status;
      break;
    case 3:
      var status = deleteFromCart(cartId);
      return status;
      break;
  }
}
