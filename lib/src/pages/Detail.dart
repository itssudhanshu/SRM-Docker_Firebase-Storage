import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/src/pages/myCart.dart';
import 'package:food_delivery/src/screens/main_screen.dart';
import '../widgets/customAppBar.dart';
import 'package:flutter/widgets.dart';
import '../widgets/constants.dart';
import '../widgets/MediaQueryGetSize.dart';
import '../widgets/category_Description_Tabs.dart';
import '../widgets/CustomPaint.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Functions/handleCartAddorDel.dart';
import '../screens/main_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailPage extends StatefulWidget {
  bool hasVariety;
  var variant;
  var productName;
  var quantityType;
  var productId;
  var quantity;
  var image;
  var details;
  var cartInfo;
  var vendorId;
  DetailPage(
      {this.hasVariety,
      this.variant,
      this.productName,
      this.quantityType,
      this.productId,
      this.quantity,
      this.image,
      this.details,
      this.cartInfo,
      this.vendorId});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailPageState(
        hasVariety: this.hasVariety,
        variant: this.variant,
        productName: this.productName,
        productId: this.productId,
        quantityType: this.quantityType,
        quantity: this.quantity,
        images: this.image,
        details: this.details,
        cartInfo: cartInfo,
        vendorId: vendorId);
  }
}

class DetailPageState extends State<DetailPage> {
  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.shopping_cart;
  var appBarText = "Details";
  var replaceRightIcon = false;
  var details;
  bool hasVariety = false;
  List varietyItemList = [];
  List<Widget> itemImages = [];
  int _index = -1;
  int _current = 0;
  var quantityType;
  var productId;
  var variant;
  var quantity;
  var images;
  String productName = "";
  var cartInfo;
  var vendorId;

  DetailPageState(
      {this.hasVariety = false,
      this.variant,
      this.productName,
      this.quantityType,
      this.productId,
      this.quantity,
      this.images,
      this.details,
      this.cartInfo,
      this.vendorId});

//  [{"name":"Nandini","category":"Dairy Products","sub_category":"Milk",
//  "brand":"Hassan Dairies","quantity_type":"L",
//  "variant_details":[{"p_id":6,"variant":"Red Packet","quantity":"2","price":35.0},
//  {"p_id":5,"variant":"Red Packet","quantity":"1","price":20.0},{"p_id":7,"variant":"Blue Packet","quantity":"1","price":25.0},
//  {"p_id":8,"variant":"Blue Packet","quantity":"2","price":40.0}],
//  "image_url":"https://kirana-dev-1.s3.amazonaws.com/Nandini.png?AWSAccessKeyId=AKIAWWHS2HL5XAOKOGMU&Signature=QCGdxQGT6gcKKOa%2FZihniKbSPVA%3D&Expires=1585896338","details":"Details of milk"}
  @override
  void initState() {
    super.initState();
    haveLocalCartItems = cartItems.length != 0 ? true : false;
    //Api call to get image info (address)
    print('calling Api');
    print('variants $variant');
//    List<String> images = [
//      'assets/images/oreo1.jpg',
//      'assets/images/oreo2.jpg',
//      'assets/images/oreo3.jpg',
//      'assets/images/oreo4.jpg',
//      'assets/images/oreo5.jpg'
//    ];
    if (images.length == 0) {
      itemImages.add(Image.asset('assets/images/noImage.png'));
    } else {
      for (int i = 0; i < images.length; i++) {
        //itemImages.add(Image.asset(images[i]));
        var image;

        try {
          image = images[i];
        } catch (e) {
          image = "";
        }

        itemImages.add(Container(
          padding: EdgeInsets.all(10),
          //color: Color(textColor),

          child: ClipRRect(
            clipBehavior: Clip.hardEdge,

            borderRadius: BorderRadius.all(Radius.circular(10.0)),
//          child: Image.network(
//            images[i],
//            fit: BoxFit.cover,
//            width: 1000.0,
//          ),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/loader.gif',
              image: image,
              fit: BoxFit.cover,
              width: 1000.0,
            ),
//            child: CachedNetworkImage(
//              imageUrl: images[i],
//              placeholder: (context, url) =>
//                  Image.asset('assets/images/loader.gif'),
//              errorWidget: (context, url, error) =>
//                  new Icon(Icons.error_outline),
//            ),
          ),
        ));
      }
    }

