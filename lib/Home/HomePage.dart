import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enlighten/Home/user_mesu/user_menu.dart';
import 'package:enlighten/Home/view_book/BookDetailsPage.dart';
import 'package:enlighten/Home/view_book/search_book.dart';
import 'package:enlighten/Home/view_book/view_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';

import '../component/loading.dart';
import '../get_start/SplashScreen.dart';

class HomePage extends StatefulWidget {
  final user_preferences;
  const HomePage({Key? key, required this.user_preferences}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  List<BookCategory> categories = [];
  final List<Book> recommended = [];
  var apiKey = "AIzaSyCOfqS1y6l60nh7bmJfGH2BuMWVuBxLPWY";
  //var apiKey = "AIzaSyC9Mf74uEEUo7JmBC_42hRdwgjyUaJ2loU";
  //var apiKey = "AIzaSyAqxw3nnCxwNQXRmXb-ZFi8FTNyhz6kwGA";



  bool acc = true;
  String error = "";

  Future<void> _getBooksForCategory(String categoryName) async {
    final maxResults = 40;
    final apiUrl = 'https://www.googleapis.com/books/v1/volumes?q=subject:$categoryName&maxResults=$maxResults&key=$apiKey';
    final response = await get(Uri.parse(apiUrl));
    final data = json.decode(response.body);
    final List<Book> books = [];
print(Uri.parse(apiUrl));
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
          if(books.length < 20){
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
            if (bookData['accessInfo']['pdf']['downloadLink'] != null) {
              print("pdfLink:$pdfLink");
            }
            final rating = bookData['volumeInfo']['averageRating']?.toString() ?? "0.0";
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
            if (i < 4 && double.parse(rating) >= 4){
              recommended.add(Book(title: title, imageUrl: imageUrl, id:id,
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
              i++;
            }
          }
          catch (e){
            print(e);
            print('=======================');
          }
        }
        }
        setState(() {
          categories.add(BookCategory(categoryName: categoryName)..books = books);
        });
        recommended.shuffle();
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

_handlePage() async {
    print(widget.user_preferences);
  for (var categoryName in widget.user_preferences) {
     _getBooksForCategory(categoryName);
  }
  setState(() {
    categories.insert(0,BookCategory(categoryName: 'Recommended for You')..books = recommended);
  });
}

  @override
  void initState() {
    print("user_preferences 2:${widget.user_preferences}");
    super.initState();
    _handlePage();

  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: HexColor("#EEEEEE"),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(110), child: _buildappbar()),
        drawer: user_menu(user_preferences: widget.user_preferences),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Splash(),
              ),
            );
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.refresh_outlined,color: Colors.white,),
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: categories.length > 1 && acc ?
          ListView.builder(
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              final category = categories[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category.categoryName,
                          style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),

                        ),
                        category.categoryName != "Recommended for You" ?
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => view_category(category:category.categoryName)),
                            );
                          },
                          child: Text(
                            'see more',
                            style:                               TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.grey[500],    decoration: TextDecoration.underline,

                            ),
                          ),
                        ):
                        Container(),
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: category.books.length,
                      itemBuilder: (BuildContext context, int index) {
                        var book = category.books[index];
                        var id = category.books[index].id;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              var uid = FirebaseAuth.instance.currentUser!.uid;
                              try {
                                showLoading(context);
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .update({
                                  'books history': FieldValue.arrayUnion([id]),
                                });
                                Navigator.of(context).pop();
                                print('Element added to the array successfully.');
                              } catch (e) {
                                Navigator.of(context).pop();
                                print('Failed to add element to the array: $e');
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookDetailsPage(book: book),
                                ),
                              );
                            },
                            child: Container(
                              width: 150,
                              child: Column(
                                children: [
                                  Container(
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


                                  SizedBox(height: 15),
                                  Text(book.title,maxLines: 2,textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  index != categories.length-1 ?
                  Center(
                    child: Container(height: 1.5,
                    width: 250,
                    color: Colors.grey,),
                  ):
                  Container(),
                  SizedBox(height: 15),

                ],
              );
            },
          ):
          !acc ?
          Center(child: Text(error,style: TextStyle(color: Colors.grey),textAlign: TextAlign.center),)
          :Center(child: CircularProgressIndicator(color: HexColor('#000000'),)),
        ),
        ),

    );
  }
}

class _buildappbar extends StatelessWidget {
  const _buildappbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () => Scaffold.of(
          context,
        ).openDrawer(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 10.0,
      flexibleSpace: Container(
        child: Container(alignment: Alignment.bottomCenter, child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: searchBar(),
        )),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: new BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0))),
      ),

      title: Text("Enlighten",
        style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class searchBar extends StatelessWidget {

  TextEditingController _query = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 8.0),

      child: TextField(
        controller: _query,
        cursorColor: Colors.black,
        style: TextStyle(backgroundColor: HexColor("#D3D3D3"),color: Colors.black.withOpacity(0.7)),
        decoration: InputDecoration(

            contentPadding: EdgeInsets.only(
                top: 15, left: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.5
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            hintText:"Search for a Book!",
            hintStyle: TextStyle(backgroundColor: HexColor("#D3D3D3"),color: Colors.black.withOpacity(0.7)),
            suffixIcon:
            InkWell(
                onTap: (){
                  if(_query.text != ""){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>SearchScan(text: _query.text, )));
                  }
                },
                child: new Icon(Icons.search, color: Colors.black.withOpacity(.8))),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white,
                width: 0,
              ),
            ),
            fillColor: HexColor("#D3D3D3"),
            filled: true
        ),
      ),
    );
  }
}

class Book {
  String title;
  String imageUrl;
  String author;
  String description;
  String publishedDate;
  String publisher;
  String pageCount;
  String language;
  String previewLink;
  String pdfLink;
  var id;
  String rating;

  Book({
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.description,
    required this.publishedDate,
    required this.publisher,
    required this.pageCount,
    required this.language,
    required this.previewLink,
    required this.pdfLink,
    required this.id,
    required this.rating
  });
}

class BookCategory {
  String categoryName;
  List<Book> books = [];
  BookCategory({required this.categoryName});
}
