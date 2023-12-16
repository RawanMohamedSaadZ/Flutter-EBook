import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookReaderScreen extends StatefulWidget {
  final String pdfUrl;

  BookReaderScreen({required this.pdfUrl});

  @override
  _BookReaderScreenState createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book PDF Viewer'),
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            "https://books.googleusercontent.com/books/content?req=AKW5QadnY4-I8yjWuexapJ0p2Tqn7UPBYobkcJDoVHTm1R9DhR-Rq4ofnLgrVX1P5xe3qBhwkj0B7OqXGw19OEihgsZV97b1IuwhPlB854FtL8qx21RFh0soxjQB3Vba0z1tZTslm9IWzonHTJegpsaksbX8YQqiYbxfbYFh3LvTBq0hwU4dFRfYtPeUtSVc_iTqITxXv_dbv_unlgjS-JRejJhv34-b8uin6DFLmWj3lAFfv-FR7HHBMsBxuvKZDCiYRGHUOI3kRdyhyQDqnMqrD-RWJsFV1w",
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                _isLoading = false;
              });
            },
            onDocumentLoadFailed: (Object error) {
              setState(() {
                _isLoading = false;
                _errorMessage = 'Failed to load PDF: $error';
                print(error);
              });
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
          if (_errorMessage.isNotEmpty)
            Center(
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
