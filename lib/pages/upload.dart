import 'package:flutter/material.dart';
import 'package:srm_notes/components/appbar.dart';

class UploadPage extends StatefulWidget {

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  @override
  Widget build(BuildContext context) {
    const List<int> shades = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

    return Scaffold(
      appBar: PreferredSize(
        child: ConstAppbar(title: "Upload"),
        preferredSize: Size.fromHeight(50.0),
      ),

      body: SizedBox.expand(
        child: ListView.builder(
          itemCount: shades.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 128,
              child: Card(
                child: InkWell(
                  child: Center(
                    child: Text('Item $index'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
}
}