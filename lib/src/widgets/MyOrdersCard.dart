import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery/src/pages/myOrders_page.dart';
import 'package:food_delivery/src/widgets/Loader.dart';
import 'package:food_delivery/src/widgets/MediaQueryGetSize.dart';
import 'package:food_delivery/src/widgets/authentication.dart';
import 'package:food_delivery/src/widgets/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyOrdersCard extends StatefulWidget {
  final orderId;
  final orderNumber;
  final trackingNumber;
  final quantity;
  final totalAmount;
  final status;
  final date;
  var statusColor;
  var showDetailsCallback;
  var orderDetails;
  MyOrdersCard(
      {this.orderId,
      this.orderNumber,
      this.trackingNumber,
      this.quantity,
      this.status,
      this.totalAmount,
      this.date,
      this.statusColor,
      this.showDetailsCallback,
      this.orderDetails});

  @override
  State<StatefulWidget> createState() {
    return MyOrdersCardState(
        orderNumber: this.orderNumber,
        trackingNumber: this.trackingNumber,
        quantity: this.quantity,
        totalAmount: this.totalAmount,
        status: this.status,
        date: this.date,
        statusColor: this.statusColor,
        showDetailsCallback: showDetailsCallback,
        orderDetails: orderDetails);
  }
}

class MyOrdersCardState extends State<MyOrdersCard> {
  final orderNumber;
  final trackingNumber;
  var quantity;
  var totalAmount;
  var status;
  final date;
  var statusColor;
  var showDetailsCallback;
  var orderDetails;
  MyOrdersCardState(
      {this.status,
      this.totalAmount,
      this.quantity,
      this.trackingNumber,
      this.orderNumber,
      this.date,
      this.statusColor,
      this.showDetailsCallback,
      this.orderDetails});
  double ratings = 3;
  bool flag = false;
  String des = 'No Comment';

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'ABeeZee',
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                heightFactor: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'ABeeZee',
                      ),
                    ),
                  ],
                ),
              ),
            )),
      );

  cancelOrder(int orderId) async {
    var id = orderId.toString();
    var token = await storage.read(key: 'accessToken');
    var response = await http.delete(
      Uri.encodeFull('$serverIp/api/v1/customer/order/?order_id=$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 401) {
      await refreshToken();
      var token = await storage.read(key: 'accessToken');
      response = await http.delete(
        Uri.encodeFull('$serverIp/api/v1/customer/order/?order_id=$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
    }
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => OrdersPage()),
          (Route<dynamic> route) => false);
//      displayDialog(context, "Success", "Your Order Has Been Cancelled",);
    } else {
      displayDialog(context, "Error Occured!", "Try again later");
    }
  }

  void givefeedback(int orderid) {
    var id = orderid.toString();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Color(0xFF737373),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: flag == false
                    ? ListView(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 130, right: 130),
                            child: Container(
                                height: 8,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(100))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 5.0),
                          //   child: Center(
                          //     child: Text(
                          //       'Feedback For The Placed Order',
                          //       style: TextStyle(
                          //           fontStyle: FontStyle.italic, fontSize: 20),
                          //     ),
                          //   ),
                          // ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    // elevation: 5,
                                    // borderOnForeground: true,
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      // child: TextField(
                                      //   keyboardType: TextInputType.number,
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       ratings = int.parse(value);
                                      //     });
                                      //   },
                                      //   textAlign: TextAlign.left,
                                      //   style: TextStyle(
                                      //     color: Colors.black,
                                      //     fontStyle: FontStyle.italic,
                                      //     fontWeight: FontWeight.w300,
                                      //   ),
                                      //   decoration: InputDecoration(
                                      //     border: InputBorder.none,
                                      //     hintText: 'Rating out of 5',
                                      //     hintStyle: TextStyle(
                                      //         color: Colors.grey,
                                      //         fontWeight: FontWeight.w400),
                                      //   ),
                                      // ),

                                      child: RatingBar(
                                        initialRating: 3,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                          ratings = rating;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                          Column(children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // elevation: 5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                        color: Colors.teal[900], width: 2.0)),
                                // borderOnForeground: true,
                                child: Container(
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          des = value;
                                        });
                                      },
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: 'ABeeZee',
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Comment',
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    // alignment: Alignment.centerLeft,
                                    width: 200,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      color: Color(0xffc1ffe9),
                                      onPressed: () async {
                                        setState(() {
                                          flag = true;
                                        });
                                        var token = await storage.read(
                                            key: 'accessToken');
                                        var response = await http.post(
                                            Uri.encodeFull(
                                                '$serverIp/api/v1/ratings/?order_id=$id'),
                                            headers: {
                                              'Content-Type':
                                                  'application/json',
                                              'Accept': 'application/json',
                                              'Authorization': 'Bearer $token'
                                            },
                                            body:
                                                '{ "rating": $ratings , "comments" : "$des" } ');
                                        setState(() {
                                          flag = false;
                                        });

                                        if (response.statusCode == 401) {
                                          await refreshToken();
                                          var token = await storage.read(
                                              key: 'accessToken');
                                          response = await http.post(
                                              Uri.encodeFull(
                                                  '$serverIp/api/v1/ratings/?order_id=$id'),
                                              headers: {
                                                'Content-Type':
                                                    'application/json',
                                                'Accept': 'application/json',
                                                'Authorization': 'Bearer $token'
                                              },
                                              body:
                                                  '{ "rating": $ratings , "comments" : "$des" } ');
                                        }
                                        print(response.statusCode);
                                        print(response.body);
                                        if (response.statusCode == 200) {
                                          Navigator.pop(context);
                                          displayDialog(context, "Success",
                                              "Your Feedback has been saved");
                                        } else {
                                          displayDialog(
                                              context,
                                              "Error Occured!",
                                              "Try again later");
                                        }
                                      },
                                      child: Text(
                                        'Submit Feedback',
                                        style: TextStyle(
                                          color: Colors.teal[900],
                                          fontFamily: 'ABeeZee',
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ]),
                          SizedBox(
                            height: 20.0,
                          )
                        ],
                      )
                    : ChasingDots(),
              ),
            ),
          );
        });
  }
  // onPressed: () async {
  //                           if (ratings > 5) {
  //                             displayDialog(
  //                                 context, 'Error!', 'Rate out of 10');
  //                           } else {
  //                             var token =
  //                                 await storage.read(key: 'accessToken');
  //                             var response = await http.post(
  //                                 Uri.encodeFull(
  //                                     '$serverIp/api/v1/ratings/?order_id=$orderid'),
  //                                 headers: {
  //                                   'Content-Type': 'application/json',
  //                                   'Accept': 'application/json',
  //                                   'Authorization': 'Bearer $token'
  //                                 },
  //                                 body:
  //                                     '{ "rating": $ratings , "comments" : "$des" } ');

  //                             if (response.statusCode == 401) {
  //                               await refreshToken();
  //                               var token =
  //                                   await storage.read(key: 'accessToken');
  //                               response = await http.post(
  //                                   Uri.encodeFull(
  //                                       '$serverIp/api/v1/ratings/?order_id=$orderid'),
  //                                   headers: {
  //                                     'Content-Type': 'application/json',
  //                                     'Accept': 'application/json',
  //                                     'Authorization': 'Bearer $token'
  //                                   },
  //                                   body:
  //                                       '{ "rating": $ratings , "comments" : "$des" } ');
  //                             }
  //                             print(response.statusCode);
  //                             print(response.body);
  //                             if (response.statusCode == 200) {
  //                               Navigator.pop(context);
  //                               displayDialog(context, "Success",
  //                                   "Your Feedback has been saved");
  //                             } else {
  //                               displayDialog(context, "Error Occured!",
  //                                   "Try again later");
  //                             }
  //                           }
  //                         },
  openBottomSheet() {
    Get.bottomSheet(
      Container(
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Confirmation',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Are you sure you want to cancel the order?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.redAccent),
                ),
              ),
            ),
            ListTile(
                leading: Icon(Icons.assignment_turned_in),
                title: Text('Yes cancel'),
                onTap: () async {
                  await cancelOrder(widget.orderId);
                }),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text("Don't cancel"),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
