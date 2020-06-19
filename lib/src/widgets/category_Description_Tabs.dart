import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/Functions/handleCartAddorDel.dart';
import 'package:food_delivery/src/pages/Detail.dart';
import 'Loader.dart';
import 'MediaQueryGetSize.dart';
import 'constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryDescription extends StatefulWidget {
  var hasVariety = false;
  var productName;
  var variant;
  var vendorId;
  var cartInfo;
  var image;
  var index;

  CategoryDescription(
      {this.productName,
      this.hasVariety,
      this.variant,
      this.vendorId,
      this.cartInfo,
      this.image,
      this.index});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryDescriptionState(
        productName: productName,
        hasVariety: hasVariety,
        vendorId: this.vendorId,
        variant: variant,
        cartInfo: this.cartInfo,
        image: image,
        index: index);
  }
}

class CategoryDescriptionState extends State<CategoryDescription> {
  var hasVariety = false;
  var productName;
  var variant;
  var vendorId;
  var prodId;
  var cartInfo;
  var image;
  var index;
  var prodTextColor = Color(textColor);
  bool alreadyInCart = false;
  var textBackgroundColor = Color(appBarColor);

  Widget topRightWidget;
  CategoryDescriptionState(
      {this.productName,
      this.hasVariety,
      this.variant,
      this.vendorId,
      this.cartInfo,
      this.image,
      this.index});

  void _addPressed({cartQuantity = 1, cartId}) {
    setState(() {
      this.topRightWidget = AddItemButtons(
          quantity: cartQuantity,
          zeroItemCallback: this.hadleZeroItem,
          vendorId: vendorId,
          prodId: prodId,
          cartId: cartId,
          index: index,
          alreadyInCart: alreadyInCart);
    });
  }

//cartInfo[cartquantity, cartId]
  checkProdIncart() {
    if (cartInfo.length > 1) {
      alreadyInCart = true;
    }

    alreadyInCart
        ? _addPressed(cartQuantity: cartInfo[0], cartId: cartInfo[1])
        : topRightWidget = RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(15.0))),
            color: Colors.pink,
            onPressed: _addPressed,
            child: Text("Add",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'ABeeZee',
                )),
          );
  }

  @override
  void initState() {
    super.initState();
    print('in category description tabs$variant');
    prodId = variant[0]['p_id'];
//    if (index % 2 != 0) {
//      textBackgroundColor = Color(0xffffb84d);
//      prodTextColor = Colors.white;
//    }

    checkProdIncart();
  }

  void hadleZeroItem() {
    setState(() {
      alreadyInCart = false;
      this.topRightWidget = RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(15.0))),
        color: Colors.pink,
        onPressed: _addPressed,
        child: Text("Add",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'ABeeZee',
            )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    textBackgroundColor = Colors.black;
    return Container(
      //height: SizeConfig.blockSizeVertical * 80.5,
      //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      //height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: ,
        children: <Widget>[
          FittedBox(
              alignment: Alignment.topRight,
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
//            crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                      width: hasVariety
                          ? SizeConfig.blockSizeHorizontal * 15
                          : SizeConfig.blockSizeHorizontal * 23,
                      child: hasVariety
                          ? Container(
                              width: 5,
                              decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15.0))),
                              // color: Colors.pink,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            )
                          : topRightWidget),
                ],
              )),
          Center(
            child: Container(
              width: double.infinity,
              height: 35,
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.blueGrey),
                //shape: BoxShape.rectangle,

                color: Colors.white.withOpacity(0.7),

                borderRadius: BorderRadiusDirectional.vertical(
                    top: Radius.circular(0), bottom: Radius.circular(15)),
//                  borderRadius: BorderRadius.all(
//                      Radius.circular(15.0) //         <--- border radius here
//                      ),
                // color: textBackgroundColor,
              ),
              child: Center(
                child: Container(
//                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '$productName',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                        fontFamily: 'ABeeZee',
                        //height: SizeCon
                        // fig.blockSizeVertical * 2,
                        //background: Paint()..color = Colors.grey,
//                        color: Color(textColor),
                        color: prodTextColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.all(
            Radius.circular(15.0) //         <--- border radius here
            ),
        shape: BoxShape.rectangle,
        color: Colors.white,
        image: DecorationImage(
          image: NetworkImage(
            '$image',
          ),
          fit: BoxFit.contain,
        ),
        boxShadow: [
          new BoxShadow(
            color: Colors.black38,
            offset: new Offset(1.9, 1.9),
            blurRadius: 2.0,
          )
        ],
      ),
//          child: Image.asset(
//            'assets/images/hide_and_seek.jpg',
//            fit: BoxFit.contain,
//          ),
//      constraints: BoxConstraints(
//        maxWidth: 90,
//        //minWidth: 90,
//        //minHeight: SizeConfig.blockSizeVertical * 40.5,
//      ),
    );
  }
}

