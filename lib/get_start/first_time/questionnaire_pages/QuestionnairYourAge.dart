import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../SelectCategories.dart';
import 'QuestionnairTimeReading.dart';

class questionnairAge extends StatefulWidget {
  final catSelected;

  const questionnairAge({super.key, required this.catSelected});
  @override
  State<questionnairAge> createState() => questionnairAgeState();
}

class questionnairAgeState extends State<questionnairAge> {
  var col1 = Colors.white;
  var col2 = Colors.white;
  var col3 = Colors.white;
  var col4 = Colors.white;
  int black = 4278190080;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 80),
              Text(
                "What's Your Age?",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,

              ),
              SizedBox(height: 80,),
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
                      col4 = Colors.white;
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
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          '5 - 20 years old',
                          style: TextStyle(
                            fontSize: 18,
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
                      col4 = Colors.white;
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
                          '20 - 35 years old',
                          style: TextStyle(
                            fontSize: 18,
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
                      col4 = Colors.white;

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
                          '35 - 50 years old',
                          style: TextStyle(
                            fontSize: 18,
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
                      col3 = Colors.white;
                      col4 = Colors.black;

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
                                color: col4,
                              ),
                            )
                        ),

                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          '+ 50 years old ',
                          style: TextStyle(
                            fontSize: 18,
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
                      print(widget.catSelected);
                      if( col1.value == black ||   col2.value == black || col3.value == black || col4.value == black ){
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => Read_Most(catSelected: widget.catSelected),
                          ));
                    }else{
                        final snackBar = SnackBar(content: Text('Please select your age',style: TextStyle(color: Colors.white),),backgroundColor: HexColor('#555555'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      },
                    child: Text(
                      "Next",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],

          ),

        ),
      ),



    );

  }
}
