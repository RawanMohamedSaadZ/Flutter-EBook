import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';

import '../HomePage.dart';
import 'BookDetailsPage.dart';

class SearchScan extends StatefulWidget {
  final text;

  const SearchScan({Key? key, required this.text}) : super(key: key);

  @override
  State<SearchScan> createState() => _SearchScanState();
}

class _SearchScanState extends State<SearchScan> {
  final List<Book> searchBooks = [];
  var apiKey = "AIzaSyC9Mf74uEEUo7JmBC_42hRdwgjyUaJ2loU";

  bool flg = false;
  bool acc = true;
  String error = "";
  var itemCount;
  TextEditingController _query = TextEditingController();

  Future<void> _getBooksForCategory(String query) async {
    setState(() {
      searchBooks.clear();
      flg = false;
    });
    final maxResults = 40;
    final apiUrl =
        'https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=$maxResults';
    final response = await get(Uri.parse(apiUrl));
    final data = json.decode(response.body);
    final totalResults = data['totalItems'];
    if(totalResults == 0){
      setState(() {
        itemCount = totalResults;
      });
    }
    else if (data['items'] != null ) {
      final random = Random();
      final offset = random.nextInt(totalResults - maxResults);
      final apiUrlWithOffset = '$apiUrl&startIndex=$offset';
      final responseWithOffset = await get(Uri.parse(apiUrlWithOffset));
      final dataWithOffset = json.decode(responseWithOffset.body);
      setState(() {
        itemCount = totalResults;
      });
      if (dataWithOffset['items'] != null) {
        for (var bookData in dataWithOffset['items']) {
          try {
            final id = bookData["id"];
            final title = bookData['volumeInfo']['title'] ?? 'Unknown';
            final imageUrl = bookData['volumeInfo']['imageLinks']
                    ['thumbnail'] ??
                'https://firebasestorage.googleapis.com/v0/b/enlighten-263ce.appspot.com/o/images%2Fuser_profile_images%2Fdefult_user_img.png?alt=media&token=4c0704c8-0660-4a1d-9b3e-a64ef8435f33';
            final author =
                bookData['volumeInfo']['authors']?.join(', ') ?? 'Unknown';
            final description = bookData['volumeInfo']['description'] ??
                'No description available.';
            final publishedDate =
                bookData['volumeInfo']['publishedDate'] ?? 'Unknown';
            final publisher = bookData['volumeInfo']['publisher'] ?? 'Unknown';
            final pageCount =
                bookData['volumeInfo']['pageCount']?.toString() ?? 'Unknown';
            final language = bookData['volumeInfo']['language'] ?? 'Unknown';
            final previewLink =
                bookData['volumeInfo']['previewLink'] ?? 'not available';
            final pdfLink = bookData['accessInfo']['pdf']['downloadLink'] ??
                'not available';
            final rating =
                bookData['volumeInfo']['averageRating']?.toString() ?? "0.0";
            setState(() {
              searchBooks.add(Book(
                  title: title,
                  imageUrl: imageUrl,
                  id: id,
                  author: author,
                  description: description,
                  publishedDate: publishedDate,
                  publisher: publisher,
                  pageCount: pageCount,
                  language: language,
                  previewLink: previewLink,
                  pdfLink: pdfLink,
                  rating: rating));
            });
          } catch (e) {
            print(e);
            print('=======================');
          }
        }
      }
    }
    else if (data["error"]["code"] == 429) {
      setState(() {
        acc = false;
        error = data["error"]["message"];
      });
    }
    if(searchBooks.length == 0 && acc){
      setState(() {
        flg = true;
      });
    }else{
      setState(() {
        flg = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getBooksForCategory(widget.text);
    _query.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: _buildappbar(),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                searchBar(),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: HexColor('#000000'),
                    borderRadius: BorderRadius.circular(21),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 80,
                  height: 35,
                  child: new TextButton(
                      style: TextButton.styleFrom(primary: Colors.white),
                      onPressed: () {
                        if (_query.text != "") {
                          _getBooksForCategory(_query.text);
                        }
                      },
                      child: Text(
                        'Search',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: searchBooks.length > 0 && acc
                ? SingleChildScrollView(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: searchBooks.length,
                        itemBuilder: (context, i) {
                          return List_Scans(context, searchBooks[i]);
                        }))
                : !acc
                    ? Center(
                        child: Text(error,
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center),
                      )
                    : flg
                        ? SingleChildScrollView(
                          child: Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 80),

                                    Container(
                                      width: 300,
                                      child: Image.asset(
                                        "assets/Icons/not_found.png",
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text('No Books Found', style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),),
                                  ],
                                ),
                              ),
                            ),
                        )
                        : Center(
                            child: CircularProgressIndicator(
                              color: HexColor('#000000'),                      )),
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        initialValue: widget.text,
        onChanged: (text) {
          _query.text = text;
        },
        cursorColor: Colors.black,
        style: TextStyle(
            backgroundColor: HexColor("#D3D3D3"),
            color: Colors.black.withOpacity(0.7)),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 15, left: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            hintText: "Search for a Book!",
            hintStyle: TextStyle(
                backgroundColor: HexColor("#D3D3D3"),
                color: Colors.black.withOpacity(0.7)),
            suffixIcon: InkWell(
                onTap: () {
                  if (_query.text != "") {
                    _getBooksForCategory(_query.text);
                  }
                },
                child: new Icon(Icons.search,
                    color: Colors.black.withOpacity(.8))),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white,
                width: 0,
              ),
            ),
            fillColor: HexColor("#D3D3D3"),
            filled: true),
      ),
    );
  }
}

Widget List_Scans(context, book) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    child: Container(
      padding: EdgeInsets.all(8),
      height: 240,
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
                  style:  TextStyle(
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

class _buildappbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          padding: const EdgeInsets.only(top: 20.0),
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        child: Container(alignment: Alignment.bottomCenter),
        decoration: BoxDecoration(
            color: HexColor('#000000'),
            borderRadius: new BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0))),
      ),
      title: Padding(
        padding: EdgeInsets.only(right: 40, top: 20),
        child: Text(
          "Book Search",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
