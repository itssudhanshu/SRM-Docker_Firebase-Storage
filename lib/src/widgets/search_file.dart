import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  var hinttext;
  var iconcolor;
  var textFieldColor;
  var searchPressCallback;
  final TextEditingController _filter = new TextEditingController();

  SearchField(
      {this.hinttext,
      this.iconcolor,
      this.textFieldColor,
      this.searchPressCallback});

  @override
  State<StatefulWidget> createState() {
    return SearchFieldState(
        hinttext: hinttext,
        iconcolor: iconcolor,
        searchPressCallback: searchPressCallback,
        textFieldColor: textFieldColor);
  }
}

class SearchFieldState extends State<SearchField> {
  var hinttext;
  var iconcolor;
  var textFieldColor;
  var searchPressCallback;
  final TextEditingController _filter = new TextEditingController();
  SearchFieldState(
      {this.hinttext,
      this.iconcolor,
      this.textFieldColor,
      this.searchPressCallback});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filter.addListener(() {
      searchPressCallback(_filter.text);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      //elevation: 5.0,
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
      child: TextField(
        
          enableSuggestions: true,
          onChanged: (text) {},
          style: TextStyle(color: Colors.green, fontSize: 16.0,fontFamily: 'ABeeZee',),
          controller: _filter,
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            
            filled: true,
            fillColor: Colors.white,
//            contentPadding:
//                EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
            suffixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            hintText: "$hinttext",
            hintStyle: TextStyle(color: Color.fromRGBO(0, 102, 102, 10),fontFamily: 'ABeeZee',),
          )),
    );
  }
}
