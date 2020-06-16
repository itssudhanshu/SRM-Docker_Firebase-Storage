import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:srm_notes/components/models/loading.dart';

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

  Future<void> getFilteredList() async {}

  Widget _cardWidget(title,uploader,time, url) {
    url = url.toString().replaceAll('~', '//');
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
        height: 70,
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
                child: Icon(Icons.folder,size: 50,color: kPrimaryColor,),
              ),
              SizedBox(width: size.width * 0.05),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(uploader,
                          style: TextStyle(color:kPrimaryColor),),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,12,0),
                        child: Text(time.toString().split(' ')[0],
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),


                      ],
                    ),
                    SizedBox(height: 7,),
                    Container(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 17,
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
            ? Text("$subject", style: TextStyle(color: Colors.white))
            : TextField(
          style: TextStyle(color: Colors.white),
          controller: searchController,
          onChanged: (text){
            setState(() {
              _searchedText = text.toLowerCase();
            });
          },
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
            color:Colors.white,
            onPressed: () {
              setState(() {
                _searchedText = null;
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
                  _searchedText = null;
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
                        final uploader = message.data['sender'];
                        final url = message.data['url'];
                        final time = message.data['time'];
                        final mw = _cardWidget(name,uploader,time,url);

                        if(_searchedText == null || name.toLowerCase().contains(_searchedText))
                          {
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
