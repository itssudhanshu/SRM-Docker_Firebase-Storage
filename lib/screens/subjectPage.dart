import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:srm_notes/bloc/userbloc.dart';
import 'package:srm_notes/components/models/loading.dart';
import 'package:srm_notes/components/models/usermodel.dart';

import '../constants.dart';

const String RANDOM_URL = "https://randomuser.me/api/?results=100";

class SubjectPage extends StatefulWidget {
  var sub;
  SubjectPage(this.sub);
  @override
  _SubjectPageState createState() => _SubjectPageState(this.sub);
}

class _SubjectPageState extends State<SubjectPage> {
  var subject;
  _SubjectPageState(this.subject);

  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  ScrollController _controller = ScrollController();
  ScrollController _controller1 = ScrollController();
  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;
  Size size;
  var data;

  Future<void> getFilteredList() async {}
//  Widget usersWidget() {
//    size = MediaQuery.of(context).size;
//    return StreamBuilder(
//        stream: userBloc.userController.stream,
//        builder: (BuildContext buildContext,
//            AsyncSnapshot<List<RandomUserModel>> snapshot) {
//          if (snapshot == null) {
//            return CircularProgressIndicator();
//          }
//          return snapshot.connectionState == ConnectionState.waiting
//              ? Center(
//                  child: CircularProgressIndicator(),
//                )
//              : _randomUsers(snapshot: snapshot);
//        });
//  }