    if (hasVariety) {
      //Get Variety Item List API call
      print('Hey');

      int cartListLen = cartInfo.length;
      print('Hey bYe');
      int cartprodId = 0;
      int cartquantity = 0;
      var cartId = 0;
      int cartVendorId = 0;

      for (int i = 0; i < this.variant.length; i++) {
        bool alreadyInCart = false;

        var varietyName = this.variant[i]['variant'];
        var varietyQuantity = this.variant[i]['quantity'];
        var quantityType = this.quantityType;
        var varietyCost = this.variant[i]['price'];
        int prodId = this.variant[i]['p_id'];
        print(' cartInfo in details $cartInfo');
        bool prodPresentInCartList = false;

        for (int j = 0; j < cartListLen; j++) {
          print('cartInfo in detail for loop $cartInfo');
          cartprodId = cartInfo[j][0];
          cartquantity = cartInfo[j][1];
          cartId = cartInfo[j][2];
          print('cartid from original cartList $cartId ${cartId.runtimeType}');
          cartVendorId = cartInfo[j][3];
          if (prodId == cartprodId && vendorId == cartVendorId) {
            //this prod exists in cart
            alreadyInCart = true;
            prodPresentInCartList = true;
            if (cartItems[prodId] == null) {
              cartItems[prodId] = [vendorId, cartquantity, cartId, 0];
            } else {
              if (cartItems[prodId] != '-1') {
                if (cartItems[prodId][3] == 1) {
                  prodPresentInCartList = false;
                }
              } else {
                alreadyInCart = false;
              }
            }

            break;
          }
        }
        if (!prodPresentInCartList) {
          if (haveLocalCartItems) {
            var productValueInMap = cartItems[prodId];
            if (productValueInMap != null && productValueInMap != '-1') {
              //prod present in local cartItems
              alreadyInCart = true;
              cartquantity = productValueInMap[1];
              cartId = productValueInMap[2];
            }
          }
        }
        varietyItemList.add([
          '$varietyName',
          '$varietyQuantity',
          '$quantityType',
          varietyCost,
          prodId,
          alreadyInCart,
          cartquantity,
          cartId
        ]);
      }
    }

//    varietyItemList.add(['Steam rice-Bidar quality ', '1Kg', 35]);
//    varietyItemList.add(['Basumati rice-Bidar quality ', '1Kg', 65]);
  }

  leftIconCallback() {
    Navigator.pop(context);
  }

  rightIconCallback() {
//    Navigator.of(context).push(MaterialPageRoute(
//        builder: (context) => MyCartPage(
//              hasBackButton: true,
//            )));
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => MainScreen(
//                  pageToDisplay: 1,
//                )));
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => MainScreen(
                  pageToDisplay: 1,
                )),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _index = -1;
    //print(itemImages);
    print('\n\nLocalCartItem $cartItems\n\n');
    var pageSize = SizeConfig().init(context);
    return Scaffold(
//      appBar: CustomAppBarWithoutSliver(
//        hasLeftIcon: true,
//        hasRightIcon: true,
//        leftIcon: leftIcon,
//        appBarText: appBarText,
//        leftIconOnPressCallbackFunction: this.leftIconCallback,
//        rightIconOnPressCallbackFunction: this.rightIconCallback,
//        replaceRightIcon: replaceRightIcon,
//        rightIcon: rightIcon,
//      ),
      body: CustomPaint(
//        painter: DrawCustomAppBar(context: context),
        child: CustomScrollView(
          slivers: <Widget>[
            CustomAppBar(
              hasLeftIcon: true,
              hasRightIcon: true,
              leftIcon: leftIcon,
              title: "Detail",
              //appBarText: appBarText,
              leftIconOnPressCallbackFunction: this.leftIconCallback,
              rightIconOnPressCallbackFunction: this.rightIconCallback,
              replaceRightIcon: replaceRightIcon,
              rightIcon: rightIcon,
              appBarHeight: 16,
            ),
//
//            SizedBox(
//              height: SizeConfig.blockSizeVertical * 20,
//              width: double.infinity,
//              child: Image.asset('assets/images/monaco.jpg'),
//            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Stack(children: [
                  CarouselSlider(
                    pauseAutoPlayOnTouch: Duration(seconds: 2),
                    items: itemImages,
                    autoPlay: true,
                    aspectRatio: 1.4,
                    onPageChanged: (index) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
//
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: itemImages.map((url) {
                    _index += 1;
                    // print('index $_index , _current $_current ');
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == _index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4)),
                    );
                  }).toList(),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '$productName ',
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                hasVariety
                    ? HasVariety(
                        varietyItemList: varietyItemList, vendorId: vendorId)
                    : NoVariety(
                        productCost: variant[0]['price'],
                        productWeight: this.quantityType,
                        productQuantity: variant[0]['quantity'],
                      ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 7,
                  width: double.infinity,
                  child: Container(
                    color: Color(0xffe6e6e6),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Important Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '$details ',
                    softWrap: true,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),

      //body: Text('da', style: TextStyle(color: Color(textColor))),
    );
  }
}

class NoVariety extends StatelessWidget {
  var productCost;
  var productWeight;
  var productQuantity;
  NoVariety(
      {Key key,
      this.productCost = "",
      this.productWeight = "",
      this.productQuantity = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Text(
            '$productQuantity $productWeight',
            style: TextStyle(color: Color(textColor)),
            //textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 7,
          ),
          Row(
            children: <Widget>[
              Image.asset(
                'assets/images/rupeeIcon.png',
                height: 15,
              ),
              Text(
                '$productCost',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}

class HasVariety extends StatefulWidget {
  List varietyItemList = [];
  var vendorId;
  HasVariety({this.vendorId, this.varietyItemList});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HasVarietyState(
        varietyItemList: varietyItemList, vendorId: vendorId);
  }
}

class HasVarietyState extends State<HasVariety> {
  var productCost;
  var productWeight;
  Widget AddBtnWidget;
  bool shouldShowAddBtn = true;
  String varietyName = "";
  var productQuantity = "";
  List varietyItemList = [];
  var vendorId;
  var prodId;
  var cartQuantity;
  bool alreadyInCart = false;
  var cartId;
  HasVarietyState({this.varietyItemList, this.vendorId});

  void _addPressed() {
    setState(() {
      this.AddBtnWidget =
          AddItemButtons(quantity: 1, zeroItemCallback: this.hadleZeroItem);
      shouldShowAddBtn = false;
    });
  }

  void hadleZeroItem() {
    setState(() {
//      this.AddBtnWidget = RaisedButton(
//        color: Colors.green,
//        onPressed: _addPressed,
//        child: Text("Add", style: TextStyle(color: Colors.white)),
//      );
      shouldShowAddBtn = true;
    });
  }

  @override
  void initState() {
    super.initState();
    //AddBtnWidget = MakeAddBtn(context);
  }

//  Widget MakeAddBtn(BuildContext context) {
//    return RaisedButton(
//      color: Colors.grey,
//      onPressed: _addPressed,
//      child: Text("Add", style: TextStyle(color: Colors.white)),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    //print('Has Variety class $varietyItemList');
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Text(
            'Variety:',
            style: TextStyle(color: Color(textColor)),
            //textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 12,
          ),
          Column(
              children: varietyItemList.map((eachItem) {
            varietyName = eachItem[0];
            productQuantity = eachItem[1];
            productWeight = eachItem[2];
            productCost = eachItem[3];
            prodId = eachItem[4];
            alreadyInCart = eachItem[5];
            cartQuantity = eachItem[6];
            cartId = eachItem[7];

            return Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '$varietyName $productQuantity $productWeight',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Image.asset(
                      'assets/images/rupeeIcon.png',
                      height: 15,
                    ),
                    Text(
                      '$productCost  ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FittedBox(
                      // alignment: Alignment.centerRight,
                      //fit: BoxFit.scaleDown,
                      child: SizedBox(
                          height: SizeConfig.blockSizeVertical * 3,
                          width: SizeConfig.blockSizeHorizontal * 25,
                          child: MakeAddBtn(
                              prodId: prodId,
                              vendorId: vendorId,
                              alreadyInCart: alreadyInCart,
                              cartQuantity: cartQuantity,
                              cartId: cartId)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            );
          }).toList()),
        ],
      ),
    );
  }
}

class MakeAddBtn extends StatefulWidget {
  var prodId;
  var vendorId;
  var alreadyInCart;
  var cartQuantity = 1;
  var cartId;
  MakeAddBtn(
      {this.vendorId,
      this.prodId,
      this.cartQuantity = 1,
      this.alreadyInCart = false,
      this.cartId});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MakeAddBtnState(
        vendorId: vendorId,
        prodId: prodId,
        alreadyInCart: alreadyInCart,
        cartQuantity: cartQuantity,
        cartId: cartId);
  }
}

class MakeAddBtnState extends State<MakeAddBtn> {
  Widget addBtnWidget;
  // bool shouldShowAddBtn = true;
  var prodId;
  var vendorId;
  var alreadyInCart;
  var cartQuantity = 1;
  var cartId;

  MakeAddBtnState(
      {this.vendorId,
      this.prodId,
      this.cartId,
      this.alreadyInCart = false,
      this.cartQuantity = 1});
  void _addPressed() {
    setState(() {
      this.addBtnWidget = AddItemButtons(
        quantity: 1,
        btnColor: Color(0xff004d00),
        zeroItemCallback: this.hadleZeroItem,
        alreadyInCart: false,
        prodId: prodId,
        vendorId: vendorId,
      );
    });
  }

//  addToCart() async {
//    cartId = await handleCartAddorDel(
//        prodId: prodId, vendorId: vendorId, typeOfReq: 1, quantity: cartQuantity);
//    print('cartId in Details ItomButtons : $cartId');
//  }
  @override
  void initState() {
    super.initState();
    alreadyInCart
        ? addBtnWidget = AddItemButtons(
            quantity: cartQuantity,
            btnColor: Color(0xff004d00),
            zeroItemCallback: this.hadleZeroItem,
            alreadyInCart: alreadyInCart,
            prodId: prodId,
            vendorId: vendorId,
            cartId: cartId,
          )
        : addBtnWidget = RaisedButton(
            color: Color(0xff004d00),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            onPressed: _addPressed,
            child: Text("Add", style: TextStyle(color: Colors.white)),
          );
  }

  void hadleZeroItem() {
    setState(() {
      cartItems[prodId] = '-1';
      this.addBtnWidget = RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(14.0),
        ),
        color: Color(0xff004d00),
        onPressed: _addPressed,
        child: Text("Add", style: TextStyle(color: Colors.white)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: addBtnWidget);
  }
}
