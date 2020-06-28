import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:srm_notes/components/models/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class SubjectPage extends StatefulWidget {
  var sub;
  SubjectPage(this.sub);
  @override
  _SubjectPageState createState() => _SubjectPageState(this.sub);
}

class _SubjectPageState extends State<SubjectPage> {
  var _searchedText;
  var subject;
  _SubjectPageState(this.subject);

  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;
  Size size;
  var data;

  String _version = 'Unknown';

  Future<void> share(value) async {
    await FlutterShare.share(
        title: 'Share',
        text: 'See what i found on DocBox ',
        linkUrl: value,
        chooserTitle: 'Share your doc.');
  }

  Future<void> getFilteredList() async {}

  Widget _cardWidget(title, uploader, time, url) {
    url = url.toString().replaceAll('~', '//');
    return GestureDetector(
      // onLongPress: () async {
      //   print(url);
      //   if (await canLaunch(url)) {
      //     await launch(url);
      //   } else {
      //     throw 'Could not launch $url';
      //   }
      // },
      // onTap: () {
      //   if (Platform.isIOS) {
      //     // Open the document for iOS, no need for permission
      //     showViewer(url);
      //   } else {
      //     // Request for permissions for android before opening document
      //     launchWithPermission(url);
      //   }
      // },
      child: Container(
        height: 200,
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: CustomPaint(
                size: Size(150, 150),
                painter: CustomCardShapePainter(
                  24,
                  kPrimaryColor,
                  kPrimaryLightColor,
                ),
              ),
            ),
            Positioned.fill(
              child: url.contains("jpg") || url.contains("png")
                  ? Column(children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: GestureDetector(
                          onLongPress: () async {
                            print(url);
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          onTap: () {
                            if (Platform.isIOS) {
                              // Open the document for iOS, no need for permission
                              showViewer(url);
                            } else {
                              // Request for permissions for android before opening document
                              launchWithPermission(url);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: size.width,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          uploader,
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 12, 0),
                                          child: Text(
                                            time.toString().split(' ')[0],
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 7),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            child: Text(
                                              title,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: IconButton(
                                              icon: Icon(Icons.report),
                                              onPressed: () {
                                                share(url);
                                              }),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: IconButton(
                                              icon: Icon(Icons.share),
                                              onPressed: () {
                                                share(url);
                                              }),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])
                  : Column(children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: GestureDetector(
                          onLongPress: () async {
                            print(url);
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          onTap: () {
                            if (Platform.isIOS) {
                              // Open the document for iOS, no need for permission
                              showViewer(url);
                            } else {
                              // Request for permissions for android before opening document
                              launchWithPermission(url);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: size.width,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          uploader,
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 12, 0),
                                          child: Text(
                                            time.toString().split(' ')[0],
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 7),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            child: Text(
                                              title,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: IconButton(
                                              icon: Icon(Icons.report),
                                              onPressed: () {
                                                share(url);
                                              }),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: IconButton(
                                              icon: Icon(Icons.share),
                                              onPressed: () {
                                                share(url);
                                              }),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  Future<void> launchWithPermission(String url) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (granted(permissions[PermissionGroup.storage])) {
      showViewer(url);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String version;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      PdftronFlutter.initialize(
          "Insert commercial license key here after purchase");
      version = await PdftronFlutter.version;
    } on PlatformException {
      version = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _version = version;
    });
  }

  void showViewer(String url) {
    // Shows how to disable functionality. Uncomment to configure your viewer with a Config object.
    //  var disabledElements = [Buttons.shareButton, Buttons.searchButton];
    //  var disabledTools = [Tools.annotationCreateLine, Tools.annotationCreateRectangle];
    //  var config = Config();
    //  config.disabledElements = disabledElements;
    //  config.disabledTools = disabledTools;
    // config.customHeaders = {'headerName': 'headerValue'};
    //  PdftronFlutter.openDocument(_document, config: config);

    // Open document without a config file which will have all functionality enabled.
    PdftronFlutter.openDocument(url);
  }

  bool granted(PermissionStatus status) {
    return status == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: isSearchEmpty
              ? Text("$subject", style: TextStyle(color: Colors.white))
              : TextField(
                  style: TextStyle(color: Colors.white),
                  controller: searchController,
                  onChanged: (text) {
                    setState(() {
                      _searchedText = text.toLowerCase();
                    });
                  },
                  // autofocus: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
        backgroundColor: kPrimaryColor,
        leading: !isSearchEmpty
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    _searchedText = null;
                    this.isSearchEmpty = !this.isSearchEmpty;
                  });
                })
         : null,

          bottom: new TabBar(
            tabs: <Widget>[
              new Tab(
                text: "Notes",
              ),
              new Tab(
                text: "Question Papers",
              ),
            ],
          ),
              ),
        

        body: new TabBarView(
          children: <Widget>[
            new Container(
              height: size.height,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/images/signup_top.png",
                      width: size.width * 0.35,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/images/main_bottom.png",
                      width: size.width * 0.25,
                    ),
                  ),
                  Container(
                    // extendBodyBehindAppBar: true,

                    child: Column(
                      // onChanged: (text) => _searchUser(text),
                      children: <Widget>[
                        StreamBuilder<QuerySnapshot>(
                          stream: _fireStore.collection(subject).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Expanded(child: Center(child: Loading()));
                            }
                            var doc = snapshot.data;
                            final messages = snapshot.data.documents.reversed;
                            List<Widget> wid = [];

                            for (var message in messages) {
                              final name = message.data['name'];
                              final uploader = message.data['sender'];
                              final url = message.data['url'];
                              final time = message.data['time'];
                              final doc = message.data['doc'];
                              final mw = _cardWidget(name, uploader, time, url);

                              if ((_searchedText == null ||
                                      name
                                          .toLowerCase()
                                          .contains(_searchedText)) &&
                                  doc == "Notes") {
                                wid.add(mw);
                              }
                            }
                            return Expanded(
                              child: ListView(
                                padding: EdgeInsets.all(10.0),
                                children: wid,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              height: size.height,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/images/signup_top.png",
                      width: size.width * 0.35,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/images/main_bottom.png",
                      width: size.width * 0.25,
                    ),
                  ),
                  Container(
                    // extendBodyBehindAppBar: true,

                    child: Column(
                      // onChanged: (text) => _searchUser(text),
                      children: <Widget>[
                        StreamBuilder<QuerySnapshot>(
                          stream: _fireStore.collection(subject).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Expanded(child: Center(child: Loading()));
                            }
                            var doc = snapshot.data;
                            final messages = snapshot.data.documents.reversed;
                            List<Widget> wid = [];

                            for (var message in messages) {
                              final name = message.data['name'];
                              final uploader = message.data['sender'];
                              final url = message.data['url'];
                              final time = message.data['time'];
                              final doc = message.data['doc'];

                              final mw = _cardWidget(name, uploader, time, url);
                              if ((_searchedText == null ||
                                      name
                                          .toLowerCase()
                                          .contains(_searchedText)) &&
                                  doc == "Question_Paper") {
                                wid.add(mw);
                              }
                            }
                            return Expanded(
                              child: ListView(
                                padding: EdgeInsets.all(10.0),
                                children: wid,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }

  void handleSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isSearchEmpty = false;
      });
    } else {
      setState(() {
        isSearchEmpty = true;
      });
    }
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
