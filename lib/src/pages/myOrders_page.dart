import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery/src/pages/home_page.dart';
import 'package:food_delivery/src/pages/profile_page.dart';
import 'package:food_delivery/src/screens/main_screen.dart';
import 'package:food_delivery/src/widgets/CustomPaint.dart';
import 'package:food_delivery/src/widgets/Loader.dart';
import 'package:food_delivery/src/widgets/MediaQueryGetSize.dart';
import 'package:food_delivery/src/widgets/showOrderDetails.dart';
import '../widgets/MediaQueryGetSize.dart';
import '../widgets/customAppBar.dart';
import '../widgets/CartProductCard.dart';
import '../widgets/MyOrdersCard.dart';
import '../widgets/search_file.dart';
import '../widgets/constants.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../widgets/authentication.dart';
import '../widgets/showOrderDetails.dart';
import '../widgets/Loader.dart';
import 'dart:async';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final TextEditingController _filter = new TextEditingController();
  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;
  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.search;
  var appBarText = "My Orders";
  var replaceRightIcon = false;
  var orderList = [];
  int activeBtn = 1;
  Widget ordersListCards = SliverList(
    delegate: SliverChildListDelegate([Text('')]),
  );
  var custId;
  Widget replacedRightWidget;
  bool isLoading = true;
  var pendingOrders = 0;
//  var pendingProcessing = 0;
  var pendingCancelled = 0;
  int showNotifyOrder = -100;
