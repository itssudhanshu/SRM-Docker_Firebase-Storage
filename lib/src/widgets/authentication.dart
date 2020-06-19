import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import '../pages/sigin_page.dart';
import 'package:get/get.dart';

refreshToken() async {
  bool isRefreshDone = false;
  while (!isRefreshDone) {
    try {
      print("refreshing token . . . ");
      var refresh = await storage.read(key: 'refreshToken');
      print('refresh token $refresh');
      var jwtdata = await http.post('$serverIp/api/token/refresh/',
          body: '{"refresh":"$refresh"}',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          });
      print('refresh token status code : ${jwtdata.statusCode}');
      print('refresh token response body  : ${jwtdata.body}');
      if (jwtdata.statusCode == 200) {
        print(jwtdata.body);
        var tokens = jsonDecode(jwtdata.body);
        await storage.write(key: "accessToken", value: tokens['access']);
      } else {
//        Navigator.of(context).pushAndRemoveUntil(
//            MaterialPageRoute(builder: (context) => SignInPage()),
//            (Route<dynamic> route) => false);
        await storage.write(key: "refreshToken", value: '');
        await storage.write(key: "cust_id", value: '-1');
        await storage.write(key: 'selectedAddress', value: '');
        Get.off(SignInPage());
        Get.snackbar(
          'Login',
          'Your session has ended.Please try logging in again',
        );
      }
      isRefreshDone = true;
    } catch (e) {
      print('error occured in refreshing token');
    }
  }
}
