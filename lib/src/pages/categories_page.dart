import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery/src/pages/myCart.dart';
import '../widgets/search_file.dart';
import '../widgets/customAppBar.dart';
import 'package:flutter/widgets.dart';
import '../widgets/constants.dart';
import '../widgets/MediaQueryGetSize.dart';
import '../widgets/category_top_tabs.dart';
import '../widgets/category_Description_Tabs.dart';
import '../widgets/CustomPaint.dart';
import 'Detail.dart';
import 'dart:async';
import 'dart:convert';
import '../screens/main_screen.dart';
import 'package:http/http.dart' as http;
import '../widgets/authentication.dart';
import '../Functions/handleCartAddorDel.dart';
import '../widgets/Loader.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CategoryPage extends StatefulWidget {
  final int vendorId;
  final String name;

  CategoryPage({this.vendorId, this.name});
  //var vendorId;
  //CategoryPage({this.vendorId = 3});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryPageState(vendorId: this.vendorId, name: name);
  }
}

class CategoryPageState extends State<CategoryPage> {
  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.shopping_cart;
  // var appBarText = widget.title;
  var replaceRightIcon = false;
  List activeProdList = [];
  List productList = [];
  var categoryList;
  var variant;
  var vendorId = 3;
  var cust_id;
  var searchText = "";
  var name;
  var categoryNameSearch = "All";

  CategoryPageState({this.vendorId = 3, this.name = "Kirana Shop"});
  bool isLoading = true;
  Widget productItems = Text(
    'Loading . . .',
    style: TextStyle(
      fontFamily: 'ABeeZee',
    ),
  );
  Widget categoryItems = Text(
    'Loading. . .,',
    style: TextStyle(
      fontFamily: 'ABeeZee',
    ),
  );
//  Widget loader = plainLoader();
  Widget loader = Image.asset('assets/images/loader10.gif');

  filterCategory(categoryName) {
    print(categoryName);
    categoryNameSearch = categoryName;
    setState(() {
//      productList = new List();
      productItems = Text('');
    });
    Timer(Duration(milliseconds: 50), () {
      print(TotalproductList);
      if (categoryName == "All") {
        productList = TotalproductList;
//        print(TotalproductList[3]);
      } else {
        productList = new List();
        print('\n\n$totalproductListLength\n');
        for (int i = 0; i < totalproductListLength; i++) {
          print('each category name : ${TotalproductList[i][7]} i: $i');
          var eachCategoryName = TotalproductList[i][7];
          var prodId = TotalproductList[i][3][0]['p_id'];
          bool hasVariety = TotalproductList[i][2];
          if (!hasVariety) {
            print('cartNew Info1 :$localCartItemsInProductsPage');
            if (localCartItemsInProductsPage[prodId] != null) {
              if (localCartItemsInProductsPage[prodId] == "-1") {
                TotalproductList[i][6] = [];
              } else {
                print('cartNew Info :${localCartItemsInProductsPage[prodId]}');
                TotalproductList[i][6] = localCartItemsInProductsPage[prodId];
              }
            }
          }

          if (eachCategoryName.toLowerCase() == categoryName.toLowerCase()) {
            productList.add(TotalproductList[i]);
          }
        }
//        print(TotalproductList[3]);
      }
      setState(() {
        activeProdList = productList;
        productItems = buildProductItems(productList);
      });
    });
  }

  updateProdList(text) {
    setState(() {
//      productList = new List();
      productItems = Text('');
    });
    Timer(Duration(milliseconds: 50), () {
      print(TotalproductList);
      if (text == "") {
        productList = activeProdList;
      } else {
        productList = new List();
        print('\n\n$totalproductListLength\n');
        for (int i = 0; i < activeProdList.length; i++) {
          print('each prod name : ${activeProdList[i][0]} i: $i');
          var eachProdName = activeProdList[i][0];
          if (eachProdName.toLowerCase().contains(text.toLowerCase())) {
            productList.add(activeProdList[i]);
          }
        }
      }
      setState(() {
        productItems = buildProductItems(productList);
      });
    });
  }

  searchPressCallback(text) {
    print(text);
    updateProdList(text);
    return 0;
  }

//  Widget widgetOnBottomAppBar = SearchField(
//      hinttext: "Search Store",
//      textFieldColor: Colors.white70,
//      iconcolor: Color(appBarColor),
//      searchPressCallback: searchPressCallback);

