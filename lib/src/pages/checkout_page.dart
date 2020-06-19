import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/src/pages/manageAddress_page.dart';
import 'package:food_delivery/src/pages/payments_page.dart';
import 'package:food_delivery/src/widgets/Address_card.dart';
import 'package:food_delivery/src/widgets/authentication.dart';
import '../widgets/MediaQueryGetSize.dart';
import '../widgets/customAppBar.dart';
import '../widgets/CartProductCard.dart';
import '../widgets/search_file.dart';
import '../widgets/constants.dart';
import 'categories_page.dart';
import '../widgets/CustomPaint.dart';
import '../widgets/Address_card.dart';
import 'successful_page.dart';
import 'payments_page.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../widgets/Loader.dart';

enum SelectedPaymentMethod { COD, RajorPay }

class CheckoutPage extends StatefulWidget {
  double totalAmount;
  double deliveryCharge;
  List<int> cartItemCartIds;
  CheckoutPage({this.totalAmount, this.deliveryCharge, this.cartItemCartIds});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CheckoutPageState(
        orderAmount: totalAmount,
        deliveryAmount: deliveryCharge,
        cartItemCartIds: cartItemCartIds);
  }
}

class _CheckoutPageState extends State<CheckoutPage> {
  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;
  SelectedPaymentMethod _selectedPaymentMethod = SelectedPaymentMethod.COD;
  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.search;
  var appBarText = "";
  var replaceRightIcon = false;
  double orderAmount = 112;
  bool load = true;
  double deliveryAmount = 15;
  double totalAmount = 127;
  Widget replacedRightWidget;
  Razorpay _razorpay;
  List<int> cartItemCartIds;
  var orderId;
  bool alreadGotOrderId = false;
  bool isLoading = false;
  BuildContext myContext;

  _CheckoutPageState(
      {this.orderAmount, this.deliveryAmount, this.cartItemCartIds});

  Timer timer;
  @override
  void initState() {
    super.initState();
    timer = new Timer.periodic(
        Duration(seconds: 2),
        (Timer t) => setState(() {
              fetchAndASetShippingAddress();
            }));
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    timer.cancel();
  }

  errorCreatingOrderId() {
    print('called errorCreatungOrderId func');
    Fluttertoast.showToast(msg: 'ERROR creating order. Try again . .');
  }

