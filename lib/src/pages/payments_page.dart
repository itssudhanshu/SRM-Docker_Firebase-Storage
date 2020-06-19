import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:food_delivery/src/pages/add_payment_page.dart';
import 'package:food_delivery/src/pages/home_page.dart';

import '../widgets/customAppBar.dart';
import '../widgets/search_file.dart';

enum SelectedPaymentMethod { COD, First, Second, Third, Fourth }

class PaymentsPage extends StatefulWidget {
  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

void _addPaymentMethodBottomSheet(BuildContext ctx) {
  showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: AddPaymentMethodPage(),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      });
}

class _PaymentsPageState extends State<PaymentsPage> {
  SelectedPaymentMethod _selectedPaymentMethod = SelectedPaymentMethod.COD;

  var textColor = 0xff006c00;

  var appColor = 0xffc1ffe9;

  var leftIcon = Icons.keyboard_backspace;

  var rightIcon = Icons.search;

  var appBarText = "Payment Methods";

  var replaceRightIcon = false;

  Widget replacedRightWidget;

  leftIconCallback() {
    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addPaymentMethodBottomSheet(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xffc1ffe9),
        foregroundColor: Color(0xff006c00),
      ),
      body: CustomPaint(
        // painter: DrawCustomAppBar(),
        child: CustomScrollView(
          slivers: <Widget>[
            CustomAppBar(
              leftIcon: leftIcon,
              rightIcon: rightIcon,
              hasLeftIcon: true,
              hasRightIcon: true,
              appBarHeight: 20,
              appBarText: "Manage Addresses",
              rightIconIsCart: false,
              leftIconOnPressCallbackFunction: this.leftIconCallback,
              rightIconOnPressCallbackFunction: this.rightIconHandleClick,
              replaceRightIcon: replaceRightIcon,
              replacedRightWidget: replacedRightWidget,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              activeColor: Color(0xff006c00),
                              value: SelectedPaymentMethod.COD,
                              groupValue: _selectedPaymentMethod,
                              onChanged: (SelectedPaymentMethod value) {
                                setState(() {
                                  _selectedPaymentMethod = value;
                                });
                              },
                            ),
                            Text(
                              'Cash On Delivery',
                              style: TextStyle(
                                fontFamily: 'ABeeZee',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xff006c00),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CreditCardWidget(
                              cardNumber: '2345678390123458',
                              expiryDate: '20/22',
                              cardHolderName: 'Amitabh Shah',
                              cvvCode: '234',
                              showBackView: false,
                              cardBgColor: Colors.blue,
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  activeColor: Color(0xff006c00),
                                  value: SelectedPaymentMethod.First,
                                  groupValue: _selectedPaymentMethod,
                                  onChanged: (SelectedPaymentMethod value) {
                                    setState(() {
                                      _selectedPaymentMethod = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Use this Payment Method',
                                  style: TextStyle(
                                    fontFamily: 'ABeeZee',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xff006c00),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CreditCardWidget(
                              cardNumber: '2345678390123458',
                              expiryDate: '20/22',
                              cardHolderName: 'Amitabh Shah',
                              cvvCode: '234',
                              showBackView: false,
                              cardBgColor: Colors.red,
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  activeColor: Color(0xff006c00),
                                  value: SelectedPaymentMethod.Second,
                                  groupValue: _selectedPaymentMethod,
                                  onChanged: (SelectedPaymentMethod value) {
                                    setState(() {
                                      _selectedPaymentMethod = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Use this Payment Method',
                                  style: TextStyle(
                                    fontFamily: 'ABeeZee',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xff006c00),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CreditCardWidget(
                              cardNumber: '4013456723456789',
                              expiryDate: '20/22',
                              cardHolderName: 'Pablo Shah',
                              cvvCode: '234',
                              showBackView: false,
                              cardBgColor: Colors.green,
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  activeColor: Color(0xff006c00),
                                  value: SelectedPaymentMethod.Third,
                                  groupValue: _selectedPaymentMethod,
                                  onChanged: (SelectedPaymentMethod value) {
                                    setState(() {
                                      _selectedPaymentMethod = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Use this Payment Method',
                                  style: TextStyle(
                                    fontFamily: 'ABeeZee',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xff006c00),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CreditCardWidget(
                              cardNumber: '4013456723456789',
                              expiryDate: '20/22',
                              cardHolderName: 'Pablo Shah',
                              cvvCode: '234',
                              showBackView: false,
                              cardBgColor: Colors.black,
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                  activeColor: Color(0xff006c00),
                                  value: SelectedPaymentMethod.Fourth,
                                  groupValue: _selectedPaymentMethod,
                                  onChanged: (SelectedPaymentMethod value) {
                                    setState(() {
                                      _selectedPaymentMethod = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Use this Payment Method',
                                  style: TextStyle(
                                    fontFamily: 'ABeeZee',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xff006c00),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
