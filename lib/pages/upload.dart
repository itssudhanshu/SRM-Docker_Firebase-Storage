import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:srm_notes/components/appbar.dart';
import 'package:srm_notes/components/models/loading.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  final GlobalKey dropdownKey = GlobalKey();

  String _fileName;
  File _path;
  List<File> multifile;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = true;
  FileType _pickingType = FileType.custom;
  TextEditingController _controller = new TextEditingController();
  Color color = kPrimaryLightColor;
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
        _paths = null;
        multifile = await FilePicker.getMultiFile(
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

        for (File _file in multifile) print(_file.path.toString());
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

  Future savedoc(File file, String name) async {
    print(selectedValue);
    print(name);

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(_fileName);

    final StorageUploadTask task = firebaseStorageRef.putFile(file);
    //  firebaseStorageRef.putData(file);

    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    print("upload complete");
    _clearCachedFiles();
    String url = await taskSnapshot.ref.getDownloadURL();
    url = url.replaceAll('//', '~');
    print(url);
    var response = await Firestore.instance
        .collection(selectedValue)
        .document("${DateTime.now()}")
        .setData({
      'name': _fileName,
      'sender': loggedInUser.email,
      'url': url,
      'time': DateTime.now().toString().split('at')[0]
    });
    // setState(() {
    //   uploading = false;
    //   _clearCachedFiles();
    // });
    // documentFileUpload(url);
    return url;
  }

  void openDropdown() {
    GestureDetector detector;
    void searchForGestureDetector(BuildContext element) {
      element.visitChildElements((element) {
        if (element.widget != null && element.widget is GestureDetector) {
          detector = element.widget;
          return false;
        } else {
          searchForGestureDetector(element);
        }
        return true;
      });
    }

    searchForGestureDetector(dropdownKey.currentContext);
    assert(detector != null);
    detector.onTap();
  }

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
      // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: ConstAppbar(title: "Upload"),
        preferredSize: Size.fromHeight(50.0),
      ),
      body:
          //  uploading
          //     ? Loading()
          //     :
          Container(
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
                  SizedBox(height: size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: color),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SearchableDropdown(
                        key: dropdownKey,
                        //ese SearchableDropdown.single for suffix icon
                        underline: SizedBox(width: 20),
                        iconEnabledColor: kPrimaryColor,
                        iconDisabledColor: Colors.black,
                        items: _items.map((item) {
                          return DropdownMenuItem(
                            child: new Text(item),
                            value: item,
                          );
                        }).toList(),
                        value: selectedValue,
                        hint: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text("Select Course"),
                        ),
                        searchHint: Text("Select one"),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                            color = kPrimaryColor;
                            // width_dropd = 2.0;
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
                            builder: (BuildContext context) => GestureDetector(
                              onTap: () {
                                _openFileExplorer();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/uploaddone.png",
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: _loadingPath
                                    ? GestureDetector(
                                        onTap: () {
                                          _openFileExplorer();
                                        },
                                        // child: Container(
                                        //   decoration: BoxDecoration(
                                        //     image: DecorationImage(
                                        //       image: AssetImage(
                                        //         "assets/images/uploaddone.png",
                                        //       ),
                                        //       fit: BoxFit.contain,
                                        //     ),
                                        //   ),
                                        // ),
                                      )
                                    : multifile != null || _paths != null
                                        ? new Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.50,
                                            child: new Scrollbar(
                                              child: new ListView.builder(
                                                itemCount: multifile != null &&
                                                        multifile.isNotEmpty
                                                    ? multifile.length
                                                    : 1,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final String name =
                                                      'File $index: ' +
                                                          multifile[index]
                                                              .toString()
                                                              .split('/')
                                                              .last;
                                                  return Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        8.0, 8.0, 8.0, 0.0),
                                                    decoration: BoxDecoration(
                                                      color: kPrimaryLightColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: new ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.attachment,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      trailing: Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                      ),
                                                      title: new Text(name),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : new Container(
                                            // child: Image.asset(
                                            //   "assets/images/upload.png",
                                            //   width: size.width * 0.70,
                                            // ),
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
                              setState(() async {
                                for (File file in multifile) {
                                  // get file name
                                  _fileName = file.toString().split('/').last;

                                  if (file != null && selectedValue != null) {
                                    // uploading = true;

                                    //call uploading function
                                    await savedoc(file, _fileName);
                                  } else {
                                    setState(() {
                                      openDropdown();
                                    });
                                  }
                                }
                                // uploading = false;
                              });
                              _clearCachedFiles();
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
