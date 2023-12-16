import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';

import '../HomePage.dart';
import '../view_book/BookDetailsPage.dart';

class books_history extends StatefulWidget {
  const books_history({Key? key}) : super(key: key);

  @override
  State<books_history> createState() => _books_historyState();
}

class _books_historyState extends State<books_history> {
  var booksIdList = [];

  final List<Book> BooksHistory = [];
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
            BooksHistory.add(Book(
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
        booksIdList = snapshot.data.call()!['books history'];
      });
    });
    }catch (e){
      setState(() {
        isData = false;
      });
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
      appBar: AppBar(
        title: Text(
          "Books History",
          style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
      ),
      body: BooksHistory.length > 0
          ? Container(
        margin: EdgeInsets.all(8.0),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceEvenly,
            children: BooksHistory.reversed.map((book) => List_Scans(context, book)).toList(),
          ),
        ),
      ):
      !isData? Container(child: Center(child: Text("You haven't seen any book yet"),),)
          :Center(
            child: CircularProgressIndicator(
        color: HexColor('#000000'),
      ),
          ),
    );
  }
}

Widget List_Scans(context, book) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsPage(book: book),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 150,
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
              flex: 2,
              child: Container(
                height: 120,
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
              flex: 5,
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
                      style:  TextStyle(
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
                    'Rating: ' + book.rating,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.bold)
                  ),
                  SizedBox(
                    height: 30,
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