//  int showNotifyProcessing = -100;
  int showNotifyCancelled = -100;
  Timer timer;
  getPendingNotification() async {
    timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      var token = await storage.read(key: 'accessToken');
      var getOrders;
      try {
        getOrders = await http.get('$serverIp/api/v1/order_count/', headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
      } catch (e) {
        print(e);
        Fluttertoast.showToast(msg: 'Connection Error');
      }

      if (getOrders.statusCode == 401) //expired
      {
        //refresh token
        await refreshToken();
        try {
          getOrders = await http.get('$serverIp/api/v1/order_count/', headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
          var getOrdersData = jsonDecode(getOrders.body);
          print(getOrdersData);
          setState(() {
            print(getOrdersData);
            pendingOrders += int.parse(getOrdersData['delivered']);
            pendingCancelled += int.parse(getOrdersData['cancelled']);
          });
        } catch (e) {
          print(e);
          Fluttertoast.showToast(msg: 'Connection Error');
          return;
        }
      }
    });
  }

  initialisePendingOrders() async {
    var pendingOrdersData = await storage.read(key: 'pendingOrders');
    pendingOrders = int.parse(pendingOrdersData);
    var pendingCancelledData = await storage.read(key: 'pendingCancelled');
    pendingCancelled = int.parse(pendingCancelledData);

    print('secure storage pending orders $pendingOrders');
    print('secure storage pending Cancelled $pendingCancelled');
  }

  updatePendingOrders() async {
    storage.write(key: 'pendingOrders', value: '$pendingOrders');
    storage.write(key: 'pendingCancelled', value: '$pendingCancelled');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    updatePendingOrders();
  }

  @override
  void initState() {
    super.initState();
    handleClick('Processing');
    getPendingNotification();
    initialisePendingOrders();
    //ordersListCards = Text('Loading . . . ');
    //orderList = [];
  }

  leftIconCallback() {
//    _onBackPressed();
    Navigator.of(context).pop();
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

  Widget buildOrderCards(orderList) {
    //print('orderListLength : $orderList \n');
    return orderList == []
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
            (context, index) => Text(
              'No Orders',
              style: TextStyle(
                fontFamily: 'ABeeZee',
              ),
            ),
            childCount: 1,
          ))
        : (SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => MyOrdersCard(
                  orderId: orderList[index][8],
                  orderNumber: orderList[index][0],
                  trackingNumber: orderList[index][1],
                  quantity: orderList[index][2],
                  totalAmount: orderList[index][3],
                  status: orderList[index][4],
                  date: orderList[index][5],
                  statusColor: orderList[index][6],
                  orderDetails: orderList[index][7],
                  showDetailsCallback: this.showDetailsCallback),
              //addRepaintBoundaries: false,
              addRepaintBoundaries: false,
              addAutomaticKeepAlives: false,
              childCount: orderList.length,
            ),
          ));
  }

  Future<void> handleClick(status) async {
    //Api call to get orders of type $status

    //print('Called $status');

    //orderList = [];

    var color;
    switch (status) {
      case 'Processing':
        color = Color(0xffcccc00);
        activeBtn = 2;
        break;
      case 'Cancelled':
        color = Colors.red;
        activeBtn = 3;
        break;
      case 'Delivered':
        color = Colors.green;
        activeBtn = 1;
        break;
    }
    setState(() {
      orderList = [];
      isLoading = true;
    });
    var customerId = await storage.read(key: 'cust_id');
    print('cust_id $customerId');
    var token = await storage.read(key: 'accessToken');
    var getOrders;
    try {
      getOrders = await http.get(
          '$serverIp/api/v1/customer/order/?customer_id=$customerId&status=$activeBtn',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
    } catch (e) {
      print(e);
    }

    if (getOrders.statusCode == 401) //expired
    {
      //refresh token
      await refreshToken();
      var token = await storage.read(key: 'accessToken');

      getOrders = await http.get(
          '$serverIp/api/v1/customer/order/?customer_id=$customerId&status=$activeBtn',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
    }

    setState(() {
      isLoading = false;
    });

    //print(getOrders.statusCode);
    print('Orders ${getOrders.body} \n');
    var getOrdersData = jsonDecode(getOrders.body);
//    print('$getOrdersData\n\n');
//    print(getOrdersData.length);

    if (getOrders.statusCode == 200 && getOrdersData.length != 0) {
      for (int i = 0; i < getOrdersData.length; i++) {
        var orderNo = getOrdersData[i]['bill_no'];
        // var trackNo = getOrdersData[i]['bill_no'];
        var quantity = getOrdersData[i]['quantity'];
        var totalAmt = getOrdersData[i]['price'];
        var mystatus = getOrdersData[i]['status'];
        var date = getOrdersData[i]['date'];
        var retailerName = getOrdersData[i]['retailer_name'];
        var products = getOrdersData[i]['products'];
        var paymentType = getOrdersData[i]['payment_type'];
        var productsPrice = getOrdersData[i]['product_price'];
        var orderId = getOrdersData[i]['id'];
        var orderDetails = [];
        orderDetails.add(retailerName);
        orderDetails.add(paymentType);
        orderDetails.add(products);
        orderDetails.add(quantity);
        orderDetails.add(productsPrice);
        //orderDetails.add(productsPrice);
        //[Kirana stores, null, [Amul Butter, Nandini Milk], [4, 3], [100.0, 70.0]]
        print('\n\n');

        //print(orderDetails);
        //print('\n\n');
        orderList.add([
          '$orderNo',
          '17abc999',
          quantity,
          totalAmt,
          mystatus,
          date,
          color,
          orderDetails,
          orderId,
        ]);
      }
    }

    //print(orderList);
//    for (int i = 0; i < 1; i++) {
//      orderList.add(
//          ['123457' + '$i', '17abc999', 3, 500, status, '0$i-12-2019', color]);
//    }

    setState(() {
      isLoading = false;
      ordersListCards =
          SliverList(delegate: SliverChildListDelegate([ChasingDots()]));
    });

    Timer(Duration(milliseconds: 50), () {
      if (orderList.length == 0) {
        setState(() {
          ordersListCards = SliverList(
              delegate: SliverChildListDelegate([
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 40, 5, 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('No $status Orders Right Now :(',
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: 'ABeeZee',
                        )),
                    Image.asset('assets/images/noorder.png')
                  ],
                ),
              ),
            )
          ]));
        });
      } else {
        setState(() {
          ordersListCards = buildOrderCards(orderList);
        });
      }
    });
  }

  Widget buildRow(leftText, rightText) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 30, 12, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$leftText :',
            style: TextStyle(
              fontFamily: 'ABeeZee',
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            '$rightText',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'ABeeZee',
              fontSize: 19,
              color: Color(textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget getText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Ordered Products List ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'ABeeZee',
          fontSize: 20,
        ),
      ),
    );
  }

  void showDetailsCallback(BuildContext ctx, orderDetails, quantity) {
    var prodQuantity = [];
    var prodPrices = [];
    var index = -1;
    var productNames = orderDetails[2];
    prodQuantity = orderDetails[3];
    prodPrices = orderDetails[4];
    //print(productNames);
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: ListView.builder(
                shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                itemCount: productNames.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      index == 0
                          ? buildRow("Store Name", orderDetails[0])
                          : SizedBox(
                              height: 0,
                            ),
                      index == 0
                          ? buildRow("Payment Type", orderDetails[1])
                          : SizedBox(
                              height: 0,
                            ),
                      index == 0
                          ? getText()
                          : SizedBox(
                              height: 0,
                            ),
                      Card(
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(1),
                          leading: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage('/add images here'),
                                  fit: BoxFit.fitWidth),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black38,
                                  offset: new Offset(0, 1.9),
                                  blurRadius: 2.0,
                                )
                              ],
                            ),
