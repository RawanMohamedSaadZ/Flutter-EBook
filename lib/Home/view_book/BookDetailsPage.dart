import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/ImageView.dart';
import '../../component/loading.dart';
import '../HomePage.dart';
import 'display_the_PDF.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;

  const BookDetailsPage({required this.book});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  var icon = Icons.favorite_border_outlined;
  bool flg = false;
  var booksIdList = [];
  var collections = {};
  var collectionskey = [];
  var collectionsvalue = [];
  var collist = [];

  _checkFav_collection() async {
    try {
      var uid = FirebaseAuth.instance.currentUser!.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          setState(() {
            booksIdList = data['favorite books'] ?? [];
            collections = data['collections'] ?? {};
            collectionskey = collections.keys.toList();
            collectionsvalue = collections.values.toList();
          });

          for (var x in booksIdList) {
            if (x == widget.book.id) {
              setState(() {
                icon = Icons.favorite;
                flg = true;
              });
            }
          }

          for (var entry in collections.entries) {
            if (entry.value != null && entry.value.contains(widget.book.id)) {
              collist.add(entry.key);
            }
          }
        }
      }
    } catch (e) {
      print('Failed on _checkFav_collection: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkFav_collection();
    print(widget.book.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Book Details"),
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
                onTap: () async {
                  if (!flg) {
                    var uid = FirebaseAuth.instance.currentUser!.uid;
                    try {
                      showLoading(context);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .update({
                        'favorite books':
                            FieldValue.arrayUnion([widget.book.id]),
                      });
                      Navigator.of(context).pop();
                      final snackBar = SnackBar(
                          content: Text(
                            'Book added to your favorit successfully',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: HexColor('#555555'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Element added to the array successfully.');
                      setState(() {
                        icon = Icons.favorite_outlined;
                        flg = true;
                      });
                    } catch (e) {
                      Navigator.of(context).pop();
                      print('Failed to add element to the array: $e');
                    }
                  } else {
                    var uid = FirebaseAuth.instance.currentUser!.uid;
                    try {
                      showLoading(context);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .update({
                        'favorite books':
                            FieldValue.arrayRemove([widget.book.id]),
                      });
                      Navigator.of(context).pop();
                      final snackBar = SnackBar(
                          content: Text(
                            'Book removed from your favorit successfully',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: HexColor('#555555'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Element removed from the array successfully.');
                      setState(() {
                        icon = Icons.favorite_border_outlined;
                        flg = false;
                      });
                    } catch (e) {
                      Navigator.of(context).pop();
                      print('Failed to add element to the array: $e');
                    }
                  }
                },
                child: Icon(
                  icon,
                  color: Colors.white,
                )),
          ),
          collectionskey.length == 0 ?
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: (){
                final snackBar = SnackBar(
                    content: Text(
                      'No Collections Created Yet',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: HexColor('#555555'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Icon(
                Icons.bookmarks_rounded,
                color: Colors.white,
              ),
            ),
          ):
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child:  PopupMenuButton<String>(
                icon: Icon(
                    Icons.bookmarks_rounded,
                    color: Colors.white,
                  ),

                onSelected: (String result) async {
                  var uid = FirebaseAuth.instance.currentUser!.uid;
                  if(collist.contains(result)){
                    //remove
                    try {
                      showLoading(context);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .update({
                        'collections.$result': FieldValue.arrayRemove([widget.book.id]),
                      });
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsPage(book: widget.book),
                        ),
                      );
                      final snackBar = SnackBar(
                          content: Text(
                            'Book removed from $result Collection successfully',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: HexColor('#555555'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Book removed.');
                    } catch (e) {
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
                  }
                  else{
                    //add
                    try {
                      showLoading(context);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .update({
                        'collections.$result': FieldValue.arrayUnion([widget.book.id]),
                      });
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsPage(book: widget.book),
                        ),
                      );
                      final snackBar = SnackBar(
                          content: Text(
                            'Book added to $result Collection successfully',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: HexColor('#555555'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Collection created successfully.');
                    } catch (e) {
                      Navigator.of(context).pop();
                      final snackBar = SnackBar(
                          content: Text(
                            'Failed to add book Collection',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: HexColor('#555555'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Failed to create Collection (e): $e');
                    }

                  }
                },
                elevation: 10,

                itemBuilder: (BuildContext context) {
                  return collectionskey.map((dynamic choice) {
                    return PopupMenuItem<String>(
                      value: choice.toString(),
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                          decoration: BoxDecoration(
                            color: collist.contains(choice)
                                ? HexColor('#eeeeee')
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(choice.toString()),
                              collist.contains(choice)
                                  ? Icon(
                                Icons.check,
                                color: Colors.black,
                              )
                                  : Container()
                            ],
                          ),
                      ),
                    );
                  }).toList();
                },
                offset: Offset(0, 50),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: new BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (_) => ImageDialog(img: widget.book.imageUrl,)
                          );
                        },
                        child: Container(
                          height: 220,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(
                                  widget.book.imageUrl,
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.book.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style:TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 23,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "by " + widget.book.publisher,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15,
                            color: Colors.grey[400])
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Rating",
                                style: TextStyle(
                          fontSize: 15, color: Colors.grey[400])
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.book.rating,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white)
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Pages",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[400])
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.book.pageCount,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white)
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Language",
                                style: TextStyle(
                              fontSize: 15, color: Colors.grey[400])
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.book.language,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white)
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Publish date",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[400])),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.book.publishedDate.toUpperCase(),
                                style:TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.white)
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
          Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 25),
                      child: ListView(
                        children: [
                          Text(
                            "What's it about?",
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            )
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: SingleChildScrollView(
                              child: Text(
                                widget.book.description,
                                style: TextStyle(color: Colors.grey[600], fontSize: 15)
                            ),
                          ))
                        ],
                      ),
                    ))
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    print(widget.book.pdfLink);
                    if (widget.book.pdfLink != 'not available') {
                      launch(widget.book.pdfLink);

                    } else {
                      final snackBar = SnackBar(
                          content: Text(
                            'Sorry, PDF is not Available Now!',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: HexColor('#555555'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
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
                      width: 100,
                      height: 45,
                      child: Center(
                        child: Text(
                          'Read',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
                InkWell(
                  onTap: () {
                    if (widget.book.previewLink != 'not available') {
                      launch(widget.book.previewLink);
                    } else {
                      final snackBar = SnackBar(
                          content: Text(
                            'Sorry, Preview Link is not Available Now!',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: HexColor('#555555'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
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
                      width: 100,
                      height: 45,
                      child: Center(
                        child: Text(
                          'Preview',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
