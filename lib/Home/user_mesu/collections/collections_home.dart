
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../component/loading.dart';
import 'collection_view.dart';

class collections_home extends StatefulWidget {
  const collections_home({Key? key}) : super(key: key);

  @override
  State<collections_home> createState() => _collections_homeState();
}

class _collections_homeState extends State<collections_home> {
  var collections = {};
  var collectionskey = [];
  var collectionsvalue = [];

  bool isData = true;
  bool acc = true;
  String error = "";

  Future<void> _getCollections() async {
    var collectionsData;
    try {
      var uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          var data = snapshot.data();
          if (data != null && data.containsKey('collections')) {
            setState(() {
              collectionsData = data['collections'];
              collections = collectionsData;
              collectionskey = collectionsData.keys.toList();
              collectionsvalue = collectionsData.values.toList();
            });
          }else{
            setState(() {
              isData = false;
            });
          }
        }
      });
    } catch (e) {
      print("erroe in get collection:$e");
    }
     if (collections.isEmpty){
       setState(() {
         isData = false;
       });
     }
    print(collectionskey);
  }

  @override
  void initState() {
    super.initState();
    _getCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Collections",
          style: new TextStyle(
              fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              createCollection(context);
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(
                  Icons.add,
                  size: 30,
                )),
          )
        ],
      ),
      body: collectionskey.length > 0
          ? Container(
        margin: EdgeInsets.all(8.0),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceEvenly,
            children: List.generate(collectionskey.length, (i) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                width: 120,
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => collection_view(name: collectionskey[i],list: collectionsvalue[i]),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/Icons/book.png",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(collectionskey[i],
                        maxLines: 2,textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      )
          : !isData
              ? Container(
        child: Center(
          child: Text(
            "You haven't any collection yet,\nadd new collection from '+' icon in top bar",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500,fontSize: 18,height: 2),
          ),
        ),
      )
              : Center(
                  child: CircularProgressIndicator(
                    color: HexColor('#000000'),
                  ),
                ),
    );
  }

  Future<void> createCollection(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      TextEditingController nameController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Create Collection'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter the Collection name'),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Collection name',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text('Create'),
                  onPressed: () async {
                    String name = nameController.text;
                    var uid = FirebaseAuth.instance.currentUser!.uid;
                    try {
                      showLoading(context);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .update({
                        'collections.$name': [],
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      _getCollections();
                      final snackBar = SnackBar(
                          content: Text(
                            'Collection created successfully',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: HexColor('#555555'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Collection created successfully.');
                    } catch (e) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      final snackBar = SnackBar(
                          content: Text(
                            'Failed to create Collection',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: HexColor('#555555'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Failed to create Collection (e): $e');
                    }
                  }),
            ],
          );
        },
      );
    } else {
      Navigator.of(context).pop();
      var snackBar = SnackBar(
          content: Text(
            "Please re-signin to be able to delete your account",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print("No user is currently signed in.");
    }
  }
}

