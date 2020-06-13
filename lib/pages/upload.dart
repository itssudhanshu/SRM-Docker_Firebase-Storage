import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:srm_notes/components/appbar.dart';
import '../constants.dart';

class UploadPage extends StatefulWidget {

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
 bool notes = true;
  bool asTabs = false;
  String selectedValue;
  String preselectedValue = "dolor sit";
  List<int> selectedItems = [];
  final List<DropdownMenuItem> items = [];
  final String loremIpsum =
      "Lorem ipsum, do., lor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
  @override
  void initState() {
    String wordPair = "";
    loremIpsum
        .toLowerCase()
        .replaceAll(",", "")
        .replaceAll(".", "")
        .split(" ")
        .forEach((word) {
      if (wordPair.isEmpty) {
        wordPair = word + " ";
      } else {
        wordPair += word;
        if (items.indexWhere((item) {
              return (item.value == wordPair);
            }) ==
            -1) {
          items.add(DropdownMenuItem(
            child: Text(wordPair),
            value: wordPair,
          ));
        }
        wordPair = "";
      }
    });
    super.initState();
  }

  void _toggle() {
    setState(() {
      notes = true;
    });
  }

  void _toggletoque() {
    setState(() {
      notes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: ConstAppbar(title: "Upload"),
        preferredSize: Size.fromHeight(50.0),
      ),
      body: notes ? notespage() : questionpage(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.2,
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 5.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.library_books),
              backgroundColor: kPrimaryColor,
              label: 'Notes',
              // labelStyle: TextTheme(fontSize: 18.0),
              onTap: () {
                _toggle();
              }),
          SpeedDialChild(
            child: Icon(Icons.note),
            backgroundColor: kPrimaryColor,
            label: 'Qest. Paper',
            // labelStyle: TextTheme(fontSize: 18.0),
            onTap: () {
              _toggletoque();
            },
          ),
        ],
      ),
    );
  }

  Widget notespage() {
    Map<String, Widget> widgets;
    widgets = {
      "Notes": SearchableDropdown.single(
        items: items,
        value: selectedValue,
        hint: "Select Course",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        isExpanded: true,
      ),
    };
    return DefaultTabController(
      length: widgets.length,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          child: TabBarView(
            children: widgets
                .map((k, v) {
                  return (MapEntry(
                      k,
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(children: [
                          Text(k),
                          SizedBox(
                            height: 20,
                          ),
                          v,
                        ]),
                      )));
                })
                .values
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget questionpage() {
    Map<String, Widget> widgets;
    widgets = {
      "Question Paper": SearchableDropdown.single(
        items: items,
        value: selectedValue,
        hint: "Select Course",
        searchHint: "Select one",
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        isExpanded: true,
      ),
    };
    return DefaultTabController(
      length: widgets.length,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          child: TabBarView(
            children: widgets
                .map((k, v) {
                  return (MapEntry(
                      k,
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(children: [
                          Text(k),
                          SizedBox(
                            height: 20,
                          ),
                          v,
                        ]),
                      )));
                })
                .values
                .toList(),
          ),
        ),
      ),
    );
}
}