class AddItemButtons extends StatefulWidget {
  var quantity;
  //var zeroItemCallback;
  var vendorId;
  Color btnColor;
  var zeroItemCallback;
  var prodId;
  var cartId;
  var alreadyInCart;
  var index;

  AddItemButtons(
      {this.quantity,
      this.vendorId,
      this.zeroItemCallback,
      this.btnColor = Colors.pink,
      this.prodId,
      this.cartId,
      this.alreadyInCart,
      this.index});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddItemButtonsState(
        quantity: quantity,
        zeroItemCallback: zeroItemCallback,
        btnColor: btnColor,
        vendorId: vendorId,
        prodId: prodId,
        cartId: cartId,
        alreadyInCart: alreadyInCart,
        index: index);
  }
}

class AddItemButtonsState extends State<AddItemButtons> {
  var quantity;
  var zeroItemCallback;
  var vendorId;
  var prodId;
  Color btnColor;
  var cartId;
  var alreadyInCart;
  var index;
  bool isLoading = false;
  AddItemButtonsState(
      {this.quantity,
      this.prodId,
      this.zeroItemCallback,
      this.vendorId,
      this.btnColor = Colors.pink,
      this.cartId,
      this.alreadyInCart,
      this.index});

  bool thisProdIsInLocalMap = false;
  addToCart() async {
    setState(() {
      isLoading = true;
    });
    try {
      var addcartData = await handleCartAddorDel(
          prodId: prodId, vendorId: vendorId, typeOfReq: 1, quantity: quantity);
      cartId = addcartData[0];
      var apicallStatus = addcartData[1];
      print(
          'cartid from local cartList $cartId ${cartId.runtimeType} status: $apicallStatus');
      if (apicallStatus == 200) {
        var tempCartId = int.parse(cartId);
        cartItems[prodId] = [vendorId, quantity, tempCartId, 0];

        localCartItemsInProductsPage[prodId] = [
          quantity,
          tempCartId,
        ];

//        int i;
//        for (i = 0; i < totalproductListLength; i++) {
//          var eachprodId = TotalproductList[i][3][0]['p_id'];
//          if (eachprodId == prodId) break;
//        }
        print("TotalProdList 1: index $index  ");
        if (index != null) {
          TotalproductList[index][6] = [
            quantity,
            tempCartId,
          ];
        }

        print("TotalProdList 1:  index $index");

        print(
            'adding new cart item into local map $localCartItemsInProductsPage');
        thisProdIsInLocalMap = true;
      } else {
        this.zeroItemCallback();
      }
    } catch (e) {
      print(e);
      this.zeroItemCallback();
    }
    setState(() {
      isLoading = false;
    });
    print('cartId in ItomButtons : $cartId');
  }

  @override
  void initState() {
    print('InitState');
    if (cartItems[prodId] == null) {
      //this prod is not in cartItems local map in constants.dart
      thisProdIsInLocalMap = false;
    } else {
      thisProdIsInLocalMap = true;
    }
    index = localCartItemsIndexInProductsPage[prodId];
    super.initState();
    if (!alreadyInCart) addToCart();
  }

