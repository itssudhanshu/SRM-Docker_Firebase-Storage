import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image.asset(
                  "assets/images/signup_top.png",
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("‍‍☯"),
        centerTitle: true,
      ),
      body: Center(
          child: Text(
        'BHkhjmnbAK BS.k,hDK',
        style: TextStyle(fontSize: 50, fontStyle: FontStyle.italic),
      )),
    );
  }
}
