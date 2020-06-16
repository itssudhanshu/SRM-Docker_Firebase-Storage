import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:srm_notes/components/appbar.dart';
import 'package:srm_notes/components/models/loading.dart';

import '../constants.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

FirebaseUser loggedInUser;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _fireStore = Firestore.instance;
  final store = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  String _fileName;
  File _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.custom;
  TextEditingController _controller = new TextEditingController();
  Color color = Colors.black;
  double width_dropd = 1.0;
  File image;
  bool notes = true;
  bool asTabs = false;
  String selectedValue;
  String preselectedValue = "dolor sit";
  bool uploading = false;
  List<String> _items = ['Machine Learning', 'Maths'];
  Map<String, Widget> widgets;

  @override
  void initState() {
    getCurrentUser();
    _controller.addListener(() => _extension = _controller.text);

    super.initState();
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      if (_multiPick) {
        // _path = await FilePicker.getMultiFilePath(allowedExtensions: ['pdf']),
        _path = null;
        _paths = await FilePicker.getMultiFilePath(
            type: _pickingType,
            allowedExtensions: [
              'jpg',
              'pdf',
              'doc',
              'docx',
              'xlsx',
              'png',
              'txt',
              'ppt',
              'pptx'
            ]);

        // (_extension?.isNotEmpty ?? false) ? _extension?.replaceAll(' ', '')?.split('OOOO') : null);
      } else {
        _paths = null;
        _path = await FilePicker.getFile(
            type: _pickingType,
            allowedExtensions: [
              'jpg',
              'pdf',
              'doc',
              'docx',
              'xlsx',
              'png',
              'txt',
              'ppt',
              'pptx'
            ]);
        print(_fileName);
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;

      _fileName = _path != null
          ? _path.toString().split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
    });
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future savedoc(List<int> asset, String name) async {
    print(selectedValue);
    print(name);

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(selectedValue);

    final StorageUploadTask task = firebaseStorageRef.putData(asset);

    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    url = url.replaceAll('//', '~');
    print(url);
    var response = Firestore.instance
        .collection(selectedValue)
        .document("${DateTime.now()}")
        .setData({
      'name': _fileName,
      'sender': loggedInUser.email,
      'url': url,
      'time': DateTime.now().toString().split('at')[0]
    });
    setState(() {
      uploading = false;
      _clearCachedFiles();
    });
    print(url);
    // documentFileUpload(url);
    return url;
  }
// void documentFileUpload(String str) {

//   var data = {
//     "PDF": str,
//   };
//   mainReference.child("Documents").child('pdf').set(data).then((v) {
//   });
// }
  void _clearCachedFiles() {
    setState(() => _loadingPath = true);
    FilePicker.clearTemporaryFiles().then((result) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Select new files',
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: ConstAppbar(title: "Upload"),
        preferredSize: Size.fromHeight(50.0),
      ),
      body: uploading
          ? Loading()
          : Container(
              height: size.height,
              width: double.infinity,
              child: Stack(
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
                  // notes ? notespage() : questionpage(),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 70),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: width_dropd, color: color),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SearchableDropdown(
                              ///ese [SearchableDropdown.single] for suffix icon
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Avenir',
                              ),
                              underline: "",
                              iconEnabledColor: kPrimaryColor,
                              iconDisabledColor: Colors.black,
                              items: _items.map((item) {
                                return DropdownMenuItem(
                                  child: new Text(item),
                                  value: item,
                                );
                              }).toList(),
                              value: selectedValue,
                              hint: "Select Course",
                              searchHint: "Select one",
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                  color = kPrimaryColor;
                                  width_dropd = 2.0;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: CustomRadioButton(
                            enableShape: true,
                            elevation: 5.0,
                            buttonColor: Theme.of(context).canvasColor,
                            buttonLables: [
                              "Notes",
                              "Question Paper",
                            ],
                            buttonValues: [
                              "Notes",
                              "Question_Paper",
                            ],
                            radioButtonValue: (value) => print(value),
                            selectedColor: kPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text("Tap on Image to select File❓"),
                            ),
                            Container(
                                height: size.height * 0.30,
                                child: new Builder(
                                  builder: (BuildContext context) =>
                                      GestureDetector(
                                    onTap: () {
                                      _openFileExplorer();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/images/upload.png",
                                          ),
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                      child: _loadingPath
                                          ? GestureDetector(
                                              onTap: () {
                                                _openFileExplorer();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                      "assets/images/upload.png",
                                                    ),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : _path != null || _paths != null
                                              ? new Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 30.0),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.50,
                                                  child: new Scrollbar(
                                                      child: new ListView
                                                          .separated(
                                                    itemCount: _paths != null &&
                                                            _paths.isNotEmpty
                                                        ? _paths.length
                                                        : 1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final bool isMultiPath =
                                                          _paths != null &&
                                                              _paths.isNotEmpty;
                                                      final String name =
                                                          'File $index: ' +
                                                              (isMultiPath
                                                                  ? _paths.keys
                                                                          .toList()[
                                                                      index]
                                                                  : _fileName ??
                                                                      '...');
                                                      // final path = isMultiPath
                                                      //     ? _paths.values
                                                      //         .toList()[index]
                                                      //         .toString()
                                                      //     : _path;

                                                      return
                                                          // Container(

                                                          //     child: Image.file(image, height: 300.0, width: 300.0),
                                                          // );
                                                          new ListTile(
                                                        title: new Text(
                                                          name,
                                                        ),
                                                        // subtitle: new Text(path),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            new Divider(),
                                                  )),
                                                )
                                              : new Container(
                                                  child: Image.asset(
                                                    "assets/images/upload.png",
                                                    width: size.width * 0.70,
                                                  ),
                                                ),
                                    ),
                                  ),
                                )),
                            SizedBox(height: size.height * 0.03),
                            new Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _clearCachedFiles();
                                  },
                                  child: Text(
                                    "Clear present files",
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),
                                GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    setState(() {
                                      uploading = true;
                                    });
                                    savedoc(_path.readAsBytesSync(), _fileName);
                                    // });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    width: size.width * 0.5,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(29),
                                      child: Container(
                                        color: kPrimaryColor,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Upload",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0),
                                            ),
                                            SizedBox(width: size.width * 0.02),
                                            Icon(
                                              Icons.file_upload,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
