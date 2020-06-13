import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:srm_notes/components/appbar.dart';
import 'package:srm_notes/constants.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';


class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
bool notes = true;

  void _toggle() {
    setState(() {
      notes = !notes;
    });
  }
  @override
Widget build(BuildContext context) {
return Scaffold(
   appBar: PreferredSize(
        child: ConstAppbar(title: "Home"),
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
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.library_books),
          backgroundColor: kPrimaryColor,
          label: 'Notes',
          // labelStyle: TextTheme(fontSize: 18.0),
          onTap: (){
            _toggle();
          }
        ),
        SpeedDialChild(
          child: Icon(Icons.note),
          backgroundColor: kPrimaryColor,
          label: 'Qest. Paper',
          // labelStyle: TextTheme(fontSize: 18.0),
          onTap: (){
            _toggle();
          },
        ),
      ],
    ),
);
}
Widget notespage(){
  return Container(
    child: Column(
      children: <Widget>[
        
      ],
    ),
  );
}
Widget questionpage(){
   return Container(
    child: Text("question page"),
  );
}
}