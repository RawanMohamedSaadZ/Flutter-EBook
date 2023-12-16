import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';

import '../HomePage.dart';
import 'BookDetailsPage.dart';

class view_category extends StatefulWidget {
  final category;
  const view_category({Key? key, required this.category}) : super(key: key);

  @override
  State<view_category> createState() => _view_categoryState();
}

class _view_categoryState extends State<view_category> {
  final List<Book> books = [];

  //var apiKey = "AIzaSyCOfqS1y6l60nh7bmJfGH2BuMWVuBxLPWY";
  //var apiKey = "AIzaSyC9Mf74uEEUo7JmBC_42hRdwgjyUaJ2loU";
  var apiKey = "AIzaSyAqxw3nnCxwNQXRmXb-ZFi8FTNyhz6kwGA";



  bool acc = true;
  String error = "";

  Future<void> _getBooksForCategory(String categoryName) async {
    final maxResults = 40;
    final apiUrl = 'https://www.googleapis.com/books/v1/volumes?q=subject:$categoryName&maxResults=$maxResults&key=$apiKey';
    final response = await get(Uri.parse(apiUrl));
    final data = json.decode(response.body);

    if (data['items'] != null) {
      final totalResults = data['totalItems'];
      final random = Random();
      final offset = random.nextInt(totalResults - maxResults);
      final apiUrlWithOffset = '$apiUrl&startIndex=$offset';
      final responseWithOffset = await get(Uri.parse(apiUrlWithOffset));
      final dataWithOffset = json.decode(responseWithOffset.body);
      if (dataWithOffset['items'] != null) {
        int i = 0;
        for (var bookData in dataWithOffset['items'] ) {
          if(books.length < 50){
            try{
              final id = bookData["id"];
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
                books.add(Book(
                    title: title,
                    imageUrl: imageUrl,
                    id:id,
                    author: author,
                    description: description,
                    publishedDate: publishedDate,
                    publisher: publisher,
                    pageCount: pageCount,
                    language: language,
                    previewLink: previewLink,
                    pdfLink: pdfLink,
                    rating: rating
                ));
              });

            }
            catch (e){
              print(e);
              print('=======================');
            }
          }
        }

        //recommended.sublist(0, 10);
      }

    }
    else if (data["error"]["code"]== 429){
      setState(() {
        acc = false;
        error = data["error"]["message"];
      });
    }
  }



  @override
  void initState() {
    super.initState();
    _getBooksForCategory(widget.category);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
      ),
      body: books.length > 0
          ? ListView.builder(
          shrinkWrap: true,
          itemCount: books.length,
          itemBuilder: (context, i) {
            return BookView(context, books[i]);
          })

          : Center(
        child: CircularProgressIndicator(
          color: HexColor('#000000'),
        ),
      ),
    );
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
                  style: TextStyle(
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
