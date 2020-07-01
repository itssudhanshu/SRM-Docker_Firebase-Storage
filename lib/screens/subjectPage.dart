import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srm_notes/components/models/loading.dart';
import '../constants.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class SubjectPage extends StatefulWidget {
  var sub;
  SubjectPage(this.sub);
  @override
  _SubjectPageState createState() => _SubjectPageState(this.sub);
}

class _SubjectPageState extends State<SubjectPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  var _searchedText;
  var subject;
  _SubjectPageState(this.subject);

  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;
  Size size;
  String downloadlinkurl;
  var data;
  Dio dio = Dio();
  String savePath;
  String reason;
  String regid;
  String downloadlink;

  Future report(uploader1, reason1, url, doc, sub) async {
    var response = await Firestore.instance
        .collection("Reports")
        .document(uploader1)
        .setData({
      'reason': reason1,
      'uploader': uploader1,
      'url': url,
      'doc': doc,
      'sub': sub
    });
  }

  Future<bool> reportdoc(uploader, url, doc, sub) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 200.0,
            width: 200.0,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        fillColor: kPrimaryLightColor,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 0.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(29),
                          borderSide: BorderSide(width: 2, color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(29),
                          borderSide:
                              BorderSide(width: 2, color: Colors.purple),
                        ),
                        hintText: "Reason",
                        labelText: "Reason Please...",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.report,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      validator: (val) =>
                          (val.isEmpty) ? "Please state your reason" : null,
                      onChanged: (val) {
                        setState(() => reason = val);
                      },
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      child: FlatButton(
                        color: kPrimaryColor,
                        child: Center(
                          child: Text(
                            'Report',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await report(uploader, reason, url, doc, sub);
                            setState(
                              () {
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    // duration: Duration(milliseconds: 50),
                                    backgroundColor: Colors.green,
                                    content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Reported"),
                                    ),
                                  ),
                                );
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> downloadFile(String uri, String fileName, String doc) async {
    // String savePath = await getFilePath(fileName);
    String _sub = subject.toString().replaceAll(" ", "_");

    // Directory dir = await getApplicationDocumentsDirectory();
    Directory dir = await getExternalStorageDirectory();
    // var newDir =
    //     await new Directory('${dir.path}/SRM Docker').create(recursive: true);
    var newDir = await new Directory('/storage/emulated/0/SRM Docker')
        .create(recursive: true);
    // print(_externalDocumentsDirectory.path.toString().replaceAll("Android/*", ""));
    // print(newDir);
    savePath =
        '${newDir.path}/$_sub/$doc/' + fileName.toString().replaceAll("'", "");
    String showPath =
        savePath.toString().replaceAll("/storage/emulated/0/", "");
    if (FileSystemEntity.typeSync(savePath) != FileSystemEntityType.notFound) {
      OpenFile.open(savePath);
    } else {
      setState(() {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            // duration: Duration(milliseconds: 50),
            backgroundColor: Colors.green,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'File Downloaded into your storage - $showPath',
              ),
            ),
          ),
        );
      });

      await dio.download(uri, savePath);
      OpenFile.open(savePath);
    }
  }

  Future<String> getSWData() async {
    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      downloadlinkurl = remoteConfig.getString('download_link');
      // var res = await http
      //     .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      // var resBody = json.decode(res.body);
      setState(() {
        downloadlink = downloadlinkurl;
      });
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }

    return "Sucess";
  }

  Future<void> share(value) async {
    await FlutterShare.share(
        title: 'Share',
        text:
            'See what i found in Srm Docker.\nyou can also download Srm Docker from $downloadlink',
        linkUrl: value,
        chooserTitle: 'Share your doc.');
  }

  Future<void> getFilteredList() async {}

  Widget _cardWidget(title, uploader, time, url, doc) {
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
              child: Column(children: <Widget>[
                Expanded(
                  flex: 6,
                  child: GestureDetector(
                    onTap: () async {
                      print(url);
                      await downloadFile(url, title, doc);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: url.contains("jpg") || url.contains("png")
                            ? Image.network(
                                url,
                                fit: BoxFit.cover,
                                width: size.width,
                              )
                            : url.contains("doc") || url.contains("docx")
                                ? Image.asset("assets/images/doc.png")
                                : url.contains("ppt") || url.contains("pptx")
                                    ? Image.asset("assets/images/ppt.png")
                                    : url.contains("pdf")
                                        ? Image.asset("assets/images/pdf.png")
                                        : Image.asset(
                                            "assets/images/xlsx.png")),
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
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                    child: Text(
                                      time.toString().split(' ')[0],
                                      style: TextStyle(color: Colors.grey[700]),
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
                                          reportdoc(
                                              uploader, url, doc, subject);
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
    getSWData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 5,
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
          actions: <Widget>[
            IconButton(
                icon: isSearchEmpty ? Icon(Icons.search) : Icon(Icons.cancel),
                color: isSearchEmpty ? Colors.white : Colors.white,
                onPressed: () {
                  setState(() {
                    cancelSearch();
                    this.isSearchEmpty = !this.isSearchEmpty;
                  });
                })
          ],
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
                              final mw =
                                  _cardWidget(name, uploader, time, url, doc);

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

                              final mw =
                                  _cardWidget(name, uploader, time, url, doc);
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
