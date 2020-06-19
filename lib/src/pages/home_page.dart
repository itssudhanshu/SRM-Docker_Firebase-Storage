import 'dart:convert';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery/src/widgets/Loader.dart';
import 'package:food_delivery/src/widgets/authentication.dart';
import 'package:location/location.dart';
// import 'package:food_delivery/src/widgets/bought_foods.dart';
// import '../widgets/home_top_info.dart';
// import '../widgets/food_category.dart';
import '../widgets/search_file.dart';
// import 'package:polygon_clipper/polygon_clipper.dart';
import 'categories_page.dart';
// import '../widgets/customAppBar.dart';
import '../widgets/constants.dart';
// import '../widgets/CustomPaint.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../data/food_data.dart';

// Model
import '../models/food_model.dart';

var meatImage =
    'https://images.unsplash.com/photo-1532597311687-5c2dc87fff52?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80';
var foodImage =
    'https://images.unsplash.com/photo-1520218508822-998633d997e6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80';

var burgerImage =
    'https://images.unsplash.com/photo-1534790566855-4cb788d389ec?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80';
var chickenImage =
    'https://images.unsplash.com/photo-1532550907401-a500c9a57435?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80';

// COLORS
var textYellow = Color(0xFFf6c24d);
var iconYellow = Color(0xFFf4bf47);

var green = Color(0xFF4caf6a);
var greenLight = Color(0xFFd8ebde);

var red = Color(0xFFf36169);
var redLight = Color(0xFFf2dcdf);

var blue = Color(0xFF398bcf);
var blueLight = Color(0xFFc1dbee);

List details = [];
bool load = true;
List details1 = [];
List suggestions = [];

class HomePage extends StatefulWidget {
  // final FoodModel foodModel;

  // HomePage(this.foodModel);
  @override
  _HomePageState createState() => _HomePageState();
}

Widget _flexibleSpace(BuildContext context, Function fetch) {
  return details1.length != 0
      ? FlexibleSpaceBar(
          background: Container(
            child: Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    fetch();
                    showSearch(context: context, delegate: DataSearch());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 100.0),
                    child: Container(
                      height: 42,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 8),
                            child: Icon(
                              Icons.search,
                              size: 35,
                              color: Colors.greenAccent,
                            ),
                          ),
                          Text(
                            'Search Store',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                fontFamily: 'ABeeZee'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        )
      : Container();
}

class DataSearch extends SearchDelegate<String> {
  postSearch(String search) async {
    final url = "$serverIp/api/v1/search_history/";
    var token = await storage.read(key: 'accessToken');

    final response = await http.post(url, headers: {
      // "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    }, body: {
      "search_value": search,
    });
    final responseBody = json.decode(response.body);
    print(responseBody);
    var response2 = await http.get(url);
    suggestions = json.decode(response2.body);
  }

