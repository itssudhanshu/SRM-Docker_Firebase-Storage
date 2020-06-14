import 'package:flutter/material.dart';
import 'package:srm_notes/components/appbar.dart';
import 'package:srm_notes/constants.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: new Stack(
        children: <Widget>[
          Material(
            elevation: 10.0,
            child: ClipPath(
              child: Container(color: Color(0xFF6F35A5).withOpacity(0.8)),
              clipper: getClipper(),
            ),
          ),
          Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                Container(
                    width: 130.0,
                    height: 130.0,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 5.0, color: Colors.black)
                        ])),
                SizedBox(height: 20.0),
                Text(
                  'Sudhanshu Kushwaha',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Uploads",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "5200",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Rank",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "28.5K",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Likes",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "1300",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Details(
                        icon: Icons.email,
                        details: "ss2862@srmist.edu.in",
                      ),
                      SizedBox(height: 10),
                      Details(
                        icon: Icons.format_color_text,
                        details: "RA1711003011424",
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Card(
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Year: 1st"),
                              ),
                            ),
                            Card(
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Dept: B-tech"),
                              ),
                            ),
                            Card(
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Branch: CSE"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ), 
        ],
      ),
    );
  }
}

class Details extends StatelessWidget {
  final IconData icon;
  final String details;
  const Details({
    Key key,
    this.icon,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 70),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment,
        children: <Widget>[
          Icon(icon, color: kPrimaryColor),
          SizedBox(width: 20),
          Text(details, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),),
        ],
      ),
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2.0);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