  handleBtnClick(btnText) async {
    setState(() {
      isLoading = true;
    });
    if (btnText == "+") {
      var tempQuant = quantity + 1;
      print(cartId);
      print('isLoading set to false1');
      var status = await handleCartAddorDel(
          typeOfReq: 2, cartId: cartId, quantity: tempQuant);
      print('status $status ${status.runtimeType}');
      setState(() {
        if (status == 200) {
          quantity += 1;
          if (localCartItemsInProductsPage[prodId] == null ||
              localCartItemsInProductsPage[prodId] == "-1") {
            localCartItemsInProductsPage[prodId] = [quantity, cartId];
          } else {
            localCartItemsInProductsPage[prodId][0] += 1;
          }
          if (index != null) {
            TotalproductList[index][6] = [quantity, cartId];
          }

          if (thisProdIsInLocalMap) {
            //print('Increasing quant in localCartListMap');
            cartItems[prodId][1] += 1;
            cartItems[prodId][3] =
                1; //1 means the state of quantity is modified hence use local cart list rather than the cartList from api
          }
        }

        isLoading = false;
      });
    } else {
      if (quantity >= 2) {
        var tempQuant = this.quantity - 1;
        var status = await handleCartAddorDel(
            typeOfReq: 2, cartId: cartId, quantity: tempQuant);
        setState(() {
          if (status == 200) {
            this.quantity = this.quantity - 1;
            print('cartId type ${cartId.runtimeType}');
            if (localCartItemsInProductsPage[prodId] == null ||
                localCartItemsInProductsPage[prodId] == "-1") {
              localCartItemsInProductsPage[prodId] = [quantity, cartId];
            } else {
              localCartItemsInProductsPage[prodId][0] -= 1;
            }
            if (index != null) {
              TotalproductList[index][6] = [quantity, cartId];
            }

            if (thisProdIsInLocalMap) {
              print('decreasing quant in localCartListMap');
              cartItems[prodId][1] -= 1;
              cartItems[prodId][3] =
                  1; //1 means the state of quantity is modified hence use local cart list rather than the cartList from api
            }
          }

          isLoading = false;
        });
      } else {
        if (quantity == 1) {
          var status = await handleCartAddorDel(cartId: cartId, typeOfReq: 3);
          if (status == 200) {
            if (localCartItemsInProductsPage[prodId] != null) {
              localCartItemsInProductsPage[prodId] = "-1";
//              int i;
//              for (i = 0; i < totalproductListLength; i++) {
//                var eachprodId = TotalproductList[i][3][0]['p_id'];
//                if (eachprodId == prodId) break;
//              }
              if (index != null) {
                TotalproductList[index][6] = [];
              }
            }
            this.zeroItemCallback();
          }
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('In addButton $vendorId $prodId');
    return isLoading
//        ? plainLoader(height: 10, width: 10)
        ? Image.asset(
            'assets/images/loader6.gif',
            fit: BoxFit.contain,
          )
        : Opacity(
            opacity: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              // alignment: Alignment.center,
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RoundAddItemButton(
                    btnClickCallBack: this.handleBtnClick,
                    text: '-',
                    btnColor: btnColor,
                  ),
                  Text(
                    '$quantity',
                    style: TextStyle(
                      color: Colors.pink,
                      fontFamily: 'ABeeZee',
                    ),
                  ),
                  RoundAddItemButton(
                    btnClickCallBack: this.handleBtnClick,
                    text: '+',
                    btnColor: btnColor,
                  )
//
                ],
              ),
            ),
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
    return Center(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          height: SizeConfig.blockSizeVertical * 3,
          width: SizeConfig.blockSizeHorizontal * 9,
          child: RaisedButton(
            child: Text(
              '$text',
              style: TextStyle(
                fontFamily: 'ABeeZee',
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            shape: CircleBorder(),
            color: btnColor,
            onPressed: () {
              this.btnClickCallBack(this.text);
            },
          ),
        ),
      ),
    );
  }
}