  @override
  String get searchFieldLabel => 'Search for Vendors';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Color(appBarColor),
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = null,
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text("Press back button once again to exit the app"),
          ),
          child: ListView.builder(
              itemCount: details.length,
              itemBuilder: (BuildContext context, int index) {
                // var productid = details[index]["ven"][0]["p_id"];
                // var image = details[index]["retailer_name"];
                String name = details[index]["retailer_name"];
                print('shop Name $name');
                return name.startsWith(query) || name.contains(query)
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                        vendorId: details[index]['id'],
                                        name: details[index]["retailer_name"],
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: Card(
                            color: Color(16646140),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 0,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '$name',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    : Container();
              }),
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: query.isEmpty
          ? ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                // var productid = details[index]["ven"][0]["p_id"];
                // var image = details[index]["retailer_name"];
                var name = suggestions[index];
                return GestureDetector(
                    onTap: () {
                      query = name;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Card(
                        elevation: 2,
                        // color: Color(14740698),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        // elevation: 0,
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.search,
                                color: Colors.green[900],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '$name',
                                style: TextStyle(
                                    fontSize: 20.0, fontFamily: 'ABeeZee'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              },
            )
          : ListView.builder(
              itemCount: details.length,
              itemBuilder: (BuildContext context, int index) {
                // var productid = details[index]["ven"][0]["p_id"];
                // var image = details[index]["retailer_name"];
                String name = details[index]["retailer_name"];
                return name.toLowerCase().contains(query.toLowerCase())
                    ? GestureDetector(
                        onTap: () {
                          int counter = 0;
                          suggestions.forEach((element) {
                            if (element == name) {
                              counter++;
                            }
                          });
                          if (counter == 0) {
                            postSearch(name);
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                        vendorId: details[index]['id'],
                                        name: details[index]["retailer_name"],
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 0,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.search,
                                    color: Colors.green[900],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '$name',
                                    style: TextStyle(
                                        fontSize: 20.0, fontFamily: 'ABeeZee'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    : Container();
              },
            ),
    );
  }
}

String sortText;
String sortOrder;
String filterText;

RangeValues ratingValues = RangeValues(0, 5);
RangeLabels ratingLabels = RangeLabels('0', '5');

RangeValues distanceValues = RangeValues(0, 100000);
RangeLabels distanceLabels = RangeLabels('0 km', '100000 km');
List filteredDetails = details;

class _HomePageState extends State<HomePage> {
  List<Food> _foods = foods;
  var textColor = 0xff006c00;
  static var appColor = 0xffc1ffe9;
  Widget widgetOnBottomAppBar = SearchField(
    hinttext: "Search Shops",
    textFieldColor: Colors.white70,
    iconcolor: Color(appColor),
  );

  setProfileData() async {
    var token = await storage.read(key: 'accessToken');

    var response = await http.get('$serverIp/api/v1/profile/', headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 401) //expired
    {
      //refresh token
      await refreshToken();
      var token = await storage.read(key: 'accessToken');

      response = await http.get('$serverIp/api/v1/profile/', headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      });
    }
    var body = json.decode(response.body);
    print(body);
    name = body['name'];
    phone = body['phone'];
    email = body['email'];
  }

  fetchAndSetVendors() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData _locationData = await location.getLocation();
    final lat = _locationData.latitude;
    final log = _locationData.longitude;
    print("lat : $lat , long = $log");
    var token = await storage.read(key: 'accessToken');
    final url = "$serverIp/api/v1/vendors/?lat=$lat&lon=$log";
    final url2 = "$serverIp/api/v1/search_history/";
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    final response2 = await http.get(
      url2,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    final responseBody = json.decode(response.body);
    final responseBody2 = json.decode(response2.body);
    print(token);
    print(responseBody);
    setState(() {
      details = responseBody;
      suggestions = responseBody2;
    });
    print('hi');
    print('details $details');
    print(details.length);
    for (int index = 0; index < details.length; index++) {
      if (double.parse(details[index]['rating'].toString()) >=
              ratingValues.start &&
          double.parse(details[index]['rating'].toString()) <=
              ratingValues.end &&
          double.parse(details[index]['approximate_distance'].split(" ")[0]) <=
              distanceValues.end &&
          double.parse(details[index]['approximate_distance'].split(" ")[0]) >=
              distanceValues.start)
        setState(() {
          details1.add(details[index]);
        });
    }
    setState(() {
      load = false;
    });
    print(details1.length);
  }

  Timer timer;
  @override
  void initState() {
    // widget.foodModel.fetchFoods();
    fetchAndSetVendors();
    setProfileData();
    //  timer = new Timer.periodic(
    //     Duration(seconds: 2),
    //     (Timer t) => setState(() {
    //           fetchAndSetVendors();
    //         }));
    super.initState();
    Timer(Duration(milliseconds: 20), () async {
      if (freshLogin == true) {
        freshLogin = false;
        // _showToast(context);
        var username = await storage.read(key: 'uname');
        var endPoint = '$serverIp/api/v1/register/?user=$username';
        print(endPoint);
        var custId = await http.get('$endPoint');
        var custIdData = jsonDecode(custId.body);
        var userId = custIdData['user_id'];
        print('cust_id in homepage $userId');
        var prevCustId = await storage.read(key: 'prevCustId');
        if (prevCustId == null) {
          //creating first time
          storage.write(key: 'prevCustId', value: '$userId');
        } else {
          if (prevCustId != custIdData['user_id']) {
            await storage.write(key: 'pendingOrders', value: '0');
            await storage.write(key: 'pendingCancelled', value: '0');
            storage.write(key: 'prevCustId', value: '$userId');
          }
        }
        storage.write(key: 'cust_id', value: "${custIdData['user_id']}");
      }
    });
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Successfully Logged In !'),
        action: SnackBarAction(
            label: 'Hide', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  sortList() {
    if (sortText == 'Rating') {
      setState(() {
        details.sort((a, b) => b['rating'].compareTo(a['rating']));
        // details = details.;
      });
    } else if (sortText == 'Distance') {
      if (sortOrder == 'Ascending') {
        setState(() {
          details.sort((a, b) {
            var aTemp = a['approximate_distance'].split(" ");
            var bTemp = b['approximate_distance'].split(" ");
            var aFinal = aTemp[0];
            var bFinal = bTemp[0];
            print(aFinal);
            print(bFinal);
            return aFinal.compareTo(bFinal);
          });
          // details = details.;
        });
      } else {
        setState(() {
          details.sort((b, a) {
            var aTemp = a['approximate_distance'].split(" ");
            var bTemp = b['approximate_distance'].split(" ");
            var aFinal = aTemp[0];
            var bFinal = bTemp[0];
            print(aFinal);
            print(bFinal);
            return aFinal.compareTo(bFinal);
          });
          // details = details.;
        });
      }
    } else if (sortText == 'Name') {
      if (sortOrder == "Ascending") {
        setState(() {
          details.sort((a, b) {
            return a['retailer_name']
                .toLowerCase()
                .compareTo(b['retailer_name'].toLowerCase());
          });
        });
      } else {
        setState(() {
          details.sort((b, a) {
            return a['retailer_name']
                .toLowerCase()
                .compareTo(b['retailer_name'].toLowerCase());
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('$freshLogin');

    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          shape: ContinuousRectangleBorder(
            borderRadius: new BorderRadius.vertical(
                bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width, 250.0)),
          ),
          backgroundColor: Color(appBarColor),
          title: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(
                'Kirana',
                style: TextStyle(
                    color: Colors.teal[900],
                    fontSize: 40.0,
                    fontFamily: 'ABeeZee'),
              ),
            ),
          ),
          pinned: true,
          centerTitle: true,
          expandedHeight: 170.0,
          flexibleSpace: _flexibleSpace(context, fetchAndSetVendors),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // FoodListview(),
                details1.length != 0
                    ? Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.filter_list),
                              onPressed: () {
                                showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return GestureDetector(
                                        child: Container(
                                          height: 280,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: ListView(
                                              children: [
                                                ListTile(
                                                  leading: Icon(Icons.star,
                                                      color: Colors.teal[900]),
                                                  title: Text(
                                                    'Rating ',
                                                    style: TextStyle(
                                                        fontFamily: 'ABeeZee',
                                                        color:
                                                            Colors.teal[900]),
                                                  ),
                                                ),
                                                Container(
                                                  child: RangeSlider(
                                                    activeColor:
                                                        Colors.teal[900],
                                                    values: ratingValues,
                                                    min: 0,
                                                    max: 5,
                                                    divisions: 10,
                                                    labels: ratingLabels,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        ratingValues = value;
                                                        ratingLabels =
                                                            RangeLabels(
                                                                value.start
                                                                    .toString(),
                                                                value.end
                                                                    .toString());
                                                      });
                                                    },
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: Icon(
                                                      Icons.location_on,
                                                      color: Colors.teal[900]),
                                                  title: Text(
                                                    'Distance ',
                                                    style: TextStyle(
                                                        fontFamily: 'ABeeZee',
                                                        color:
                                                            Colors.teal[900]),
                                                  ),
                                                ),
                                                Container(
                                                  child: RangeSlider(
                                                    activeColor:
                                                        Colors.teal[900],
                                                    values: distanceValues,
                                                    min: 0,
                                                    max: 100000,
                                                    divisions: 10,
                                                    labels: distanceLabels,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        distanceValues = value;
                                                        distanceLabels = RangeLabels(
                                                            '${value.start.toString()} km',
                                                            '${value.end.toString()} km');
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: RaisedButton(
                                                      color: Colors.teal[900],
                                                      child: Text(
                                                        'Apply',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'ABeeZee',
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        fetchAndSetVendors();
                                                        List newDetails;
                                                        details
                                                            .forEach((element) {
                                                          if (double.parse(element[
                                                                          'rating']
                                                                      .toString()) >=
                                                                  ratingValues
                                                                      .start &&
                                                              double.parse(
                                                                      element['rating']
                                                                          .toString()) <=
                                                                  ratingValues
                                                                      .end &&
                                                              double.parse(
                                                                      element['approximate_distance'].split(" ")[
                                                                          0]) <=
                                                                  distanceValues
                                                                      .end &&
                                                              double.parse(
                                                                      element['approximate_distance'].split(" ")[
                                                                          0]) >=
                                                                  distanceValues
                                                                      .start) {
                                                            newDetails
                                                                .add(element);
                                                          }
                                                        });
                                                        setState(() {
                                                          details = newDetails;
                                                        });
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                );
                              },
                            ),
                            Text(
                              'Filters',
                              style: TextStyle(fontFamily: 'ABeeZee'),
                            ),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      child: Container(
                                        height: 350,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: ListView(
                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.star,
                                                    color: Colors.teal[900]),
                                                title: Text(
                                                  'Rating',
                                                  style: TextStyle(
                                                      fontFamily: 'ABeeZee',
                                                      color: Colors.teal[900]),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    sortText = 'Rating';
                                                    sortOrder = 'Ascending';
                                                  });
                                                  sortList();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                trailing: Icon(
                                                    Icons.arrow_upward,
                                                    color: Colors.teal[900]),
                                                leading: Icon(Icons.location_on,
                                                    color: Colors.teal[900]),
                                                title: Text(
                                                  'Distance ',
                                                  style: TextStyle(
                                                      fontFamily: 'ABeeZee',
                                                      color: Colors.teal[900]),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    sortText = 'Distance';
                                                    sortOrder = 'Ascending';
                                                  });
                                                  sortList();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                trailing: Icon(
                                                    Icons.arrow_downward,
                                                    color: Colors.teal[900]),
                                                leading: Icon(Icons.location_on,
                                                    color: Colors.teal[900]),
                                                title: Text(
                                                  'Distance ',
                                                  style: TextStyle(
                                                      fontFamily: 'ABeeZee',
                                                      color: Colors.teal[900]),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    sortText = 'Distance';
                                                    sortOrder = 'Descending';
                                                  });
                                                  sortList();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                trailing: Icon(
                                                    Icons.arrow_upward,
                                                    color: Colors.teal[900]),
                                                leading: Icon(
                                                    Icons.sort_by_alpha,
                                                    color: Colors.teal[900]),
                                                title: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      fontFamily: 'ABeeZee',
                                                      color: Colors.teal[900]),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    sortText = 'Name';
                                                    sortOrder = 'Ascending';
                                                  });
                                                  sortList();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                trailing: Icon(
                                                    Icons.arrow_downward,
                                                    color: Colors.teal[900]),
                                                leading: Icon(
                                                    Icons.sort_by_alpha,
                                                    color: Colors.teal[900]),
                                                title: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                      fontFamily: 'ABeeZee',
                                                      color: Colors.teal[900]),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    sortText = 'Name';
                                                    sortOrder = 'Descending';
                                                  });
                                                  sortList();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.sort,
                              ),
                            ),
                            sortText == null
                                ? Text(
                                    'Sort By',
                                    style: TextStyle(
                                      fontFamily: 'ABeeZee',
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        'Sort By : $sortText',
                                        style: TextStyle(
                                          fontFamily: 'ABeeZee',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      sortOrder == 'Ascending'
                                          ? Icon(Icons.arrow_upward)
                                          : Icon(Icons.arrow_downward),
                                    ],
                                  ),
                          ],
                        ),
                      )
                    : Container(),
                MenuItemsList(),
              ],
            ),
          ),
        ])),
      ],
    ));
  }
}

