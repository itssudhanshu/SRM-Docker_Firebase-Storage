import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/widgets/Loader.dart';
import '../Functions/handleCartAddorDel.dart';
import '../widgets/constants.dart';

class ProductCard extends StatefulWidget {
  final prodName;
  final int quantity;
  final double cost;
  var image;
  final prodSize;
  var cartId;
  var updateAmtCallback;
  var deleteFromCartCallback;
  bool checkingOut;
  var addCartObjectCallback;
  var variantName;
  ProductCard(
      {this.cost,
      this.prodName,
      this.quantity,
      this.image,
      this.prodSize,
      this.updateAmtCallback,
      this.cartId,
      this.deleteFromCartCallback,
      this.checkingOut,
      this.addCartObjectCallback,
      this.variantName});

  @override
  State<StatefulWidget> createState() {
    print('checkingOut : $checkingOut');
    // TODO: implement createState
    return ProductCardState(
        quantity: this.quantity,
        prodSize: this.prodSize,
        prodName: this.prodName,
        cost: this.cost,
        image: this.image,
        cartId: this.cartId,
        updateAmtCallback: this.updateAmtCallback,
        deleteFromCartCallback: this.deleteFromCartCallback,
        checkingOut: checkingOut,
        addCartObjectCallback: addCartObjectCallback,
        variantName: variantName);
  }
}

class ProductCardState extends State<ProductCard> {
  final prodName;
  var variantName;
  int quantity;
  double cost;
  var image;
  var cartId;
  final prodSize;
  var updateAmtCallback;
  var deleteFromCartCallback;
  var checkingOut;
  var addCartObjectCallback;
  var headers;
  bool isLoading = false;

  ProductCardState(
      {this.cost,
      this.prodName,
      this.quantity,
      this.image,
      this.prodSize,
      this.updateAmtCallback,
      this.cartId,
      this.deleteFromCartCallback,
      this.checkingOut,
      this.addCartObjectCallback,
      this.variantName});

  getAccessToken() async {
    var token = await storage.read(key: 'accessToken');
    setState(() {
      headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccessToken();
  }

  handleBtnClick(btnText) async {
    setState(() {
      isLoading = true;
    });
    if (btnText == "+") {
//      setState(() {
//        this.quantity = this.quantity + 1;
//        handleCartAddorDel(
//            cartId: this.cartId,
//            quantity: this.quantity,
//            typeOfReq: 2);
//        this.updateAmtCallback(cost);
//      });
      var tempQuant = quantity + 1;
      print(cartId);
      print('isLoading set to false1');
      var status = await handleCartAddorDel(
          typeOfReq: 2, cartId: cartId, quantity: tempQuant);
      print('status $status ${status.runtimeType}');
      setState(() {
        if (status == 200) {
          quantity += 1;
          updateAmtCallback(cost);
        }
        isLoading = false;
      });
    } else {
      if (quantity >= 2) {
//        setState(() {
//          this.quantity = this.quantity - 1;
//          handleCartAddorDel(
//              cartId: this.cartId,
//              quantity: this.quantity,
//              typeOfReq: 2);
//          this.updateAmtCallback(-cost);
//        });
        var tempQuant = this.quantity - 1;
        var status = await handleCartAddorDel(
            typeOfReq: 2, cartId: cartId, quantity: tempQuant);
        setState(() {
          if (status == 200) {
            quantity = quantity - 1;
            updateAmtCallback(-cost);
          }
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //quantity = int.parse(quantity);
    //cost = int.parse(cost);
    print('cost ${cost.runtimeType}');
    print('quantity :${quantity.runtimeType}');
    print('callback :${updateAmtCallback.runtimeType}');
    print('\n\n');
    //image = "https://avatars0.githubusercontent.com/u/40356250?s=88&v=4";
    print(image);
    print('\n\n');
    return Card(
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      elevation: 0,
      child: ListTile(
        contentPadding: EdgeInsets.all(1),
//        leading: SizedBox(
//          height: 80,
//          width: 60,
//          child: Image.network(image),
        leading: Container(
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            image: DecorationImage(
                image: NetworkImage(image), fit: BoxFit.contain),
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

        trailing: isLoading
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
//                child: plainLoader(),
                child: Image.asset('assets/images/loader8.gif'),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(
                          height: 20,
                          width: 37,
                          child: RaisedButton(
                            child: Text('-',style: TextStyle(fontFamily: 'ABeeZee',),),
                            shape: CircleBorder(),
                            color: Colors.white,
                            onPressed: () {
                              if (quantity >= 2) {
                                handleBtnClick('-');
                              }
                            },
                          ),
                        ),
                      ),
                      Text('$quantity',style: TextStyle(fontFamily: 'ABeeZee',),),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(
                          height: 20,
                          width: 37,
                          child: RaisedButton(
                            child: Text('+',style: TextStyle(fontFamily: 'ABeeZee',),),
                            shape: CircleBorder(),
                            color: Colors.white,
                            onPressed: () {
                              handleBtnClick('+');
                            },
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SizedBox(
                          height: 20,
                          width: 37,
                          child: FlatButton(
                            child: Icon(Icons.delete),
                            shape: CircleBorder(),
                            color: Colors.transparent,
                            onPressed: () async {
//                          this.quantity = this.quantity + 1;
//                          this.updateAmtCallback(cost);
                              setState(() {
                                isLoading = true;
                              });
                              var tempstatus = await handleCartAddorDel(
                                  cartId: cartId, typeOfReq: 3);
                              print(
                                  'delete status $tempstatus  ${tempstatus.runtimeType}');
                              if (tempstatus == 200) {
                                print('1');

                                deleteFromCartCallback(cartId);
                                print('2');
                                updateAmtCallback(-cost * quantity);
                                print('3');
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        title: Text(
          '$prodName,$variantName\n',
          style: TextStyle(fontFamily: 'ABeeZee',),
          softWrap: true,
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$prodSize',style: TextStyle(fontFamily: 'ABeeZee'),),
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/rupeeIcon.png',
                  height: 15,
                ),
                Text(
                  '${cost * quantity}',
                  style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'ABeeZee',),
                )
              ],
            )
          ],
        ),
        isThreeLine: true,
        dense: true,
      ),
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
      ),
    );
  }
}
