// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers


import 'package:flutter/material.dart';

import '../../../component/account_setting_bar_container.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipPath(
            clipper: MyClipper(), // Use a custom clipper
            child:   Container(
              padding: EdgeInsets.all(30),
              height: 300,
              width: double.infinity,
              color: Colors.black,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Text(
                        'About Us',
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 15),
                      Icon(
                        Icons.info_outline_rounded,
                        size: 40,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  IconButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.keyboard_double_arrow_left,
                        size: 70,
                        color: Colors.white,
                      )
                  )
                ],
              ),
            ),
          ),


          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '''A recommendation system\n is an AI algorithm associated\n with machine learning,\n that uses Big Data\n to automatically suggest\n content for website readers\n and users.\n These systems produce\n recommendation using\n the data stored in the\n database and user behavior,\n there are two types\n of techniques recommendation\n system can use to produce\n recommendation\n these techniques are\n Collaborative filtering\n and Content filtering. ''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
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
