import 'package:enlighten/Get_Start/WelcomeToEnlighten.dart';
import 'package:enlighten/Get_Start/WelcomeToEnlighten.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      _buildbody(),
    );
  }
}


class _buildbody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 60,top: 50),
                  child: Row(
                    children: [
                      Text(
                        'Read More With US',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: HexColor("#808080")),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  padding: EdgeInsets.only(right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                    ],
                  ),
                ),

              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top:10),
                child: Image(
                  image: AssetImage('assets/Logos/logo1.png'),
                ),
              ),
            ),
            SizedBox(height: 150),
            Container(
              decoration: BoxDecoration(
                color: HexColor('#000000'),
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
              width: 350,
              height: 55,
              child: new TextButton(
                  style:
                  TextButton.styleFrom(primary: Colors.white),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => WelcomeToEnlighten(),
                        ));
                  },
                  child: Text(
                    "Let's Explore",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(height: 50),

          ],
        ),
      ),
    );
  }
}
