import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:srm_notes/components/mail.dart';
import 'package:srm_notes/constants.dart';
import 'package:srm_notes/pages/editprofile.dart';
FirebaseUser loggedInUser;

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // final AuthService _auth = AuthService().;
  final _auth = FirebaseAuth.instance;
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      endDrawer: Container(
        width: MediaQuery.of(context).size.width * 0.70,
        height: size.height*0.9,
        margin: EdgeInsets.only(top:20),
        child: Drawer(
          child: SafeArea(
            maintainBottomViewPadding: false,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 10),
                  child: ListTile(
                    title: Text(
                      "ss2862@srmist.edu.in",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Divider(thickness: 1.5),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        title: Text('Edit Profile'),
                        leading: Icon(Icons.edit),
                        onTap: () {
                           Navigator.of(context).push(
                                MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return  Edit();
                                  },
                                ),
                              );
                         
                        },
                      ),
                      ListTile(
                        title: Text('My Uploads'),
                        leading: Icon(Icons.file_upload),
                        onTap: () {},
                      ),
                      ExpansionTile(
                        leading: Icon(Icons.apps),
                        title: const Text('How to use this App?'),
                        children: <Widget>[
                          ListTile(
                              title: Text(
                                  '1.Add tasks or notes through + sign below.')),
                          ListTile(title: Text('2.Share your notes.')),
                          ListTile(title: Text('3.Mark Important notes.')),
                          ListTile(
                              title: Text(
                                  '4.Edit tasks pressing long to your previous input.')),
                          ListTile(
                              title: Text(
                                  '5.Remove tasks on sliding to block from left to right.')),
                          ListTile(
                              title: Text(
                                  '6.Differentiate your tasks by colors.')),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  // This align moves the children to the bottom
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    // This container holds all the children that will be aligned
                    // on the bottom and should not scroll with the above ListView
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Divider(thickness: 1.5),
                          ListTile(
                              title: Text('Logout'),
                              leading: Icon(Icons.exit_to_app),
                              onTap: () async {
                                await _auth.signOut();
                              }),
                          ListTile(
                            leading: Icon(Icons.help),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return new Mail();
                                  },
                                ),
                              );
                            },
                            title: Text('Help and Feedback'),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          Builder(
              builder: (context) => IconButton(
                    icon: Icon(Icons.dehaze, size: 25,),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
            ),
        ],
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/signup_top.png",
                width: size.width * 0.35,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                width: size.width * 0.25,
              ),
            ),
            Material(
              elevation: 10.0,
              child: ClipPath(
                child: Container(color: Color(0xFF6F35A5).withOpacity(0.8)),
                clipper: GetClipper(),
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
                          color: kPrimaryLightColor,
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          boxShadow: [
                            BoxShadow(blurRadius: 5.0, color: Colors.black)
                          ]
                          )
                          ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  Text(
                    'Sudhanshu Kushwaha',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      letterSpacing: 2.0,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 40),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15.0),
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
                                  height: 10.0
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
                                  height: 10.0
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
                                  height: 10.0
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
                  // SizedBox(height: MediaQuery.of(context).size.height / 35),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Details(
                          icon: Icons.email,
                          details: loggedInUser.email,
                        ),
                        SizedBox(height: 10),
                        Details(
                          icon: Icons.format_color_text,
                          details: "RA1711003011424",
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 30),
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
      ),
      // ),
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
          Text(
            details,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class GetClipper extends CustomClipper<Path> {
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
    return true;
  }
}
