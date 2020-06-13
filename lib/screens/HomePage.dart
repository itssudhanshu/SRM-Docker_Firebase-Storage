import 'package:flutter/material.dart';
import 'package:srm_notes/components/appbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
        child: ConstAppbar(title: "Home"),
        preferredSize: Size.fromHeight(50.0),
      ),
      body: SizedBox.expand(
        child: Text('Home')
        ),
    );
  }
}