  getOrderId(paymentType) async {
    var returnVal = [];
    print(paymentType.runtimeType);
    if (!alreadGotOrderId) {
      print('Getting OrderId . . . cartItemCartIds are : $cartItemCartIds');
      print("typr of prodIds: ${cartItemCartIds[0].runtimeType}");

      //print('')
      //var cartId;
      //print('C: $cartId Q : $quantity');
      var custId = await storage.read(key: 'cust_id');
      var custIdInt = int.parse(custId);
      print("typr of CustId: ${custIdInt.runtimeType}");
      var token = await storage.read(key: 'accessToken');

      var updateCart = await http.post('$serverIp/api/v1/customer/order/',
          body:
              '{"customer_address": "$address", "cart_items": $cartItemCartIds,"payment_type":"$paymentType"}',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          });

      if (updateCart.statusCode == 401) //expired
      {
        //refresh token
        print('Trying to get refresh access token');
        await refreshToken();
        token = await storage.read(key: 'accessToken');
        updateCart = await http.post('$serverIp/api/v1/customer/order/',
            body:
                '{"customer_address": $address, "cart_items": $cartItemCartIds}',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token',
            });
      }
      print(updateCart.statusCode);
      print('getOrderId.body ${updateCart.body}');
      var orderIddata = jsonDecode(updateCart.body);
      orderId = orderIddata['order_id'];
      print('orderId $orderId');
      returnVal.add(orderId);
      returnVal.add(updateCart.statusCode);
      if (updateCart.statusCode == 200) alreadGotOrderId = true;
    } else {
      returnVal.add(orderId);
      returnVal.add(200);
    }
    return returnVal;
  }

  void removeLoader(myContext) {
    Navigator.pop(myContext);
  }

  getConfirmation() {
//    Get.defaultDialog(
//        title: "Confirmation",
//        content: Text(
//          "Are you sure you want to place COD order?",
//          softWrap: true,
//        ),
//        confirm: FlatButton(
//          child: Text("Yes"),
//          onPressed: () => openCheckout(),
//        ),
//        cancel: FlatButton(
//          child: Text("Cancel"),
//          onPressed: () => Get.back(),
//        ));

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
                  'Are you sure you want to confirm the order?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.redAccent),
                ),
              ),
            ),
            ListTile(
                leading: Icon(Icons.assignment_turned_in),
                title: Text('Yes confirm!'),
                onTap: () => openCheckout()),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
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

  void openCheckout() async {
//    print('Checking Out ...orderId type ${orderId.runtimeType}');
//    print('Selected payment mode $_selectedPaymentMethod');
    if (address != '') {
      loader(myContext);
      if (_selectedPaymentMethod == SelectedPaymentMethod.COD) {
        var orderIdData = await getOrderId("COD");
        var statusCode = orderIdData[1];
        if (statusCode != 200) {
          errorCreatingOrderId();
          removeLoader(myContext);
          return;
        }

        removeLoader(myContext);
//      Fluttertoast.showToast(
//          msg: 'Order Successfull ! Your Order Will be Delivered Soon!');
////      Navigator.push(context,
//          MaterialPageRoute(builder: (context) => (Successful_page())));
        cartLocalCacheForCartPage.remove('cartList');
        cartLocalCache.remove('cartList');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Successful_page()),
            (Route<dynamic> route) => false);
      } else {
        var orderIdData = await getOrderId("RAZORPAY");
        var orderId = orderIdData[0];
        var statusCode = orderIdData[1];
        print('Checking Out ...orderId  $orderId');
        if (statusCode != 200) {
          errorCreatingOrderId();
          return;
        }
        print((orderAmount + deliveryAmount) * 100);
        removeLoader(myContext);
        var options = {
          'key': 'rzp_test_VdCgvaxDubfJRI',
          'amount': (orderAmount + deliveryAmount) * 100,
          'name': 'KIRANA',
          'description': '',
          'prefill': {'contact': '', 'email': ''},
          'order_id': '$orderId'

//      'key': 'rzp_test_YR097lzTHxHVkr',
//      'amount': '12700',
//      'name': 'KIRANA',
//      'currency': 'INR',
//      'description': 'Complete Payment',
//      'order_id': 'order_EMBFqjDHEEn80l',
//      'prefill': {'contact': '', 'email': ''},
//      'external': {
//        'wallets': {'paytm'}
//      }
        };

        try {
          _razorpay.open(options);
        } catch (e) {
          print('Error Occured opening razorpay');
          //debugPrint(e);
        }
        print('Successfully opened razorpay');
      }
    } else {
      Fluttertoast.showToast(msg: 'Please Select A Shipping Address');
    }
  }

  String address = '';
  List brokenAddress = [];

  fetchAndASetShippingAddress() async {
    String fetchedAddress = await storage.read(key: "selectedAddress");
    if (fetchedAddress == "") {
      address = await storage.read(key: 'default_address');
      setState(() {
        if(address!=null){
        brokenAddress = address.split(':');}
        load=false;
      });
    } else {
      setState(() {
        address = fetchedAddress;
        brokenAddress = address.split(':');
        load = false;
      });
    }

    print(brokenAddress);
  }

  updateOrderTable(paymentId, orderId, signature) async {
    print('updating order table');
    var token = await storage.read(key: 'accessToken');
    print('\npayment Id $paymentId orderId $orderId signature $signature\n\n');
    var updateCart = await http.post('$serverIp/api/v1/checkout/',
        body:
            '{"paymentId": "$paymentId", "orderId": "$orderId","signature":"$signature"}',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        });

    if (updateCart.statusCode == 401) //expired
    {
      //refresh token
      print('Trying to get refresh access token');
      await refreshToken();
      token = await storage.read(key: 'accessToken');
      updateCart = await http.post('$serverIp/api/v1/checkout/',
          body:
              '{"paymentId": "$paymentId", "orderId": "$orderId","signature":"$signature"}',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          });
    }
    print(updateCart.statusCode);
    print('getOrderId.body ${updateCart.body}');
    var res = [];
    res.add(updateCart.statusCode);
    var data = jsonDecode(updateCart.body);

    res.add(data);
    return res;
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    loader(myContext);
    print('Success in payment');