//          child: Image.asset(
//            'assets/images/hide_and_seek.jpg',
//            fit: BoxFit.contain,
//          ),
                            constraints: BoxConstraints(maxWidth: 70),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${prodQuantity[index]}',
                              style: TextStyle(
                                fontFamily: 'ABeeZee',
                              ),
                            ),
                          ),
                          title: Text(
                            '${productNames[index]} \n',
                            style: TextStyle(
                              fontFamily: 'ABeeZee',
                            ),
                          ),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/rupeeIcon.png',
                                    height: 15,
                                  ),
                                  Text(
                                    '${prodPrices[index]}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'ABeeZee',
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          isThreeLine: true,
                          dense: true,
                        ),
                        // color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(10, 10)),
                        ),
                      ),
                    ],
                  );
                }),

//              ListView(
//              children: productNames.map<Widget>((item) {
//                print(item);
//                index += 1;
//                print(index);
//                return Card(
//                  margin: new EdgeInsets.symmetric(
//                      horizontal: 10.0, vertical: 10.0),
//                  elevation: 0,
//                  child: ListTile(
//                    contentPadding: EdgeInsets.all(1),
//                    leading: Container(
//                      height: 100,
//                      decoration: BoxDecoration(
//                        shape: BoxShape.rectangle,
//                        color: Colors.white,
//                        image: DecorationImage(
//                            image: AssetImage('/add images here'),
//                            fit: BoxFit.fitWidth),
//                        boxShadow: [
//                          new BoxShadow(
//                            color: Colors.black38,
//                            offset: new Offset(0, 1.9),
//                            blurRadius: 2.0,
//                          )
//                        ],
//                      ),
////          child: Image.asset(
////            'assets/images/hide_and_seek.jpg',
////            fit: BoxFit.contain,
////          ),
//                      constraints: BoxConstraints(maxWidth: 70),
//                    ),
//                    trailing: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Text('${prodQuantity[index]}'),
//                    ),
//                    title: Text('${productNames[index]} \n'),
//                    subtitle: Column(
//                      mainAxisSize: MainAxisSize.min,
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            Image.asset(
//                              'assets/images/rupeeIcon.png',
//                              height: 15,
//                            ),
//                            Text(
//                              '${prodPrices[index]}',
//                              style: TextStyle(fontWeight: FontWeight.bold),
//                            )
//                          ],
//                        )
//                      ],
//                    ),
//                    isThreeLine: true,
//                    dense: true,
//                  ),
//                  color: Colors.transparent,
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
//                  ),
//                );
//              }).toList(),
//            ),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  _refresh() {
    initialisePendingOrders();
  }

  Future<bool> _onBackPressed() {
//    widget.payload='';
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(
                  pageToDisplay: 2,
                )),
        (Route<dynamic> route) => false);
//    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var pageSize = SizeConfig().init(context);
    //print(storage.read(key: 'cust_id'));
    //pendingProcessing = 2;
