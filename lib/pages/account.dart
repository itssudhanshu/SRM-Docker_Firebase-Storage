import 'package:flutter/material.dart';
import 'package:srm_notes/components/appbar.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: ConstAppbar(title: "Account"),
        preferredSize: Size.fromHeight(50.0),
      ),
      body: SizedBox.expand(child: Text('Acount')),
    );
  }
}