//    print('Success paymentId:' +
//        response.paymentId +
//        'orderId' +
//        response.orderId +
//        'signature' +
//        response.signature);
    print(
        '\n In handling Success payment Id ${response.paymentId} orderId ${response.orderId} signature ${response.signature}\n\n');

    var statusUpdate = await updateOrderTable(
        response.paymentId, response.orderId, response.signature);
    removeLoader(myContext);
    if (statusUpdate[0] == 200) {
      //succcess api call
      if (statusUpdate[1]['payment_status'] == 1) {
        //successful payment validation
        cartLocalCacheForCartPage.remove('cartList');
        cartLocalCache.remove('cartList');

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Successful_page()),
            (Route<dynamic> route) => false);
        Fluttertoast.showToast(
            msg: 'Successful payment',
            toastLength: Toast.LENGTH_LONG,
            fontSize: 15);
      } else {
        //couldnt verify successful payment
        Fluttertoast.showToast(
            msg: 'Error in payment validation ',
            toastLength: Toast.LENGTH_LONG,
            fontSize: 15);
      }
    } else {
      Fluttertoast.showToast(
          msg: 'connection failure',
          toastLength: Toast.LENGTH_LONG,
          fontSize: 15);
    }
//    await Fluttertoast.showToast(
//        msg: 'Success paymentId:' +
//            response.paymentId +
//            'orderId' +
//            response.orderId +
//            'signature' +
//            response.signature);
    //    Navigator.push(
//        context, MaterialPageRoute(builder: (context) => (Successful_page())));
//
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('error in payment ');
    print('ERROR ' + response.code.toString() + " . " + response.message);
    Fluttertoast.showToast(
        msg: 'ERROR ' + response.code.toString() + " . " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Wallet error in payment');
    Fluttertoast.showToast(msg: 'External Wallet' + response.walletName);
  }

  rightIconHandleClick() {
    setState(() {
      replaceRightIcon = !replaceRightIcon;
      replacedRightWidget = SearchField(
        textFieldColor: Color(appBarColor),
        hinttext: "Search",
        iconcolor: Color(appBarColor),
      );
    });
  }

  leftIconHandlePress() {
    Navigator.pop(context);
  }

  void handleAddressBtnPress() {
    // Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddressPage()));
    print('called');
  }

  Widget createRadio(text) {
    var x = SelectedPaymentMethod.COD;
    var color;
    var extraText;
    bool showRadio = false;
    if (text == 'COD') {
      x = SelectedPaymentMethod.COD;
      extraText = "";
      showRadio = true;
      color = Colors.grey;
    } else {
      x = SelectedPaymentMethod.RajorPay;
      extraText = "Coming Soon !";
      color = Color(0xff006c00);
    }

    return (Row(
      children: <Widget>[
        showRadio
            ? Radio(
                activeColor: color = Color(0xff006c00),
                value: x,
                groupValue: _selectedPaymentMethod,
                onChanged: (SelectedPaymentMethod value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
              )
            : SizedBox(
                width: 20,
              ),
        Text(
          '$text  ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'ABeeZee',
            color: showRadio ? Color(0xff006c00) : Colors.grey,
          ),
        ),
        showRadio
            ? Text('')
            : SizedBox(
                child: Image.asset('assets/images/comingSoon2.gif'),
                width: 70,
                height: 40,
              ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    print('called checkut');
    myContext = context;
    setState(() {
      totalAmount = orderAmount + deliveryAmount;
    });
    var pageSize = SizeConfig().init(context);
    return Scaffold(
      appBar: CustomAppBarWithoutSliver(
        rightIcon: rightIcon,
        leftIcon: leftIcon,
        leftIconOnPressCallbackFunction: leftIconHandlePress,
        hasLeftIcon: true,
        hasRightIcon: false,
        appBarText: "Checkout",
        rightIconIsCart: false,
        rightIconOnPressCallbackFunction: this.rightIconHandleClick,
        replaceRightIcon: replaceRightIcon,
        replacedRightWidget: replacedRightWidget,
      ),
      body: CustomPaint(
        painter: DrawCustomAppBar(height: SizeConfig.blockSizeVertical * 1.5),
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 12,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(40, 18, 20, 32),
                        height: SizeConfig.blockSizeVertical * 50,
                        width: double.infinity,
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '$appBarText',
                          style: TextStyle(
                              fontFamily: 'ABeeZee',
                              color: Color(0xff006c00),
                              fontSize: 28,
                              fontStyle: FontStyle.italic),
                        )),
                  ),
                  Text(
                    '   Shipping Address',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,fontFamily: 'ABeeZee',),
                  ),
                  GestureDetector(
                    onTap: () => (Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressPage()))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: address == '' || brokenAddress.isEmpty
                              ? load==true?ChasingDots():Container(
                                  // alignment: Alignment.centerLeft,
                                  width: double.infinity,
                                  height: 100,
                                  child: Card(
                                      elevation: 5,
                                      child: Center(
                                        child: Container(
                                            // height: 30,
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              'No Address Selected',
                                              style: TextStyle(
                                                  fontFamily: 'ABeeZeeItalic',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            // SizedBox(height: 5,),
                                            FlatButton(
                                              child: Text(
                                                'Select',
                                                style: TextStyle(
                                                    fontFamily: 'ABeeZee',
                                                    color: Color(textColor)),
                                              ),
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddressPage())),
                                            )
                                          ],
                                        )),
                                      )),
                                )
                          : load==true?ChasingDots():Address_card(
                              needCheckBox: false,
                              buttonText: 'Change',
                              buttonCallback: handleAddressBtnPress,
                              name: brokenAddress[0],
                              line1: brokenAddress[1],
                              line2: brokenAddress[2],
                            ),
                    ),
                  ),
