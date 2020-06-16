import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:srm_notes/screens/subjectPage.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;
  Size size;
  var data;

  Widget _cardWidget(title,code) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SubjectPage(title);
            },
          ),
        );
      },
      child: Container(
        // height: 100,
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: kPrimaryLightColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
            // fit: StackFit.expand,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.02),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child:  Icon(
                  Icons.folder,
                  // size: 40,
                  color: kPrimaryColor,
                ),
                )
              ),
              SizedBox(height: size.height * 0.01),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(

                      title,
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      code,
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

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
                onChanged: (text) => {handleSearch(text)},
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
              child: Column(
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: _fireStore.collection('Subjects').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Icon(Icons.flight_takeoff, ///[logo]
                        size: 40,
                        );
                      }
                      var doc = snapshot.data;
                      final messages = snapshot.data.documents.reversed;
                      List<Widget> wid = [];
                      for (var message in messages) {
                        final name = message.data['name'];
                        final code = message.data['code'];
                        final mw = _cardWidget(name,code);
                        wid.add(mw);
                      }
                      return Expanded(
                          child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: (((size.height) / 2) / size.width ),
                        padding: EdgeInsets.all(10),
                        children: 
                        wid,
                      ));
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
