import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';

import '../../../component/loading.dart';
import '../../HomePage.dart';
import '../../view_book/BookDetailsPage.dart';
import 'collections_home.dart';

class collection_view extends StatefulWidget {
  final name;
  final list;
  const collection_view({Key? key, required this.name, required this.list}) : super(key: key);

  @override
  State<collection_view> createState() => _collection_viewState();
}

class _collection_viewState extends State<collection_view> {
  final List<Book> CollectionBooks = [];
  //var apiKey = "AIzaSyCOfqS1y6l60nh7bmJfGH2BuMWVuBxLPWY";
  //var apiKey = "AIzaSyC9Mf74uEEUo7JmBC_42hRdwgjyUaJ2loU";
  var apiKey = "AIzaSyAqxw3nnCxwNQXRmXb-ZFi8FTNyhz6kwGA";

  var name ;
  var list = [];

  bool isData = true;
  bool acc = true;
  String error = "";




  Future<void> _getBookById(String id) async {
    final apiUrl = 'https://www.googleapis.com/books/v1/volumes/$id';
    final response = await get(Uri.parse(apiUrl));
    print(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null) {
        final bookData = data;
        print(data);

        try {
          final id = bookData['id'];
          final title = bookData['volumeInfo']['title'] ?? 'Unknown';
          final imageUrl = bookData['volumeInfo']['imageLinks']['thumbnail'] ?? 'https://firebasestorage.googleapis.com/v0/b/enlighten-263ce.appspot.com/o/images%2Fuser_profile_images%2Fdefult_user_img.png?alt=media&token=4c0704c8-0660-4a1d-9b3e-a64ef8435f33';
          final author = bookData['volumeInfo']['authors']?.join(', ') ?? 'Unknown';
          final description = bookData['volumeInfo']['description'] ?? 'No description available.';
          final publishedDate = bookData['volumeInfo']['publishedDate'] ?? 'Unknown';
          final publisher = bookData['volumeInfo']['publisher'] ?? 'Unknown';
          final pageCount = bookData['volumeInfo']['pageCount']?.toString() ?? 'Unknown';
          final language = bookData['volumeInfo']['language'] ?? 'Unknown';
          final previewLink = bookData['volumeInfo']['previewLink'] ?? 'not available';
          final pdfLink = bookData['accessInfo']['pdf']['downloadLink'] ?? 'not available';
          final rating = bookData['volumeInfo']['averageRating']?.toString() ?? "0.0";

          setState(() {
            CollectionBooks.add(Book(
              id: id,
              title: title,
              imageUrl: imageUrl,
              author: author,
              description: description,
              publishedDate: publishedDate,
              publisher: publisher,
              pageCount: pageCount,
              language: language,
              previewLink: previewLink,
              pdfLink: pdfLink,
              rating: rating,
            ));
          });
        } catch (e) {
          print('Error parsing book data: $e');
        }
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }


  handleBooks() async {
    name = widget.name;
    if(widget.list.length != 0){
      list = widget.list;
    }else{
      isData = false;
    }
    for(var item in list){
      await  _getBookById(item);
    }
  }

  @override
  void initState() {
    super.initState();
    handleBooks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          name,
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
              DeleteCollection(context);
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(
                  Icons.delete,
                  size: 30,
                )),
          )
        ],
      ),
      body: CollectionBooks.length > 0
          ? Container(
        margin: EdgeInsets.all(8.0),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceEvenly,
            children: CollectionBooks.reversed.map((book) => BookView(context, book)).toList(),
          ),
        ),
      )
          : !isData
          ? Container(
        child: Center(
          child: Text(
            "You haven't added any book to this collection yet.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500,fontSize: 20,height: 1.5),
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

  Future<void> DeleteCollection(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Collection'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you sure to Delete ${widget.name} Collection'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text('Delete',
                    style: TextStyle(color: Colors.red),),
                  onPressed: () async {
                    var uid = FirebaseAuth.instance.currentUser!.uid;
                    try {
                      showLoading(context);
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .update({
                        'collections.${widget.name}': FieldValue.delete(),
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => collections_home(),
                        ),
                      );
                      final snackBar = SnackBar(
                          content: Text(
                            'Collection Deleted successfully',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: HexColor('#555555'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Collection Deleted successfully.');
                    } catch (e) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      final snackBar = SnackBar(
                          content: Text(
                            'Failed to Delete Collection',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: HexColor('#555555'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print("Failed to Delete Collection (e): $e");
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
Widget BookView(context, book) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: HexColor('#EEEEEE'),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 180,
              child: Stack(
                children: [
                  Center(
                    child: CircularProgressIndicator(color: HexColor('#000000'),),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          book.imageUrl,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Flexible(
                  child: Text(
                    book.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Text(
                    book.author,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                        fontWeight: FontWeight.bold)
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Page Count: " + book.pageCount,
                  style:  TextStyle(
                color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.bold)
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Rating: ' + book.rating,
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontWeight: FontWeight.bold)
                ),
                SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsPage(book: book),
                      ),
                    );
                  },
                  child: Text(
                    "DETAILS",
                    style: TextStyle(color: HexColor('#FFB600')),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

