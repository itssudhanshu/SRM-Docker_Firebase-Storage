import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery/src/widgets/authentication.dart';
import '../widgets/MediaQueryGetSize.dart';
import '../widgets/customAppBar.dart';
import '../widgets/CartProductCard.dart';
import '../widgets/search_file.dart';
import '../widgets/constants.dart';
import 'categories_page.dart';
import '../widgets/constants.dart';
import '../widgets/CustomPaint.dart';
import 'checkout_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:http/http.dart' as http;
import '../widgets/Loader.dart';
import 'package:get/get.dart';

class MyCartPage extends StatefulWidget {
  bool hasBackButton = false;
  MyCartPage({this.hasBackButton = false});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyCart(hasBackButton: hasBackButton);
  }
}

class _MyCart extends State<MyCartPage> {
  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;

  //var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.search;
  var appBarText = "My Cart";
  var replaceRightIcon = false;
  double totalAmount = 0;
  double deliveryAmount = 15;
  Widget replacedRightWidget;
  Widget cartListCards;
  bool isLoading = true;
  var cartList = [];
  bool checkingOut = false;
  bool _isButtonDisabled;
  List<int> cartItemCartIds = [];
  BuildContext mycontext;
  Map localCartItemCache = new Map();
  bool hasBackButton = false;
  _MyCart({this.hasBackButton = false});
  updateTotalAmount(amount) {
    print('amount being updated $amount');
    setState(() {
      this.totalAmount = this.totalAmount + amount;
    });
    if (totalAmount == 0) {
      setState(() {
        _isButtonDisabled = true;
        cartListCards = emptyCartWidget();
      });
    }
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

  @override
  void initState() {
    super.initState();
    loadCartItems();
    _isButtonDisabled = true;
    //ordersListCards = Text('Loading . . . ');
    //orderList = [];
  }

  leftIconCallback() {
    Navigator.pop(context);
  }

  handleDelete(deleteCartId) {
    print('handling deleting $deleteCartId');
    print('handling deleting ${deleteCartId.runtimeType}');
    localCartItemCache.remove(deleteCartId);
    print(localCartItemCache);
    setState(() {
      cartListCards =
          SliverList(delegate: SliverChildListDelegate([ChasingDots()]));
      print(cartListCards);
    });
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        cartListCards = buildCartItems(localCartItemCache);
        if (totalAmount == 0) {
          cartListCards = emptyCartWidget();
        }
      });
    });
  }

  Widget buildCartItems(localCartList) {
    setState(() {
      isLoading = false;
    });
    var cartIdList = localCartList.keys.toList();

//    print('Building Cards ${cartList}');
//    '$productName',
//          quantity,
//          '$productvarient $productquantitytype',
//          productcost,
//          image,
//           cartId,
    //      variantname
    //['$productName', '$quantity', '$product_varient $product_quantity_type', productcost, image]);
    return (SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var tempCartId = cartIdList[index];
          var cartList = localCartItemCache[tempCartId];
          return ProductCard(
            prodName: cartList[0],
            cost: cartList[3],
            quantity: cartList[1],
            image: cartList[4],
            prodSize: cartList[2],
            cartId: cartList[5],
            updateAmtCallback: this.updateTotalAmount,
            deleteFromCartCallback: this.handleDelete,
            checkingOut: checkingOut,
            addCartObjectCallback: this.addCartObjectCallback,
            variantName: cartList[6],
          );
        },
        //addRepaintBoundaries: false,
        addRepaintBoundaries: false,
        addAutomaticKeepAlives: false,
        childCount: localCartList.length,
      ),
    ));
  }

  emptyCartWidget() {
    return SliverList(
        delegate: SliverChildListDelegate([
      Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 40, 5, 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset('assets/images/emptycart1.png'),
              Text(
                '           Your cart is empty :( \n Go Ahead and add some items !',
                style: TextStyle(
                  fontFamily: 'ABeeZee',
                ),
                softWrap: true,
              ),
            ],
          ),
        ),
      )
    ]));
  }

  Future<void> loadCartItems() async {
    //Api call to get orders of type $status

    //print('Called $status');

    totalAmount = 0;
    var getCartItems;
    var getCartItemsData;
    if (cartLocalCacheForCartPage['cartList'] == null) {
      setState(() {
        cartList = [];
        cartItemCartIds = [];
        cartListCards = SliverList(
            delegate: SliverChildListDelegate([
          Padding(padding: const EdgeInsets.all(160.0), child: Text(''))
        ]));
      });

      setState(() {
//        cartItemCartIds = [];
//        cartListCards = SliverList(
//            delegate: SliverChildListDelegate([
//          Padding(padding: const EdgeInsets.all(160.0), child: Text(''))
//        ]));
        isLoading = true;
      });
      var customerId = await storage.read(key: 'cust_id');
      print('cust_id $customerId');
      var token = await storage.read(key: 'accessToken');

      try {
        getCartItems = await http.get('$serverIp/api/v1/cart/', headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
      } catch (e) {
        //print(e);
        Fluttertoast.showToast(
            msg: 'Connection Error', toastLength: Toast.LENGTH_LONG);
        return;
      }

      if (getCartItems.statusCode == 401) //expired
      {
        //refresh token
        await refreshToken();
        var token = await storage.read(key: 'accessToken');
        try {
          getCartItems = await http.get('$serverIp/api/v1/cart/', headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
        } catch (e) {
          Fluttertoast.showToast(
              msg: 'Connection Error', toastLength: Toast.LENGTH_LONG);
          return;
        }
      }

      setState(() {
        isLoading = false;
      });

      print(getCartItems.statusCode);
      print('Orders ${getCartItems.body}');
      getCartItemsData = jsonDecode(getCartItems.body);
      cartLocalCacheForCartPage['cartList'] = getCartItemsData;
    } else {
      getCartItemsData = cartLocalCacheForCartPage['cartList'];
    }
    bool isCartListAvailable = false;
    try {
      if (getCartItems.statusCode == 200) {
        isCartListAvailable = true;
      }
    } catch (e) {
      if (cartLocalCacheForCartPage['cartList'] != null) {
        isCartListAvailable = true;
      }
    }

    //print(getCartItemsData[0]);
    //print(getCartItemsData.length);

    if (isCartListAvailable) {
      print('In constructing lists');
      for (int i = 0; i < getCartItemsData.length; i++) {
        print("anup $i");
        print("cart local cache $cartLocalCacheForCartPage");
        print("cart items $getCartItemsData");

        var productName = getCartItemsData[i]['product_name'];
        var variantName = getCartItemsData[i]['product_variant'];
        double productcost =
            double.tryParse(getCartItemsData[i]['product_cost']);
        int quantity = getCartItemsData[i]['quantity'];
        var cartId = getCartItemsData[i]['cart_id'];
        var productvarient = getCartItemsData[i]['variant_quantity'];
        var productquantitytype = getCartItemsData[i]['product_quantity_type'];
        var image = getCartItemsData[i]['image'];

        //print('$quantity $productcost ${quantity.runtimeType} ${productcost.runtimeType}');

        totalAmount = totalAmount + (quantity * productcost);

        var tempLi = [
          '$productName',
          quantity,
          '$productvarient $productquantitytype',
          productcost,
          image,
          cartId,
          variantName
        ];
        localCartItemCache[cartId] = tempLi;
//          cartList.add(tempLi);
//          cartList = localCartItemCache;
        cartItemCartIds.add(cartId);
      }
    } else {
      Fluttertoast.showToast(msg: 'Some error occuref');
    }
    print("CARTLIST $cartList");
    print("cartItemCArtIds :$cartItemCartIds");

    setState(() {
      cartListCards =
          SliverList(delegate: SliverChildListDelegate([ChasingDots()]));
      print(cartListCards);
      isLoading = false;
    });

    Timer(Duration(milliseconds: 50), () {
      if (localCartItemCache.length == 0) {
        setState(() {
          _isButtonDisabled = true;
          cartListCards = emptyCartWidget();
        });
      } else {
        setState(() {
          _isButtonDisabled = false;
          cartListCards = buildCartItems(localCartItemCache);
          isLoading = false;
          print('set Loading false');
        });
      }
    });

    //orderNumber: '123457',
//trackingNumber: '17abc999',
//quantity: 3,
//totalAmount: 500,
//status: 'Processing',
//date: '05-12-2019',
//statusColor: Colors.yellow,
  }

  var checkOutReturnResponse = [];
  addCartObjectCallback(jsonCartObj) {
    checkOutReturnResponse.add(jsonCartObj);
  }

  checkOut() {
    setState(() {
      checkingOut = true;
    });
//    Navigator.push(
//        context, MaterialPageRoute(builder: (context) => CheckoutPage()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var pageSize = SizeConfig().init(context);
    mycontext = context;

    print(isLoading);
    return Scaffold(
//      appBar: CustomAppBarWithoutSliver(
//        rightIcon: rightIcon,
//        hasLeftIcon: false,
//        hasRightIcon: true,
//        appBarText: "",
//        rightIconIsCart: false,
//        rightIconOnPressCallbackFunction: this.rightIconHandleClick,
//        replaceRightIcon: replaceRightIcon,
//        replacedRightWidget: replacedRightWidget,
//      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text("Press back button once again to exit the app"),
        ),
        child: CustomPaint(
          //painter: DrawCustomAppBar(),
          child: Container(
            child: CustomScrollView(
              slivers: <Widget>[
                CustomAppBar(
                  rightIcon: rightIcon,
                  hasLeftIcon: hasBackButton,
                  hasRightIcon: false,
                  appBarHeight: 27,
                  appBarText: "My Cart",
                  rightIconIsCart: false,
                  leftIcon: Icons.arrow_back,
                  leftIconOnPressCallbackFunction: () {
                    Navigator.pop(context);
                  },
                  rightIconOnPressCallbackFunction: this.rightIconHandleClick,
                  replaceRightIcon: replaceRightIcon,
                  replacedRightWidget: replacedRightWidget,
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 0.1,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(40, 18, 20, 32),
                          height: SizeConfig.blockSizeVertical * 50,
                          width: double.infinity,
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '',
                            style: TextStyle(
                              color: Color(0xff006c00),
                              fontSize: 28,
                              fontFamily: 'ABeeZeeItalic',
                            ),
                          )),
                    ),
                  ]),
                ),

                isLoading
                    ? SliverList(
                        delegate: SliverChildListDelegate([ChasingDots()]))
                    : cartListCards,

                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Total Amount :',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            '$totalAmount',
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RaisedButton(
                        disabledElevation: 0,
                        disabledColor: Color(appColor),
                        child: Text(
                          'CHECKOUT',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        color: Color(appColor),
                        onPressed: _isButtonDisabled
                            ? null
                            : () => (Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckoutPage(
                                        totalAmount: totalAmount,
                                        deliveryCharge: deliveryAmount,
                                        cartItemCartIds: cartItemCartIds)))),
                        textColor: Color(textColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    )
                  ]),
                )
                //ProductCard(),
              ],
            ),
          ),
        ),
      ),
//
    );
  }
}

class CustomTabs extends StatelessWidget {
  final icon;
  CustomTabs({this.icon});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: SizeConfig.blockSizeVertical * 10.3,
      width: SizeConfig.blockSizeHorizontal * 25,
      padding: EdgeInsets.only(
          bottom: SizeConfig.blockSizeVertical * 5,
          left: SizeConfig.blockSizeHorizontal * 0,
          top: SizeConfig.blockSizeVertical * 1),
      child: Icon(
        icon,
        size: SizeConfig.blockSizeVertical * 4.2,
      ),
    );
  }
}
