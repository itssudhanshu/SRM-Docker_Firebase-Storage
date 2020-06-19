import 'package:flutter/material.dart';
import '../widgets/customAppBar.dart';
import '../widgets/MediaQueryGetSize.dart';

class ProductDetailsPage extends StatefulWidget {
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            CustomAppBar(
              appBarText: 'Product details',
              // appBarName: 'Product details',
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Card(
                  //TODO: Insert image
                  ),
              Card(
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                    subtitle: Text('200g',style: TextStyle(fontFamily: 'ABeeZee',),),
                    title: Text('Rs 30',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ABeeZee',
                        )),
                  ),
                ),
              ),
              Card(
                  elevation: 0,
                  child: Container(
                    child: Text('Product description',style: TextStyle(fontFamily: 'ABeeZee',),),
                  ))
            ]))
          ],
        ),
      ),
    );
  }
}