//      barrierColor: Colors.greenAccent,
      elevation: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateTime.parse(date);
    print(dateFormat);
    dateFormat = dateFormat.add(Duration(hours: 5, minutes: 30));
    return Container(
      height: SizeConfig.blockSizeVertical * 31,
      child: Card(
        //borderOnForeground: true,

        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        elevation: 2,
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
          //child: Text('das\ndasd\ndsads\ndasda\ndasddsa\ndas'),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Order No : $orderNumber',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ABeeZee',
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Text(
                          DateFormat.jm().format(dateFormat),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'ABeeZee',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Text(
                          DateFormat.yMMMd().format(dateFormat),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'ABeeZee',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: 10,
                width: SizeConfig.blockSizeHorizontal * 80,
              ),
              // Row(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     mainAxisSize: MainAxisSize.min,
              //     children: <Widget>[
              //       Expanded(
              //           child: Row(
              //         children: <Widget>[
              //           Text(
              //             'Tracking number: ',
              //             textAlign: TextAlign.left,
              //           ),
              //           Text(
              //             ' $trackingNumber',
              //             textAlign: TextAlign.left,
              //             style: TextStyle(fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       ))
              //     ]),
              SizedBox(
                height: 11,
                width: SizeConfig.blockSizeHorizontal * 80,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      Text(
                        'Items: ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'ABeeZee',
                        ),
                      ),
                      Text(
                        ' ${quantity.length}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ABeeZee',
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                      child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'ABeeZee',
                        ),
                        children: [
                          TextSpan(text: "Total Amount :"),
                          TextSpan(
                              text: '$totalAmount',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ABeeZee',
                              ))
                        ]),
                    textAlign: TextAlign.right,
                  ))
                ],
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
                width: SizeConfig.blockSizeHorizontal * 80,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      'Details',
                      style: TextStyle(
                        fontFamily: 'ABeeZee',
                      ),
                    ),
                    color: Colors.white,
                    onPressed: () {
                      this.showDetailsCallback(context, orderDetails, quantity);
                    },
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  status == "Ordered" || status == "Packed"
                      ? RaisedButton(
                          child: Text(
                            'Cancel Order',
                            style: TextStyle(
                              fontFamily: 'ABeeZee',
                            ),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            openBottomSheet();
                          },
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        )
                      : Container(),
                  status == 'Delivered' || status == 'Cancelled'
                      ? RaisedButton(
                          child: Text(
                            'Give Feedback',
                            style: TextStyle(
                              fontFamily: 'ABeeZee',
                            ),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            givefeedback(widget.orderId);
                          },
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        )
                      : Container(),
                  Expanded(
                      child: Text(
                    '$status',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontFamily: 'ABeeZee',
                        color: this.statusColor,
                        fontWeight: FontWeight.bold),
                  ))
                ],
              )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(10, 10))),
      ),
    );
  }
}