  leftIconCallback() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    cartItems.clear();
    print('cleared cartItemMap :$cartItems ');
    totalproductListLength = 0;
    TotalproductList = [];
  }

  getCartInfo() async {
    var cartList = [];

    var customerId = await storage.read(key: 'cust_id');
    print('cust_id $customerId');
    var token = await storage.read(key: 'accessToken');

    var getCartItems;
    try {
      getCartItems =
          await http.get('$serverIp/api/v1/cart/?id=$customerId', headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Connection Error');
      return -1;
      //print(e);
    }

    if (getCartItems.statusCode == 401) //expired
    {
      await refreshToken();
      var token = await storage.read(key: 'accessToken');
      try {
        getCartItems =
            await http.get('$serverIp/api/v1/cart/?id=$customerId', headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Connection Error');
        return -1;
      }
    }
    print(getCartItems.statusCode);
    print('Cart Api response body ${getCartItems.body}');
    var getCartItemsData = jsonDecode(getCartItems.body);
    //print(getCartItemsData[0]);
    //print(getCartItemsData.length);
    cartLocalCacheForCartPage['cartList'] = getCartItemsData;
    if (getCartItems.statusCode == 200) {
      print('In constructing lists');
      for (int i = 0; i < getCartItemsData.length; i++) {
        var prodId = getCartItemsData[i]['product_id'];
        int quantity = getCartItemsData[i]['quantity'];
        var cartId = getCartItemsData[i]['cart_id'];
        var vendorId = getCartItemsData[i]['vendor_id'];

        //print('$quantity $productcost ${quantity.runtimeType} ${productcost.runtimeType}');

        cartList.add([prodId, quantity, cartId, vendorId]);
      }
    } else {
      print('couldnt get cartList :(');
      return -1;
    }
    print('cartList in categories page $cartList');
    return cartList;
  }

  @override
  void initState() {
    super.initState();
    loadProductItems();
    print('shop Name in products $name');
//    cust_id = await storage.read(key: 'cust_id');
    //ordersListCards = Text('Loading . . . ');
    //orderList = [];
  }

  Widget buildProductItems(productList) {
//    setState(() {
//      isLoading = false;
//    });
//    print('productList  $productList');
//    print('Building Cardsdsd ${productList[1][3]}');
    //productList.add([
    //          productName,
    //          image,
    //          hasVariety,
    //          variant,
    //          quantityType,
    //           details,
    //           cartInfo
    //        ]);

    return (GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: productList.length,
        padding: EdgeInsets.fromLTRB(
            SizeConfig.blockSizeHorizontal * 5,
            SizeConfig.blockSizeVertical * 3,
            SizeConfig.blockSizeHorizontal * 8,
            0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: SizeConfig.blockSizeVertical * 3,
          mainAxisSpacing: SizeConfig.blockSizeVertical * 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          print(productList[index][0]);
          print(productList[index][0].runtimeType);
          var image;
          try {
            image = productList[index][1][0];
          } catch (e) {
            image = "";
          }

          return GestureDetector(
            child: CategoryDescription(
              vendorId: vendorId,
              hasVariety: productList[index][2],
              variant: productList[index][3],
              productName: productList[index][0],
              cartInfo: productList[index][6],
              image: image,
              index: index,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          hasVariety: productList[index][2],
                          variant: productList[index][3],
                          productName: productList[index][0],
                          quantityType: productList[index][4],
                          image: productList[index][1],
                          details: productList[index][5],
                          cartInfo: productList[index][6],
                          vendorId: vendorId,

//                          productId: productList[index][5],
//                          quantity: productList[index][6],
                        ))),
          );
        }));
  }

  Widget buildCategoryItems(categoryList) {
    return (ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                filterCategory(categoryList[index][0]);
              },
              child: (CategoryTab(tabDetail: categoryList[index])));
        }));
  }

  //+===============================================================================================================

  Future<void> loadProductItems() async {
//    if (eachVendorProductsLocalCache[vendorId] == null) {}

    productList = [];
    List categoryList = [];

    setState(() {
      isLoading = true;
    });
    var getCategoriesData;
    var getCategories;
    var cartList;
    if (cartLocalCache['cartList'] == null) {
      cartList = await getCartInfo();
      if (cartList == -1) {
        return;
      }
      print("\n\n\ncartList while assigning to localcache $cartList");
      cartLocalCache['cartList'] = cartList;
    } else {
      cartList = cartLocalCache['cartList'];
    }
    if (productsLocalCache['products'] == null) {
      print('cartList in productsBuilding function $cartList');
      var token = await storage.read(key: 'accessToken');
      try {
        getCategories = await http
            .get('$serverIp/api/v1/products/?vendor_id=$vendorId', headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
//      getProducts = await http.get('$serverIp/api/v1/products/', headers: {
//        'Content-Type': 'application/json',
//        'Accept': 'application/json',
//        //'Authorization': 'Bearer $token'
//      });
      } catch (e) {
        Fluttertoast.showToast(msg: 'Connection Error');
        return;
        //print(e);
      }

      //print(getCategories.statusCode);
      print('Products Response ${getCategories.body}\n\n');
//    print(getCartItemsData[0]);
//    print(getCartItemsData.length);
      print(vendorId);
      if (getCategories.statusCode == 401) //expired
      {
        //refresh token
        print('Trying to get refresh access token');
        await refreshToken();
        var token = await storage.read(key: 'accessToken');
        try {
          getCategories = await http
              .get('$serverIp/api/v1/products/?vendor_id=$vendorId', headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
        } catch (e) {
          Fluttertoast.showToast(msg: 'Connection Error');
          return;
        }

//      getProducts = await http.get('$serverIp/api/v1/products/', headers: {
//        'Content-Type': 'application/json',
//        'Accept': 'application/json',
//        //'Authorization': 'Bearer $token'
//      });
      }

      getCategoriesData = jsonDecode(getCategories.body);
      print('Json Decode : ${getCategoriesData.length} \n');
      productsLocalCache['products'] = getCategoriesData;
    } else {
      getCategoriesData = productsLocalCache['products'];
    }
    //var getProductsData = jsonDecode(getProducts);
//cartList[prodId, quantity, cartId,vendor_id]
    int cartListLen = cartList.length;
    int cartprodId = 0;
    int cartquantity = 0;
    int cartId = 0;
    int cartvendorId = 0;
    bool isProdListAvailable = false;
    try {
      if (getCategories.statusCode == 200) {
        isProdListAvailable = true;
      }
    } catch (e) {
      if (productsLocalCache['products'] != null) {
        isProdListAvailable = true;
      }
    }
    print("Prod data ${getCategoriesData[0]}");
    if (isProdListAvailable && getCategoriesData[0] != null) {
      for (int i = 0; i < getCategoriesData.length; i++) {
        print('Adding products to list');
        var productName = getCategoriesData[i]['name'];
        var images = getCategoriesData[i]['image_url'];
        var category = getCategoriesData[i]['category'];
        var variant = getCategoriesData[i]['variant_details'];
//        var quantityType = getCategoriesData[i]['quantity_type'];
        var quantityType = "";
        var details = getCategoriesData[i]['details'];
        var prodId = variant[0]['p_id'];
        var cartInfo = [];
        //print(prodId);
        print('images: $images');

//        var productId = getCategoriesData[i]['product_id'];
//        var quantity = getCategoriesData[i]['quantity'];
        print('\n\n ${variant[0]['variant']} \n\n');
        // print('\n\n ${variant[1]['variant']} \n\n');

        bool hasVariety = false;
        if (variant.length > 1) {
          hasVariety = true;
        }

        if (!hasVariety) {
          localCartItemsIndexInProductsPage[prodId] = i;
          for (int j = 0; j < cartListLen; j++) {
            cartprodId = cartList[j][0];
            cartquantity = cartList[j][1];
            cartId = cartList[j][2];
            cartvendorId = cartList[j][3];
            print('cartVendorId $vendorId');
            if (prodId == cartprodId && cartvendorId == vendorId) {
              //this prod exists in cart
              cartInfo.add(cartquantity);
              cartInfo.add(cartId);
              break;
            }
          }
        } else {
          print('cartList $cartList');
          cartInfo = cartList;
          print('cartInfo in categorie: $cartInfo');
        }

        //print('$quantity $productcost ${quantity.runtimeType} ${productcost.runtimeType}');

        productList.add([
          productName,
          images,
          hasVariety,
          variant,
          quantityType,
          details,
          cartInfo,
          category
        ]);
      }
    }
    if (getCategoriesData[0] == null) {
      productsLocalCache.remove('products');
    }
    int len = 0;
    categoryList.add(['All', '']);
    productList.forEach((element) {
      len += 1;
      var tempLi = categoryList.map((cat) {
        return cat[0];
      }).toList();
      if (!tempLi.contains(element[7])) {
        print(element[7]);
        var image;
        try {
          image = element[1][0];
        } catch (e) {
          image = [];
        }
        categoryList.add([element[7], image]);
//        categoryList.add(element[1][0]);
      }
    });
    totalproductListLength = len;
    TotalproductList = productList;
    activeProdList = productList;
    print('category List $categoryList');
    setState(() {
      isLoading = false;
      categoryItems = buildCategoryItems(categoryList);
      productItems = buildProductItems(productList);
//      eachVendorProductsLocalCache[vendorId] = [categoryList, productList];
      print('Set IsLoading false');
    });
  }

  getSuggestion(pattern) {
    List suggest = new List();
    if (pattern != "") {
      activeProdList.forEach((element) {
        if (element[0].toLowerCase().contains(pattern.toLowerCase())) {
          print(element[7]);
          suggest.add(element[0]);
//        categoryList.add(element[1][0]);
        }
      });
    }

    print(suggest);
    return suggest;
  }

  rightIconCallback() {
//    Navigator.of(context).push(MaterialPageRoute(
//        builder: (context) => MyCartPage(
//              hasBackButton: true,
//            )));
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => MainScreen(
                  pageToDisplay: 1,
                )),
        (Route<dynamic> route) => false);
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => MainScreen(
//                  pageToDisplay: 1,
//                )));
  }

  @override
  Widget build(BuildContext context) {
    var pageSize = SizeConfig().init(context);
    var _suggestionCtrl = new SuggestionsBoxController();
    return Scaffold(
//      appBar: AppBar(
//        title: Text('The Organic World',
//            textAlign: TextAlign.center,
//            style: TextStyle(
//                fontSize: 25.0, color: Color.fromRGBO(0, 102, 102, 10))),
//        backgroundColor: Color(appBarColor),
//        elevation: 0,
//      ),
//      appBar: CustomAppBarWithoutSliver(
//        hasLeftIcon: true,
//        hasRightIcon: false,
//        leftIcon: leftIcon,
//        appBarText: "The Organic World",
//        leftIconOnPressCallbackFunction: this.leftIconCallback,
//      ),
      body: CustomPaint(
        //painter: DrawCustomAppBar(),
        child: CustomScrollView(slivers: <Widget>[
          CustomAppBar(
            appBarHeight: 24,
            widgetOnBottomAppbarHeight: 17,
            hasTextOnBottomOfAppBar: false,
            title: widget.name,
            hasLeftIcon: true,
            leftIcon: leftIcon,
            leftIconOnPressCallbackFunction: this.leftIconCallback,
            hasRightIcon: true,
            rightIcon: rightIcon,
            rightIconOnPressCallbackFunction: this.rightIconCallback,
//            widgetOnBottomAppbar: SearchField(
//                hinttext: "Search Store",
//                textFieldColor: Colors.white70,
//                iconcolor: Color(appBarColor),
//                searchPressCallback: searchPressCallback),
            widgetOnBottomAppbar: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: SizedBox(
                height: SizeConfig.blockSizeVertical * 6,
                child: TypeAheadField(
//                  hideOnEmpty: true,
                  suggestionsBoxController: _suggestionCtrl,
                  hideSuggestionsOnKeyboardHide: true,
                  hideOnLoading: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    onSubmitted: (s) {
                      searchPressCallback(s);
                    },
                    // cursorColor: Colors.black,
                    autofocus: false,

                    //decoration: InputDecoration(labelText: 'City')
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),

                      //border: OutlineInputBorder(),
                      hintText: 'Search in $categoryNameSearch',
                      //labelText: 'Search in $categoryNameSearch',
                      hasFloatingPlaceholder: true,
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await getSuggestion(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: Icon(Icons.fastfood),
                      title: Text(
                        suggestion,
                        style: TextStyle(
                          fontFamily: 'ABeeZee',
                        ),
                      ),
                      subtitle: Text(
                        'tap to search',
                        style: TextStyle(
                          fontFamily: 'ABeeZee',
                        ),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    searchPressCallback(suggestion);
                  },
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(5, 10, 10, 0),
                      height: SizeConfig.blockSizeVertical * 12,
                      child: isLoading ? loader : categoryItems),
                  isLoading
                      ? Text(
                          'Your products are on their way . .',
                          style: TextStyle(
                            fontFamily: 'ABeeZee',
                          ),
                        )
                      : productItems,
                ],
              ),
            ),
          ])),
        ]),
      ),
      //body: Text('da', style: TextStyle(color: Color(textColor))),
    );
  }
}
