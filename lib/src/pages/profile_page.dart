import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery/src/widgets/authentication.dart';
import 'manageAddress_page.dart';
import 'payments_page.dart';
import 'settings_page.dart';
import '../widgets/constants.dart';
import 'myOrders_page.dart';
import '../widgets/CustomPaint.dart';
import '../widgets/customAppBar.dart';
import '../widgets/MediaQueryGetSize.dart';
import '../screens/onBoarding_screen.dart';
import '../widgets/search_file.dart';
import 'sigin_page.dart';
import 'helpPage.dart';
import 'package:http/http.dart' as http;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _filter = new TextEditingController();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('',style: TextStyle(fontFamily: 'ABeeZee',),);
  String _searchText = "";
  String appBarText = 'My Profile';
  var uname = "";
  var rightIcon = Icons.search;
  var replaceRightIcon = false;
  Widget replacedRightWidget;

  _ProfilePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  getUname() async {
    var user = await storage.read(key: 'uname');
    setState(() {
      uname = user;
    });
  }

  @override
  void initState() {
    super.initState();
    getUname();
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

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      elevation: 0.1,
      backgroundColor: Color(0xffc1ffe9),
      title: _appBarTitle,
      textTheme: TextTheme(
          title: TextStyle(
        color: Colors.black,
        fontSize: 20,
      )),
      //backgroundColor: Color(appBarColor),
      iconTheme: IconThemeData(color: Colors.black),
      actions: <Widget>[
        new IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DoubleBackToCloseApp(
      snackBar: SnackBar(
        content: Text("Press back button once again to exit the app"),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          CustomAppBar(
            rightIcon: rightIcon,
            hasLeftIcon: false,
            hasRightIcon: false,
            appBarText: "My Profile",
            rightIconIsCart: false,
            rightIconOnPressCallbackFunction: this.rightIconHandleClick,
            replaceRightIcon: replaceRightIcon,
            replacedRightWidget: replacedRightWidget,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     'Welcome $uname',
              //     style: TextStyle(
              //         color: Color(textColor),
              //         fontSize: 30,
              //         fontWeight: FontWeight.bold),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                      name==null?"":name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'ABeeZee',),
                    ),
                    Row(
                      children: [
                        Text(
                          phone==null?"":phone,
                          style: TextStyle(fontSize: 16,fontFamily: 'ABeeZee',),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(':',style: TextStyle(fontFamily: 'ABeeZee',),),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          email == null ? "" : email,
                          style: TextStyle(fontSize: 16,fontFamily: 'ABeeZee',),
                        ),
                      ],
                    )
                    ],
                  ),
                  padding: EdgeInsets.only(left: 20.0),
                  alignment: Alignment.centerLeft,
                ),
              ),
              Divider(),

              _buildCard('Manage Addresses', '3 addresses'),
              // _buildCard('Payment Methods', 'Visa **34'),
              _buildCard('My Orders', 'Already have 6 orders'),
              _buildCard('Settings', 'Notifications, password'),
              _buildCard('Help', 'Learn more'),
              _buildCard('Log Out', 'Log out of your account'),
            ]),
          )
        ],
      ),
    ));
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          style: new TextStyle(color: Colors.white,fontFamily: 'ABeeZee',),
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search, color: Colors.black),
            fillColor: Colors.white,
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.black,fontFamily: 'ABeeZee',),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('', style:TextStyle(fontFamily: 'ABeeZee',),);
        _filter.clear();
      }
    });
  }

  confirmLogOut() async {
    print('Logging out . . .');

    await storage.write(key: "refreshToken", value: '');
    await storage.write(key: "cust_id", value: '-1');
    await storage.write(key: 'selectedAddress', value: '');

    Navigator.pop(context);

//    Navigator.push(
//        context, MaterialPageRoute(builder: (context) => SignInPage()));
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SignInPage()),
        (Route<dynamic> route) => false);
    await Fluttertoast.showToast(msg: 'Successfully logged out!');
    var token = await storage.read(key: 'accessToken');
    print(token);
    try {
      var response = await http.get(
        Uri.encodeFull('$serverIp/api/v1/unregister_device/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if(response.statusCode==401){
        await refreshToken();
         token = await storage.read(key: 'accessToken');
        var response = await http.get(
          Uri.encodeFull('$serverIp/api/v1/unregister_device/'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );

      }
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print("error in registering device for notifications");
    }
    await storage.write(key: "accessToken", value: '');
  }

  logOut(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 2,
            title: Text(
              'Log out',
              style: TextStyle(fontFamily: 'ABeeZee',),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Are you sure you want to log out?',
                    style: TextStyle(fontFamily: 'ABeeZee',),
                    softWrap: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () => (
                              //Log him out
                              confirmLogOut()),
                          child: Text('Yes',style: TextStyle(fontFamily: 'ABeeZee',),),
                        ),
                        FlatButton(
                          onPressed: () => (Navigator.pop(context)),
                          child: Text('No',style: TextStyle(fontFamily: 'ABeeZee',),),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildCard(String title, String subtitle) {
    return Card(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
            title: Text(title,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'ABeeZee',
                  fontWeight: FontWeight.bold,
                )),
            // subtitle: Text(subtitle),
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Colors.black, size: 25.0),
            onTap: () {
              if (title == 'Manage Addresses') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new AddressPage()));
              } else if (title == 'Payment Methods') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new PaymentsPage()));
              } else if (title == 'My Orders') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new OrdersPage()));
              } else if (title == 'Settings') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new SettingsPage()));
              } else if (title == 'Help') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new OnBoardPage(
                              isSignedIn: true,
                            )));
              } else if (title == 'Log Out') {
                logOut(context);
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => new OnBoardPage()));
              }
            },
          ),
        ));
  }
}
