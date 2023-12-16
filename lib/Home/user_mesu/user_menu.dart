import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Get_Start/WelcomeToEnlighten.dart';
import '../HomePage.dart';
import 'aboutUs.dart';
import 'account_setting.dart';
import 'books_history.dart';
import 'collections/collections_home.dart';
import 'contactUs.dart';
import 'favorite_books.dart';

var Snapshot;
var FirstName;
var LastName;
var Email;
var ImgUrl;

class user_menu extends StatefulWidget {
  final user_preferences;
  const user_menu({Key? key, required this.user_preferences}) : super(key: key);

  @override
  State<user_menu> createState() => _user_menuState();
}

class _user_menuState extends State<user_menu> {
  var uid = FirebaseAuth.instance.currentUser!.uid;

  void initState() {
    _getdata();

  }

  FirebaseAuth instance = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 40,
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: HexColor("#D3D3D3"),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ImgUrl != null
                ? Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: CircleAvatar(
                            backgroundColor: HexColor('#999999'),
                            radius: 45.0,
                            child: ClipOval(
                              child: Image.network(
                                "$ImgUrl",
                                width: 75,
                                height: 75,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: HexColor('#000000'),
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("$FirstName $LastName"),
                            Text("$Email")
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(right: 15),
                          child: CircleAvatar(
                            backgroundColor: HexColor("#D3D3D3"),
                            radius: 20.0,
                            child: ClipOval(
                              child: Icon(
                                Icons.notifications_none_rounded,
                                color: HexColor("#374151"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: 100,
                    width: double.infinity,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: HexColor('#000000'),
                    ))),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: HexColor("#D3D3D3"),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: InkWell(
              onTap: () async {
               if(FirstName !=null){
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => account_setting(user_preferences: widget.user_preferences,)),
                 );
               }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Icon(Icons.perm_identity_rounded,
                        color: HexColor("#374151")),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("Account setting",
                        style: TextStyle(
                          color: HexColor('##374151'),
                          fontSize: 16,
                        )),
                  ),
                  Expanded(
                    child: Icon(Icons.settings,
                        size: 20, color: HexColor("#374151")),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: HexColor("#D3D3D3"),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(user_preferences: widget.user_preferences,)),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Icon(Icons.home_outlined,
                            color: HexColor("#374151")),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Home",
                            style: TextStyle(
                              color: HexColor('#374151'),
                              fontSize: 16,
                            )),
                      ),
                      Expanded(
                        child: Icon(Icons.arrow_forward_ios_sharp,
                            size: 15, color: HexColor("#9CA3AF")),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => collections_home()),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Icon(Icons.collections_bookmark,
                            color: HexColor("#374151")),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Book Collections",
                            style: TextStyle(
                              color: HexColor('#374151'),
                              fontSize: 16,
                            )),
                      ),
                      Expanded(
                        child: Icon(Icons.arrow_forward_ios_sharp,
                            size: 15, color: HexColor("#9CA3AF")),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => books_history()),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Icon(Icons.history, color: HexColor("#374151")),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Books History",
                            style: TextStyle(
                              color: HexColor('#374151'),
                              fontSize: 16,
                            )),
                      ),
                      Expanded(
                        child: Icon(Icons.arrow_forward_ios_sharp,
                            size: 15, color: HexColor("#9CA3AF")),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => favorite_books()),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Icon(Icons.favorite_outlined,
                            color: HexColor("#374151")),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Favorite Books",
                            style: TextStyle(
                              color: HexColor('##374151'),
                              fontSize: 16,
                            )),
                      ),
                      Expanded(
                        child: Icon(Icons.arrow_forward_ios_sharp,
                            size: 15, color: HexColor("#9CA3AF")),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUs()),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Icon(Icons.device_unknown_sharp,
                            color: HexColor("#374151")),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("About us",
                            style: TextStyle(
                              color: HexColor('##374151'),
                              fontSize: 16,
                            )),
                      ),
                      Expanded(
                        child: Icon(Icons.arrow_forward_ios_sharp,
                            size: 15, color: HexColor("#9CA3AF")),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Contactus()),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Icon(Icons.call, color: HexColor("#374151")),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Contact US",
                            style: TextStyle(
                              color: HexColor('#374151'),
                              fontSize: 16,
                            )),
                      ),
                      Expanded(
                        child: Icon(Icons.arrow_forward_ios_sharp,
                            size: 15, color: HexColor("#9CA3AF")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
              color: HexColor("#BC2C2C"),
              borderRadius: BorderRadius.circular(15),
            ),
            width: 90,
            height: 35,
            child: new TextButton(
                style: TextButton.styleFrom(primary: Colors.white),
                onPressed: () async {
                  instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WelcomeToEnlighten()),
                  );
                },
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )),
          ),
        ]),
      ),
    );
  }

  _getdata() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) {
      setState(() {
        FirstName = snapshot.data.call()!['first name'];
        LastName = snapshot.data.call()!['last name'];
        Email = snapshot.data.call()!['email'];
        ImgUrl = snapshot.data.call()!['image url'];
      });
    });
  }
}
