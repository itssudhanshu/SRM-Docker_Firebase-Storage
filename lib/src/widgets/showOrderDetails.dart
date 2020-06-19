import 'package:flutter/material.dart';
import 'package:food_delivery/src/widgets/CustomPaint.dart';
import 'package:food_delivery/src/widgets/customAppBar.dart';
import 'package:food_delivery/src/widgets/search_file.dart';

class ShowDetails extends StatefulWidget {
  var orderDetails;
  var quantity;
  ShowDetails({this.quantity, this.orderDetails});
  @override
  _ShowDetailsState createState() =>
      _ShowDetailsState(quantity: quantity, orderDetails: orderDetails);
}

class _ShowDetailsState extends State<ShowDetails> {
  var textColor = 0xff006c00;
  var appColor = 0xffc1ffe9;

  var leftIcon = Icons.keyboard_arrow_left;
  var rightIcon = Icons.search;
  var appBarText = "Add New Card";
  var replaceRightIcon = false;
  Widget replacedRightWidget;
  var orderDetails;
  var quantity;
  int index = -1;
  List<Widget> productNames = [];
  var prodQuantity = [];
  var prodPrices = [];

  _ShowDetailsState({this.quantity, this.orderDetails});

  leftIconCallback() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    productNames = orderDetails[2];
    prodQuantity = orderDetails[3];
    prodPrices = orderDetails[4];
  }

  rightIconHandleClick() {
    setState(() {
      replaceRightIcon = !replaceRightIcon;
      replacedRightWidget = SearchField(
        textFieldColor: Color(0xffc1ffe9),
        hinttext: "Search",
        iconcolor: Color(0xffc1ffe9),
      );
    });
  }

  Widget _buildChangePasswordFields(String text) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: text,
        hintStyle: TextStyle(
          fontFamily: 'ABeeZee',
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: productNames.map<Widget>((item) {
        index += 1;
        return Card(
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          elevation: 0,
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
              child: Text(prodQuantity[index],style: TextStyle(fontFamily: 'ABeeZee',),),
            ),
            title: Text('${productNames[index]} \n',style: TextStyle(fontFamily: 'ABeeZee',)),
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
      }).toList(),
    );

//        productNames.map((index)).toList(),
    // Text(
    //   '$appBarText',
    //   style: TextStyle(
    //       color: Color(0xff006c00),
    //       fontSize: 28,
    //       fontStyle: FontStyle.italic),
    // ),
    // SizedBox(
    //   height: 100,
    // ),
//            Text(
//              'Product Details',
//              style: TextStyle(fontStyle: FontStyle.italic),
//            ),
//            SizedBox(
//              height: 20,
//            ),

//            Card(
//              elevation: 5.0,
//              child: Padding(
//                  padding: EdgeInsets.all(20.0),
//                  child: Column(
//                    children: <Widget>[
//                      TextFormField(
//                        decoration: InputDecoration(
//                          hintText: "Name on Card",
//                          hintStyle: TextStyle(
//                            color: Color(0xFFBDC2CB),
//                            fontSize: 18.0,
//                          ),
//                        ),
//                      ),
////                      ListView.builder(
//////                          shrinkWrap: true,
//////                          physics: NeverScrollableScrollPhysics(),
//////                          itemCount: productNames.length,
//////                          itemBuilder: (context, index) {
//////                            return Card(
//////                              margin: new EdgeInsets.symmetric(
//////                                  horizontal: 10.0, vertical: 10.0),
//////                              elevation: 0,
//////                              child: ListTile(
//////                                contentPadding: EdgeInsets.all(1),
//////                                leading: Container(
//////                                  height: 100,
//////                                  decoration: BoxDecoration(
//////                                    shape: BoxShape.rectangle,
//////                                    color: Colors.white,
//////                                    image: DecorationImage(
//////                                        image: AssetImage('/add images here'),
//////                                        fit: BoxFit.fitWidth),
//////                                    boxShadow: [
//////                                      new BoxShadow(
//////                                        color: Colors.black38,
//////                                        offset: new Offset(0, 1.9),
//////                                        blurRadius: 2.0,
//////                                      )
//////                                    ],
//////                                  ),
////////          child: Image.asset(
////////            'assets/images/hide_and_seek.jpg',
////////            fit: BoxFit.contain,
////////          ),
//////                                  constraints: BoxConstraints(maxWidth: 70),
//////                                ),
//////                                trailing: Padding(
//////                                  padding: const EdgeInsets.all(8.0),
//////                                  child: Text(prodQuantity[index]),
//////                                ),
//////                                title: Text('${productNames[index]} \n'),
//////                                subtitle: Column(
//////                                  mainAxisSize: MainAxisSize.min,
//////                                  crossAxisAlignment: CrossAxisAlignment.start,
//////                                  children: <Widget>[
//////                                    Row(
//////                                      children: <Widget>[
//////                                        Image.asset(
//////                                          'assets/images/rupeeIcon.png',
//////                                          height: 15,
//////                                        ),
//////                                        Text(
//////                                          '${prodPrices[index]}',
//////                                          style: TextStyle(
//////                                              fontWeight: FontWeight.bold),
//////                                        )
//////                                      ],
//////                                    )
//////                                  ],
//////                                ),
//////                                isThreeLine: true,
//////                                dense: true,
//////                              ),
//////                              color: Colors.transparent,
//////                              shape: RoundedRectangleBorder(
//////                                borderRadius:
//////                                    BorderRadius.all(Radius.elliptical(10, 10)),
//////                              ),
//////                            );
//////                          })
//                    ],
//                  )),
//            ),
  }
}