class MenuItemsList extends StatelessWidget {
  const MenuItemsList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: details1.length == 0
          ? load == false
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Container(
                      child: Text(
                        'No Stores found near your locality',
                        style: TextStyle(fontFamily: 'ABeeZee', fontSize: 20),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: ChasingDots(),
                )
          : Container(
              // height: 2000,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: details.length,
                itemBuilder: (ctx, index) => double.parse(
                                details[index]['rating'].toString()) >=
                            ratingValues.start &&
                        double.parse(details[index]['rating'].toString()) <=
                            ratingValues.end &&
                        double.parse(details[index]['approximate_distance']
                                .split(" ")[0]) <=
                            distanceValues.end &&
                        double.parse(details[index]['approximate_distance']
                                .split(" ")[0]) >=
                            distanceValues.start
                    ? MenuItem(
                        name: details[index]['retailer_name'],
                        address: details[index]['address']['line1'],
                        pincode: details[index]['approximate_distance'],
                        vendorId: details[index]['id'],
                        imageUrl: details[index]['image_url'],
                        rating:
                            double.parse(details[index]['rating'].toString()),
                        phone: details[index]['phone'],
                        description: details[index]['description'],
                        isOpen: details[index]['is_open'],
                        detailedAddress: details[index]['address'],
                        ownerName: details[index]['name'],
                      )
                    : Container(),
              ),
            ),
    );
  }
}

