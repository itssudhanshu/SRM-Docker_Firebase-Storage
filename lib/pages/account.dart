import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:srm_notes/components/mail.dart';
import 'package:srm_notes/components/models/loading.dart';
import 'package:srm_notes/constants.dart';
// import 'package:srm_notes/pages/editprofile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

FirebaseUser loggedInUser;
bool _doneLoading = false;
var userName;
var uploads;
var likes;
var regId;
var profilePic;
var email;
var year;
var rank;

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _fireStore = Firestore.instance;
  final store = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;
  Timer timer;
  var storage = FlutterSecureStorage();
  File sampleImage;
  bool _uploadingImage = false;
  List<String> dept = ["B.tech.", "MBA", "Arch", "Medical"];
  List<String> branch = ["CSE", "MECH.", "SWE", "IT", "ECE", "EEE"];
  List<String> year = ["1st", "2nd", "3rd", "4th", "5th"];
  String _dept = "Dept", _branch = "Branch", _year="year";

  @override
  initState () {
    super.initState();
    checkCached();
    timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      print('timer called');
      this.getCurrentUser();
    });
  }

  Future getimagefromgallery() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    try {
      setState(() {
        sampleImage = tempImage;
        _uploadingImage = true;
      });
      var name = DateTime.now();
      final StorageReference firebaseStorageRef =
          store.ref().child(loggedInUser.email);
      final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      var url = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        profilePic = url;
      });
      url = url.replaceAll('//', '~');
      print(url);
      var response = _fireStore
          .collection('users')
          .document(loggedInUser.email)
          .updateData({'profilepic': url.toString()});
      setState(() {
        _uploadingImage = false;
      });
    } catch (e) {
      setState(() {
        _uploadingImage = false;
        displayDialog(context, 'Error', 'Some error occured.');
      });
    }
  }

  Future<void> update() async{
    setState(() {
      
    });
     var response = _fireStore
          .collection('users')
          .document(loggedInUser.email)
          .updateData({'year': _year.toString(),'branch':_branch.toString(),'dept':_dept.toString()});
  }

  Future<void> getCurrentUser() async {
    print('getCurrentUserCalled');

    try {
      final user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
        print('document');
        print(loggedInUser.toString());
        
        var document = await _fireStore
            .collection('users')
            .document(loggedInUser.email)
            .get()
            .then((value) {
          setState(() {
            userName = value.data['name'];
            uploads = value.data['uploads'];
            likes = value.data['likes'];
            regId = value.data['regno'];
            profilePic = value.data['profilepic'].toString();
            profilePic = profilePic.replaceAll('~', '//');
            _year = value.data['year'];
            _dept = value.data['dept'];
            _branch = value.data['branch'];
            rank = value.data['rank'];
            _doneLoading = true;
          });
        });
        await storage.write(key: 'rank', value: rank);
        await storage.write(key: 'profileData', value: 'true');
        await storage.write(key: 'email', value: loggedInUser.email);
        await storage.write(key: 'username', value: userName);
        await storage.write(key: 'uploads', value: uploads);
        await storage.write(key: 'likes', value: likes);
        await storage.write(key: 'regid', value: regId);
        await storage.write(key: 'profilepic', value: profilePic);
        await storage.write(key: 'year', value: _year);
        await storage.write(key: 'dept', value: _dept);
        await storage.write(key: 'branch', value: _branch);

      }
    } catch (e) {
      print(e);
    }
  }

  void checkCached() async {
    print('cache called');
    var _bool = storage.read(key: 'profileData');
    print(_bool);
    if (_bool == 'true') {
      setState(() {
        rank = storage.read(key: 'rank');
        email = storage.read(key: 'email');
        userName = storage.read(key: 'username');
        uploads = storage.read(key: 'uploads');
        likes = storage.read(key: 'likes');
        regId = storage.read(key: 'regid');
        profilePic = storage.read(key: 'profilepic');
       
        _doneLoading = true;
      });
    }
    getCurrentUser();
  }

  Future<bool> showReview(
      context, List<String> dept, List<String> branch, List<String> year) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 420.0,
              width: 200.0,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Stack(
                    // alignment: Alignment.center,
                    children: <Widget>[
                      Container(height: 150.0),
                      Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          color: kPrimaryColor,
                        ),
                      ),
                      Positioned(
                        top: 40.0,
                        left: 94.0,
                        child: profilePic == null || profilePic == 'null'
                            ? Container(
                                child: Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.white,
                                ),
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                    color: kPrimaryLightColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(75.0)),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5.0, color: Colors.black)
                                    ]))
                            : Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                    color: kPrimaryLightColor,
                                    image: DecorationImage(
                                        image: NetworkImage(profilePic),
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(75.0)),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5.0, color: Colors.black)
                                    ])),
                      ),
                      Positioned(
                        top: 100.0,
                        left: 170.0,
                        child: GestureDetector(
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: kPrimaryColor.withOpacity(0.5),
                          ),
                          onTap: getimagefromgallery,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: kPrimaryLightColor,
                            ),
                          ),
                          child: DropdownButton<String>(
                            underline: SizedBox(width: 20),
                            isExpanded: true,
                            items: dept.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            hint: Text(_dept != null ? _dept : "Select Dept"),
                            onChanged: (value) {
                              _dept = value;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: kPrimaryLightColor,
                            ),
                          ),
                          child: DropdownButton<String>(
                            underline: SizedBox(width: 20),
                            isExpanded: true,
                            hint: Text(_branch != null ? _branch : "Select Branch"),
                            items: branch.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _branch = value;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: kPrimaryLightColor,
                            ),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: SizedBox(width: 20),
                            hint: Text(_year != null ? _year : "Select Year"),
                            items: year.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _year = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    child: FlatButton(
                      color: kPrimaryColor,
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          update();
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _doneLoading
        ? ModalProgressHUD(
            inAsyncCall: _uploadingImage,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              endDrawer: Container(
                width: MediaQuery.of(context).size.width * 0.70,
                height: size.height * 0.9,
                margin: EdgeInsets.only(top: 20),
                child: Drawer(
                  child: SafeArea(
                    maintainBottomViewPadding: false,
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 10),
                          child: ListTile(
                            title: Text(
                              "$userName",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Divider(thickness: 1.5),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              ListTile(
                                title: Text('Edit Profile'),
                                leading: Icon(Icons.edit),
                                onTap: () {
                                  showReview(context, dept, branch, year);
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute<Null>(
                                  //     builder: (BuildContext context) {
                                  //       return Edit();
                                  //     },
                                  //   ),
                                  // );
                                },
                              ),
                              ListTile(
                                title: Text('My Uploads'),
                                leading: Icon(Icons.file_upload),
                                onTap: () {},
                              ),
                              ExpansionTile(
                                leading: Icon(Icons.apps),
                                title: const Text('How to use this App?'),
                                children: <Widget>[
                                  ListTile(
                                      title: Text(
                                          '1.Add tasks or notes through + sign below.')),
                                  ListTile(title: Text('2.Share your notes.')),
                                  ListTile(
                                      title: Text('3.Mark Important notes.')),
                                  ListTile(
                                      title: Text(
                                          '4.Edit tasks pressing long to your previous input.')),
                                  ListTile(
                                      title: Text(
                                          '5.Remove tasks on sliding to block from left to right.')),
                                  ListTile(
                                      title: Text(
                                          '6.Differentiate your tasks by colors.')),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // This align moves the children to the bottom
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            // This container holds all the children that will be aligned
                            // on the bottom and should not scroll with the above ListView
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Divider(thickness: 1.5),
                                  ListTile(
                                      title: Text('Logout'),
                                      leading: Icon(Icons.exit_to_app),
                                      onTap: () async {
                                        await _auth.signOut();
                                        await storage.write(
                                            key: 'isLogged', value: 'false');
                                        await storage.write(
                                            key: 'profileData', value: 'false');
                                      }),
                                  ListTile(
                                    leading: Icon(Icons.help),
                                    onTap: () async {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            return new Mail();
                                          },
                                        ),
                                      );
                                    },
                                    title: Text('Help and Feedback'),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              appBar: AppBar(
                actions: <Widget>[
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        Icons.dehaze,
                        size: 25,
                      ),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    ),
                  ),
                ],
                centerTitle: true,
                elevation: 0,
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                backgroundColor: Colors.transparent,
              ),
              body: Container(
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
                    Material(
                      elevation: 10.0,
                      child: ClipPath(
                        child: Container(
                            color: Color(0xFF6F35A5).withOpacity(0.8)),
                        clipper: GetClipper(),
                      ),
                    ),
                    Positioned(
                      width: 350.0,
                      top: MediaQuery.of(context).size.height / 5,
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Positioned(
                                child: profilePic == null ||
                                        profilePic == 'null'
                                    ? Container(
                                        child: Icon(
                                          Icons.person,
                                          size: 70,
                                          color: Colors.white,
                                        ),
                                        width: 130.0,
                                        height: 130.0,
                                        decoration: BoxDecoration(
                                            color: kPrimaryLightColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(75.0)),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 5.0,
                                                  color: Colors.black)
                                            ]))
                                    : Container(
                                        width: 130.0,
                                        height: 130.0,
                                        decoration: BoxDecoration(
                                            color: kPrimaryLightColor,
                                            image: DecorationImage(
                                                image: NetworkImage(profilePic),
                                                fit: BoxFit.cover),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(75.0)),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 5.0,
                                                  color: Colors.black)
                                            ])),
                              ),
                              Positioned(
                                right: 5,
                                bottom: 1,
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Colors.white70,
                                  ),
                                  onTap: getimagefromgallery,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 25),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              letterSpacing: 2.0,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 40),
                          Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 65.0, vertical: 5.0),
                            clipBehavior: Clip.antiAlias,
                            color: Colors.white,
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 15.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Uploads",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          '$uploads',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Rank",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          "$rank",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
//                                  Expanded(
//                                    child: Column(
//                                      children: <Widget>[
//                                        Text(
//                                          "Likes",
//                                          style: TextStyle(
//                                            color: Colors.black,
//                                            fontSize: 22.0,
//                                            // fontWeight: FontWeight.bold,
//                                          ),
//                                        ),
//                                        SizedBox(height: 10.0),
//                                        Text(
//                                          "$likes",
//                                          style: TextStyle(
//                                            fontSize: 20.0,
//                                            color: kPrimaryColor,
//                                            fontWeight: FontWeight.bold,
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(height: MediaQuery.of(context).size.height / 35),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Details(
                                  icon: Icons.email,
                                  details: loggedInUser.email,
                                ),
                                SizedBox(height: 10),
                                Details(
                                  icon: Icons.format_color_text,
                                  details: "$regId",
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        30),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          showReview(
                                              context, dept, branch, year);
                                        },
                                        child: Card(
                                          clipBehavior: Clip.antiAlias,
                                          color: Colors.white,
                                          elevation: 5.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text("Year: $_year"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.white,
                                        elevation: 5.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text("Dept: $_dept"),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.white,
                                        elevation: 5.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text("Branch: $_branch"),
                                            ],
                                          ),
                                        ),
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
                  ],
                ),
              ),
              // ),
            ),
          )
        : Loading();
  }
}

class Details extends StatelessWidget {
  final IconData icon;
  final String details;
  const Details({
    Key key,
    this.icon,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 70),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment,
        children: <Widget>[
          Icon(icon, color: kPrimaryColor),
          SizedBox(width: 20),
          Text(
            details,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2.0);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
