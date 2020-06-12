import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants.dart';

const textInputDecoration = InputDecoration(
   
                                    fillColor: kPrimaryLightColor,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        // borderRadius: BorderRadius.all(20.0),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(),
                                        // borderRadius: Border.all(29),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.purple)),
                                    
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Icon(
                                        Icons.lightbulb_outline,
            color: kPrimaryColor,
                                      ), // icon is 48px widget.
                                    ),
);
