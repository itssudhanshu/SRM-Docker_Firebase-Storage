import 'package:flutter/material.dart';
import 'package:srm_notes/components/appbar.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
        child: ConstAppbar(title: "Leaderboard"),
        preferredSize: Size.fromHeight(50.0),
      ),
      body: SizedBox.expand(
        child: Text('Upload')
        ),
    );  }
}