  Widget _cardWidget(title) {
    return GestureDetector(
      onTap: () {
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) {
//              return AccountPage();
//            },
//          ),
//        );
      },
      child: Container(
        height: 60,
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          // fit: StackFit.expand,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: size.width * 0.02),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Icon(Icons.folder,size: 40,color: kPrimaryColor,),
              ),
              SizedBox(width: size.width * 0.2),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

//  Widget _randomUsers({AsyncSnapshot<List<RandomUserModel>> snapshot}) {
//    return GestureDetector(
//      onPanUpdate: (details) {
//        //print(details.globalPosition.dy);
//        if (details.delta.dy > 0) {
//          if (_controller.offset < 0) {
//            _controller.jumpTo(0);
//            _controller1.jumpTo(0);
//          }
//          _controller.jumpTo(_controller.offset - details.delta.dy);
//          _controller1.jumpTo(_controller1.offset - details.delta.dy);
//        } else if (details.delta.dy < 0) {
//          // print('We are swiping down');
//          double maxScroll = _controller.position.maxScrollExtent;
//          double currentScroll = _controller.position.pixels;
//          double maxScroll1 = _controller1.position.maxScrollExtent;
//          double currentScroll1 = _controller1.position.pixels;
//
//          ///lets say that we reached 99% of the screen
//          double delta =
//              230; // or something else.. you have to do the math yourself
//          if (maxScroll - currentScroll <= delta) {
//            print('reached the end ?');
//
//            _controller.jumpTo(_controller.position.maxScrollExtent);
//          }
//          if (maxScroll1 - currentScroll1 <= delta) {
//            print('reached the end ?');
//
//            _controller1.jumpTo(_controller1.position.maxScrollExtent);
//          }
//
//          _controller.jumpTo(_controller.offset - details.delta.dy);
//          _controller1.jumpTo(_controller1.offset - details.delta.dy);
//        }
//      },
//      child: Container(
//        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//        child: Row(
//          children: <Widget>[
//            Expanded(
//              child: ListView.builder(
//                controller: _controller,
//                physics: NeverScrollableScrollPhysics(),
//                // physics: PageScrollPhysics(),
//                itemCount: snapshot.data.length,
//                itemBuilder: (BuildContext context, int index) {
//                  if (index.isEven) {
//                    return Container(
//                      height: 80,
//                      child: _cardWidget(snapshot, index),
//                    );
//                  } else {
//                    return SizedBox();
//                  }
//                },
//              ),
//            ),
//            SizedBox(width: 10),
//            Expanded(
//              child: ListView.builder(
//                controller: _controller1,
//                physics: NeverScrollableScrollPhysics(),
//                itemCount: snapshot.data.length,
//                itemBuilder: (BuildContext context, int index) {
//                  // if (index == random || index == 1) {
//                  //   return _showAd();
//                  // }
//                  if (index.isOdd) {
//                    return Container(
//                      height: 80,
//                      child: _cardWidget(snapshot, index),
//                    );
//                  } else {
//                    return SizedBox();
//                  }
//                },
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  @override
  void initState() {
    super.initState();
    fetchRandomUsers();
    _controller.addListener(() {
      _controller.jumpTo(_controller.offset);
    });
    _controller1.addListener(() {});
  }

  void _searchUser(String searchQuery) {
    List<RandomUserModel> searchResult = [];
    userBloc.userController.sink.add(null);
    print('total users = ${totalUsers.length}'); //
    if (searchQuery.isEmpty) {
      userBloc.userController.sink.add(totalUsers);
      return;
    }
    totalUsers.forEach((user) {
      if (user.first.toLowerCase().contains(searchQuery.toLowerCase()) ||
          user.last.toLowerCase().contains(searchQuery.toLowerCase())) {
        searchResult.add(user);
      }
    });
    print('searched users length = ${searchResult.length}'); //
    userBloc.userController.sink.add(searchResult);
  }

  Future<void> fetchRandomUsers() async {
    http.Response response = await http.get(RANDOM_URL);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final Iterable list = body["results"];
      // map each json object to model and addto list and return the list of models
      totalUsers =
          list.map((model) => RandomUserModel.fromJson(model)).toList();
      userBloc.userController.sink.add(totalUsers);
    }
  }

  int random;
  List<RandomUserModel> totalUsers = [];
  Random rng = Random();
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: isSearchEmpty
            ? Text("Home", style: TextStyle(color: Colors.white))
            : TextField(
          controller: searchController,
          onChanged: (text) => {_searchUser(text), handleSearch(text)},
          // autofocus: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration.collapsed(
            hintText: 'Search',
            hintStyle: TextStyle(
                color: Colors.white
            ),
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
                this.isSearchEmpty = !this.isSearchEmpty;
              });
            })
            : null,
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
            Container(
              // extendBodyBehindAppBar: true,

              child: Column(
                // onChanged: (text) => _searchUser(text),
                children: <Widget>[
                  // SizedBox(height: 20),
                  // Container(
                  // child: Container(
                  //   alignment: Alignment.center,
                  //   margin: EdgeInsets.all(8),
                  //   // padding: EdgeInsets.all(16),
                  //   height: 50.0,
                  //   decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.black45),
                  //       borderRadius: BorderRadius.all(Radius.circular(16))),
                  // child: Row(
                  //   // mainAxisAlignment: MainAxisAlignment.center,
                  //   // crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: <Widget>[
                  //     SizedBox(width: 10.0),
                  //     Expanded(
                  //       child: TextField(
                  //         controller: searchController,
                  //         onChanged: (text) =>
                  //             {_searchUser(text), handleSearch(text)},
                  //         autofocus: false,
                  //         keyboardType: TextInputType.text,
                  //         textInputAction: TextInputAction.search,
                  //         decoration: InputDecoration.collapsed(
                  //           hintText: 'Search',
                  //           border: InputBorder.none,
                  //         ),
                  //       ),
                  //     ),
                  //     IconButton(
                  //       icon: Icon(
                  //         isSearchEmpty ? Icons.search : Icons.cancel,
                  //       ),
                  //       onPressed: cancelSearch,
                  //     ),
                  //   ],
                  // ),
                  // ),
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: TextField(
                  //     decoration: InputDecoration(
                  //         suffixIcon: Icon(Icons.search),

                  //         hintText: 'Search',
                  //         contentPadding:
                  //             EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  //         border: OutlineInputBorder(
                  //             borderSide: BorderSide(width: 3.1, color: Colors.red),
                  //             borderRadius: BorderRadius.circular(30)
                  //             )
                  //             ),
                  //   ),

                  // ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _fireStore.collection(subject).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.data == null) {
                        return Expanded(child: Center(child: Loading()));
                      }
                      var doc = snapshot.data;
                      final messages = snapshot.data.documents.reversed;
                      List<Widget> wid = [];

                      for (var message in messages) {

                        final name = message.data['name'];
                        final code = message.data['code'];
                        final mw = _cardWidget(name);
                        wid.add(mw);
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