//                  GestureDetector(
//                    child: paymentCard(),
//                    onTap: () => (Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => (PaymentsPage())))),
//                  ),
                  createRadio('COD'),
                  createRadio('Pay using other methods'),
                ]),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Order :',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'ABeeZee',
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/rupeeIcon.png',
                              height: 15,
                            ),
                            Text(
                              '$orderAmount',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontFamily: 'ABeeZee',),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Delivery:',
                          style: TextStyle(
                            fontFamily: 'ABeeZee',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/rupeeIcon.png',
                              height: 15,
                            ),
                            Text(
                              '$deliveryAmount',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontFamily: 'ABeeZee',),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Summary :',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'ABeeZee',
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/rupeeIcon.png',
                              height: 15,
                            ),
                            Text(
                              '${orderAmount + deliveryAmount}',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontFamily: 'ABeeZee',),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: RaisedButton(
                      child: Text(
                        'Submit Order',
                        style: TextStyle(fontFamily: 'ABeeZeeItalic',),
                      ),
                      color: Color(appColor),
                      onPressed: () => address == '' || brokenAddress.isEmpty
                          ? Fluttertoast.showToast(
                              msg: 'Please select address',
                              toastLength: Toast.LENGTH_LONG)
                          : (getConfirmation()),
                      textColor: Color(textColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class paymentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: SizeConfig.blockSizeVertical * 25,
      child: Card(
        //borderOnForeground: true,

        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        elevation: 0,
        child: Container(
            padding: EdgeInsets.all(5),
            //child: Text('das\ndasd\ndsads\ndasda\ndasddsa\ndas'),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Payment',
                        style: TextStyle(
                            fontFamily: 'ABeeZee',
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        'change',
                        style: TextStyle(color: Color(textColor),fontFamily: 'ABeeZee',),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (PaymentsPage())));
                      },
                    ),
//
                  ],
                ),
                SizedBox(
                  height: 8,
                  width: SizeConfig.blockSizeHorizontal * 80,
                ),
                Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          image: DecorationImage(
                              image: AssetImage('assets/images/mastercard.png'),
                              fit: BoxFit.fitWidth),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.black38,
                              offset: new Offset(0, 1.9),
                              blurRadius: 2.0,
                            )
                          ],
                        ),
//
                        constraints: BoxConstraints(maxWidth: 70),
                      ),
//                      SizedBox(
//                        height: SizeConfig.blockSizeVertical * 7,
//                        child: Image.asset(
//                          'assets/images/mastercard.png',
//                          fit: BoxFit.contain,
//                        ),
//                        child: Text('adssd'),
//                      ),
                      Text(
                        '**** **** **** 3947' +
                            '                                ',
                        style: TextStyle(),
                        textAlign: TextAlign.right,
                        softWrap: true,
                      ),

//
                    ]),
                SizedBox(
                  height: 11,
                  width: SizeConfig.blockSizeHorizontal * 80,
                ),
              ],
            )),
      ),
    );
  }
}
