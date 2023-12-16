import 'package:enlighten/Get_Start/Login.dart';
import 'package:enlighten/Get_Start/singup.dart';
import 'package:flutter/material.dart';

class WelcomeToEnlighten extends StatefulWidget {
  @override
  _WelcomeToEnlighten createState() => _WelcomeToEnlighten();
}

class _WelcomeToEnlighten extends State<WelcomeToEnlighten> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    height: 300,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(200),
                            bottomRight: Radius.circular(200)
                        )
                    ) ,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 60,top: 40),
                          child: Text(
                            'Welcome To Enlighten Me !',
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),




                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => login(),
                                      ));
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child:Text(
                                      'LogIn',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  width: 150,
                                  height: 200,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => singup(),
                                      ));
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                      'Sign UP',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                    ),
                                  ),
                                  width: 150,
                                  height: 200,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),

                          ],

                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Image(
                            image: AssetImage('assets/Icons/idea.png'),
                            width: 150,
                            height: 150,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: 10,
                          width: 150,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

    );
  }
}
