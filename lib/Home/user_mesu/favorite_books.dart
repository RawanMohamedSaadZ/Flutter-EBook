import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';

import '../HomePage.dart';
import '../view_book/BookDetailsPage.dart';

class favorite_books extends StatefulWidget {
  const favorite_books({Key? key}) : super(key: key);

  @override
  State<favorite_books> createState() => _favorite_booksState();
}

class _favorite_booksState extends State<favorite_books> {
  var booksIdList = [];

  final List<Book> favoriteBooks = [];
  //var apiKey = "AIzaSyCOfqS1y6l60nh7bmJfGH2BuMWVuBxLPWY";
  //var apiKey = "AIzaSyC9Mf74uEEUo7JmBC_42hRdwgjyUaJ2loU";
  var apiKey = "AIzaSyAqxw3nnCxwNQXRmXb-ZFi8FTNyhz6kwGA";



  bool isData = true;
  bool acc = true;
  String error = "";

  Future<void> _getBookById(id) async {
    final apiUrl = 'https://www.googleapis.com/books/v1/volumes/$id';
    final response = await get(Uri.parse(apiUrl));
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null) {
        final bookData = data;

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
            favoriteBooks.add(Book(
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

  Future<void> _getUserBooksId()async{
    try{var uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) {
      setState(() {
        booksIdList = snapshot.data.call()!['favorite books'];
      });
    });
    }catch (e){
      setState(() {
        isData = false;
      });
    }
    for(var i = 0; i < booksIdList.length; i++){
    }
  }

  Future<void> _getBooksHistory()async{
    await _getUserBooksId();
    if(booksIdList.length > 0){
      for(var item in booksIdList){
        await _getBookById(item);
      }
    }else{
      setState(() {
        isData = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _getBooksHistory();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Favorite Books",
          style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
      ),
      body: favoriteBooks.length > 0
          ?  Container(
        margin: EdgeInsets.all(8.0),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceEvenly,
            children: favoriteBooks.reversed.map((book) => List_Scans(context, book)).toList(),
          ),
        ),
      ):
      !isData? Container(child: Center(child: Text("You haven't favoriet any book yet",style: TextStyle(color: Colors.white),),),)
          :Center(
        child: CircularProgressIndicator(
          color: HexColor('#ffffff'),
        ),
      ),
    );
  }
}

Widget List_Scans(context, book) {
  return InkWell(
    onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookDetailsPage(book: book),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
      width: 150,
      child: Column(
        children: [
          Container(
            height: 180,
            child: Stack(
              children: [
                Center(
                  child: CircularProgressIndicator(color: HexColor('#ffffff'),),
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
          SizedBox(height: 15),
          Text(book.title,
            maxLines: 2,textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white),),
        ],
      ),
    ),
  );
}