class MenuItem extends StatelessWidget {
  String name;
  String address;
  String pincode;
  double rating;
  String imageUrl;
  int vendorId;
  Map detailedAddress;
  bool isOpen;
  String ownerName;
  String phone;
  String description;
  MenuItem({
    this.name,
    this.address,
    this.pincode,
    this.vendorId,
    this.imageUrl,
    this.rating,
    this.description,
    this.detailedAddress,
    this.isOpen,
    this.ownerName,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryPage(
                      vendorId: vendorId,
                      name: name,
                    )));
      },
      onLongPress: () {
        showModalBottomSheet(
            isDismissible: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            context: context,
            builder: (_) {
              return Wrap(
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.store),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            fontFamily: 'ABeeZee',
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: RatingBarIndicator(
                              rating: rating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 30,
                              direction: Axis.horizontal,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: imageUrl,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.network(burgerImage),
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height: 100,
                              // ),
                              Flexible(
                                // width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // alignment: Alignment.center,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(Icons.call),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              phone,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'ABeeZee'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.pink,
                                      // alignment: Alignment.center,

                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Icon(Icons.directions_car),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              pincode,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'ABeeZee'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    isOpen
                                        ? Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            color: Colors.green,
                                            elevation: 0,
                                            child: Container(
                                              // color: Colors.green,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  'OPEN',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'ABeeZee'),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            color: Colors.red,
                                            elevation: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                'CLOSED',
                                                style: TextStyle(
                                                    fontFamily: 'ABeeZee',
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 140,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.location_on),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "${detailedAddress['line1']},\n${detailedAddress['line2']},\n${detailedAddress['city']}, ${detailedAddress['pincode'].toString()},\n${detailedAddress['state']}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'ABeeZee'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                  ),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 80,
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: imageUrl,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        Image.network(burgerImage),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        fontFamily: 'ABeeZee',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  // Flexible(flex: 1,),
                  // Expanded(),
                  Container(
                      // width: 200.0,
                      child: Text(
                    address,
                    style: TextStyle(
                        color: Colors.grey[400], fontFamily: 'ABeeZee'),
                  )),

                  Row(
                    children: [
                      Container(
                          child: Text(
                        '$pincode away',
                        style: TextStyle(
                          fontFamily: 'ABeeZee',
                        ),
                      )),
                      SizedBox(width: 5.0),
                      Text(
                        ' • ',
                        style: TextStyle(
                            fontFamily: 'ABeeZee',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Container(
                        child: RatingBarIndicator(
                          rating: rating,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20,
                          direction: Axis.horizontal,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodListview extends StatelessWidget {
  const FoodListview({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        height: 160.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            ItemCard(),
            ItemCard(),
            ItemCard(),
            ItemCard(),
          ],
        ),
      ),
    );
  }
}

// class MyAppBar extends StatelessWidget {
//   const MyAppBar({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Icon(
//             Icons.grid_on,
//             color: Colors.grey,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: <Widget>[
//               Text(
//                 'Location',
//                 style: TextStyle(color: Colors.black54),
//               ),
//               Text(
//                 'West bay, Qatar',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
          height: 160.0,
          width: 300.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(meatImage), fit: BoxFit.cover)),
          child: Stack(
            children: <Widget>[
              Container(
                height: 160.0,
                width: 300.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.1), Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Text(
                      '25% OFF',
                      style: TextStyle(
                          fontFamily: 'ABeeZee',
                          color: textYellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          letterSpacing: 1.1),
                    ),
                    Text(
                      'ON FIRST 3 ORDERS',
                      style: TextStyle(
                          fontFamily: 'ABeeZee',
                          color: Colors.white,
                          fontSize: 16.0,
                          letterSpacing: 1.1),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
