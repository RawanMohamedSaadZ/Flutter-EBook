import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enlighten/get_start/first_time/questionnaire_pages/QuestionnairYourAge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../component/loading.dart';
import '../SplashScreen.dart';



class SelectCategories extends StatefulWidget {
  final int id;
  final user_preferences;


  const SelectCategories({Key? key, required this.id, required this.user_preferences}) : super(key: key,);

  @override
  State<SelectCategories> createState() => _SelectCategoriesState();
}

class _SelectCategoriesState extends State<SelectCategories> {
  var catSelected=[];

  var catList = ['Art', 'Action', 'Comedy', 'Romance', 'Food', 'Fiction', 'Thrillers', 'Politics', 'Sport', 'crime', 'Drama', 'children'];

  FirebaseAuth instance = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.id == 0){
      print('clear');
      catSelected.clear();
    }else{
      catSelected = widget.user_preferences;
    }
    print(catSelected);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.blueGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(minHeight:MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top ),

            child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      child: Text(''
                          'What are your Favourtie Categories?',
                        style: TextStyle(fontSize: 30.0,color: Colors.white),textAlign: TextAlign.center,),
                    ),
                    SizedBox(height: 15),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,alignment: WrapAlignment.center,
                      children: List.generate(catList.length, (i) {
                        return Column(
                          children: List.generate(1, (subIndex) {
                            return catWidget(name: catList[i],imgId:i+1,id: widget.id,catSelected: catSelected,user_preferences: widget.user_preferences,);
                          }),
                        );
                      }),
                    ),
                    SizedBox(height: 25),
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
                      width: 280,
                      height: 55,
                      child: new TextButton(
                          style:
                          TextButton.styleFrom(foregroundColor: Colors.black),
                          onPressed: () async {
                            print("catSelected: $catSelected");
                            if(widget.id == 0){
                              if(catSelected.length >= 3){
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => questionnairAge(catSelected: catSelected),
                                    ));
                              }
                              else{
                                final snackBar = SnackBar(content: Text('You must choose at least three categories',style: TextStyle(color: Colors.white),),backgroundColor: HexColor('#555555'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }
                            else{
                              if(catSelected.length >= 3){
                                _update_data();
                              }
                              else{
                                final snackBar = SnackBar(content: Text('You must choose at least three categories',style: TextStyle(color: Colors.white),),backgroundColor: HexColor('#555555'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }
                          },
                          child: Text(
                            widget.id == 0 ?"Next":"Done",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Text('*', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                        Text('We will recommend books to you based on your selection'),
                      ],
                    ),
                  ],

            ),
          ),
        ),
      ),
    );
  }
  Future<void> _update_data() async {
    showLoading(context);
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc('$uid')
        .update({
      "user preferences":catSelected,
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Splash()),
    );
    const snackBar = const SnackBar(
        content: Text(
          'Data Has been Updated Successfully',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}



class catWidget extends StatefulWidget {
  final name;
  final imgId;
  final id;
  final catSelected;
  final user_preferences;
  const catWidget({Key? key,
    required this.name,
    required this.imgId,
    required this.id,
    required this.catSelected,
  required this.user_preferences}) : super(key: key);

  @override
  State<catWidget> createState() => _catWidgetState();
}

class _catWidgetState extends State<catWidget> {
  var col = Colors.white;
  var textcol = HexColor("#ffffff");
  bool chk = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.id != 0){
      for(var x in widget.user_preferences){
        if(x ==  widget.name){
          setState(() {
            col = Colors.grey;
            textcol = HexColor("#000000");
            chk = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                if (!chk) {
                  if(widget.catSelected.length < 6) {
                    setState(() {
                      col = Colors.grey;
                      textcol = HexColor("#000000");
                      widget.catSelected.add(widget.name);
                      chk = true;
                    });
                  }else{
                    final snackBar = SnackBar(content: Text('You can choose up to six categories only',style: TextStyle(color: Colors.white),),backgroundColor: HexColor('#555555'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                else{
                  setState(() {
                    col = HexColor("#ffffff");
                    textcol = HexColor("#ffffff");
                    widget.catSelected.remove(widget.name);
                    chk = false;
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric( horizontal: 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: col,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: 70,
                height: 70,
                child:
                Container(
                  child: Image.asset('assets/Icons/categories_icons/${widget.imgId}.png'),
                ),

              ),
            ),
            SizedBox(height: 5,),
            Text(widget.name,style: TextStyle(fontSize: 19,color: textcol),)
          ],
        )
    );
  }
}



