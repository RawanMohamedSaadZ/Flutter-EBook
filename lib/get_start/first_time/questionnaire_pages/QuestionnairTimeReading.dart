import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enlighten/Home/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../SplashScreen.dart';
import '../SelectCategories.dart';


class Read_Most extends StatefulWidget {
  final catSelected;

  const Read_Most({super.key, required this.catSelected});

  @override
  State<Read_Most> createState() => _ReadMostState();
}

class _ReadMostState extends State<Read_Most> {
  var col1 = Colors.white;
  var col2 = Colors.white;
  var col3 = Colors.white;
  int black = 4278190080;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        child: Column(
            children: [
              SizedBox(height: 60),
              Text(
                "When do you like to read most?",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,

              ),
              SizedBox(height: 100,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(21),
                ),
                width: 312,
                height: 55,
                  child:InkWell(
                    onTap: (){
                      setState(() {
                        col1 = Colors.black;
                        col2 = Colors.white;
                        col3 = Colors.white;
                      });

                    },
                    child: Row(
                      children: [
                        SizedBox(width: 20,),
                        Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.black,width: 1.5),
                              color: Colors.white,
                            ),
                            child: Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: col1,
                              ),
                            )
                          ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Morning',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              SizedBox(height: 50,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(21),
                ),
                width: 312,
                height: 55,
                child:InkWell(
                  onTap: (){
                    setState(() {
                      col1 = Colors.white;
                      col2 = Colors.black;
                      col3 = Colors.white;
                    });

                  },
                  child: Row(
                    children: [
                      SizedBox(width: 20,),
                      Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.black,width: 1.5),
                              color: Colors.white,
                            ),
                            child: Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: col2,
                              ),
                            )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          'Midday',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(21),
                ),
                width: 312,
                height: 55,
                child:InkWell(
                  onTap: (){
                    setState(() {
                      col1 = Colors.white;
                      col2 = Colors.white;
                      col3 = Colors.black;
                    });

                  },
                  child: Row(
                    children: [
                      SizedBox(width: 20,),
                      Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.black,width: 1.5),
                              color: Colors.white,
                            ),
                            child: Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: col3,
                              ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          'Evening',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(21),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(5, 10), // changes position of shadow
                    ),
                  ],
                ),
                width: 230,
                height: 55,
                child: new TextButton(
                    style:
                    TextButton.styleFrom(foregroundColor: Colors.black),
                    onPressed: () async {
                      if( col1.value == black ||   col2.value == black || col3.value == black  ){
                        await update_data();
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => Splash(),
                            ));
                      }else{
                        final snackBar = SnackBar(content: Text('Please choose an option first',style: TextStyle(color: Colors.white),),backgroundColor: HexColor('#555555'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],

          ),

      ),



    );

  }
  Future<void> update_data() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc('$uid')
        .update({
      "user preferences":widget.catSelected,
      "user state":"old"
        });
  }
}