//    pendingCancelled = 5;
//    pendingOrders = 12;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
//        appBar: CustomAppBarWithoutSliver(
//          rightIcon: rightIcon,
//          hasLeftIcon: true,
//          hasRightIcon: true,
//          appBarText: "",
//          leftIcon: leftIcon,
//          leftIconOnPressCallbackFunction: this.leftIconCallback,
//          rightIconIsCart: false,
//          rightIconOnPressCallbackFunction: this.rightIconHandleClick,
//          replaceRightIcon: replaceRightIcon,
//          replacedRightWidget: replacedRightWidget,
//        ),
          body: RefreshIndicator(
        onRefresh: () => _refresh(),
        child: CustomScrollView(
          slivers: <Widget>[
//          CustomAppBar(
//            appBarName: 'My orders',
//          ),
            CustomAppBar(
              rightIcon: rightIcon,
              hasLeftIcon: true,
              hasRightIcon: false,
              appBarText: "My Orders",
              leftIcon: leftIcon,
              leftIconOnPressCallbackFunction: this.leftIconCallback,
              appBarHeight: 27,
              rightIconIsCart: false,
              rightIconOnPressCallbackFunction: this.rightIconHandleClick,
              replaceRightIcon: replaceRightIcon,
              replacedRightWidget: replacedRightWidget,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
//          SizedBox(
//            height: SizeConfig.blockSizeVertical * 14,
//            child: Container(
//              padding: EdgeInsets.fromLTRB(40, 18, 20, 32),
//              height: SizeConfig.blockSizeVertical * 50,
//              width: double.infinity,
//              alignment: Alignment.bottomLeft,
//              child: Text(
//                '$appBarText',
//                style: TextStyle(
//                    color: Color(0xff006c00),
//                    fontSize: 28,
//                    fontStyle: FontStyle.italic),
//              ),
//            ),
//          ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Stack(
                      children: [
                        RaisedButton(
                          child: Text(
                            'Delivered  ',
                            style: TextStyle(
                              fontFamily: 'ABeeZee',
                            ),
                          ),
                          color: activeBtn == 1
                              ? Color(appBarColor)
                              : Colors.white,
                          onPressed: () {
                            handleClick('Delivered');
                            setState(() {
//                          showNotifyProcessing += 1;
                              if (showNotifyOrder < 0) {
                                showNotifyOrder = 2;
                              } else {
                                showNotifyOrder += 1;
                              }

                              showNotifyCancelled += 1;
                              pendingOrders = 0;
                            });
                          },
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
                        showNotifyOrder <= 1
                            ? pendingOrders > 0
                                ? Positioned(
                                    left: 64.0,
                                    child: RoundAddItemButton(
                                      text: pendingOrders,
                                    ),
                                  )
                                : Text('')
                            : Text(''),
                      ],
                    ),
                    Stack(
                      children: [
                        RaisedButton(
                          child: Text(
                            'Processing',
                            style: TextStyle(
                              fontFamily: 'ABeeZee',
                            ),
                          ),
                          color: activeBtn == 2 ? Colors.yellow : Colors.white,
                          onPressed: () {
                            handleClick('Processing');
                            setState(() {
//                          if (showNotifyProcessing < 0) {
//                            showNotifyProcessing = 2;
//                          } else {
//                            showNotifyProcessing += 1;
//                          }
                              showNotifyOrder += 1;
                              showNotifyCancelled += 1;
                            });
                          },
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
//                    showNotifyProcessing <= 2
//                        ? pendingProcessing != 0
//                            ? Positioned(
//                                left: 64.0,
//                                child: RoundAddItemButton(
//                                  text: pendingProcessing,
//                                ),
//                              )
//                            : Text('')
//                        : Text(''),
                      ],
                    ),
                    Stack(
                      children: [
                        RaisedButton(
                          child: Text(
                            'Cancelled',
                            style: TextStyle(
                              fontFamily: 'ABeeZee',
                            ),
                          ),
                          color: activeBtn == 3 ? Colors.red : Colors.white,
                          onPressed: () {
                            handleClick('Cancelled');
                            setState(() {
                              //showNotifyProcessing += 1;
                              showNotifyOrder += 1;
                              if (showNotifyCancelled < 0) {
                                showNotifyCancelled = 2;
                              } else {
                                showNotifyCancelled += 1;
                              }
                              pendingCancelled = 0;
                            });
                          },
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
                        showNotifyCancelled <= 1
                            ? pendingCancelled > 0
                                ? Positioned(
                                    left: 64.0,
                                    child: RoundAddItemButton(
                                      text: pendingCancelled,
                                    ),
                                  )
                                : Text('')
                            : Text(''),
                      ],
                    ),
                  ],
                ),
              )
            ])),
//                SliverList(
//                  delegate: SliverChildBuilderDelegate(
//                    (context, index) => MyOrdersCard(
//                      orderNumber: orderList[index][0],
//                      trackingNumber: orderList[index][1],
//                      quantity: orderList[index][2],
//                      totalAmount: orderList[index][3],
//                      status: orderList[index][4],
//                      date: orderList[index][5],
//                      statusColor: orderList[index][6],
//                    ),
//                    childCount: orderList.length,
//                  ),
//                ),
            isLoading
                ? SliverList(delegate: SliverChildListDelegate([ChasingDots()]))
                : ordersListCards
          ],
        ),
      )),
    );
  }
}

class RoundAddItemButton extends StatelessWidget {
  var text;
  var btnClickCallBack;
  Color btnColor;
  RoundAddItemButton(
      {this.text, this.btnClickCallBack, this.btnColor = Colors.pink});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //padding: EdgeInsets.fromLTRB(0, 0, 0, 18),
      child: SizedBox(
        height: SizeConfig.blockSizeVertical * 3,
        width: SizeConfig.blockSizeHorizontal * 11,
        child: FlatButton(
          child: Text(
            '$text',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'ABeeZee',
            ),
          ),
          shape: CircleBorder(),
          color: btnColor,
          onPressed: () {},
        ),
      ),
    );
  }
}
