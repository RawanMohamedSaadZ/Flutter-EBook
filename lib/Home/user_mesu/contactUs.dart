// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../component/account_setting_bar_container.dart';

class Contactus extends StatefulWidget {
  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  @override
  Widget build(BuildContext context) {
    var feedBack = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipPath(
                  clipper: MyClipper(), // Use a custom clipper
                  child:   Container(
                    padding: EdgeInsets.all(30),
                    height: 400,
                    width: double.infinity,
                    color: HexColor('#000000'),


                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30,),
                        Row(
                          children: [
                            Text(
                              '''Thank You For\n Contacting Us''',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(width: 15),
                            Icon(
                              Icons.mail_rounded,
                              size: 50,
                              color: Colors.white,
                            )
                          ],
                        ),
                        SizedBox(height: 15),
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


                SizedBox(height: 20),

                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '''Please Leave Your Comment\nWe Are Going To Contact You\nback Via email soon .\n\nwrite your comment here....''',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF7a7c80),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),


                      SizedBox(height: 15),

                      TextField(

                        controller: feedBack,
                        style: TextStyle(
                            color: Colors.white
                        ),
                        maxLines: null,
                        decoration: InputDecoration(
                          fillColor: Colors.black,
                          filled: true,
                          hintText: 'write your comment here....',
                          border: OutlineInputBorder(),
                        ),

                        keyboardType: TextInputType.text,
                      ),

                      SizedBox(height: 15),

                      Container(
                        height: 20,
                        width: double.infinity,
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                            onPressed: ()
                            {

                            },
                            child: Text(
                              'send',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder() ,
                              fixedSize: const Size(60,70),
                              primary: Colors.black,
                            )
                        ),
                      ),


                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      ),

    );
  }
}
