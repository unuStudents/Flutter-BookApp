import 'dart:convert';
import 'package:book_app/models/book_detail_response.dart';
import 'package:flutter/material.dart';
import 'package:book_app/models/book_list_respond.dart';
import 'package:http/http.dart' as http;

class BookController extends ChangeNotifier {
  BookListRespond? bookList;
  fetchBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonBookList = jsonDecode(response.body);
      bookList = BookListRespond.fromJson(jsonBookList);
      notifyListeners();
    }
  }

  BookDetailResponse? detailBook;
  fetchDetailBookApi(isbn) async {
    var url = Uri.parse('https://api.itbook.store/1.0/books/$isbn');
    var response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      detailBook = BookDetailResponse.fromJson(jsonDetail);
      notifyListeners();
      fetchSimiliarBookApi(detailBook!.title!);
    }
  }

  BookListRespond? similiarBooks;
  fetchSimiliarBookApi(String title) async {
    var url = Uri.parse('https://api.itbook.store/1.0/search/$title');
    var response = await http.post(url);
    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      similiarBooks = BookListRespond.fromJson(jsonDetail);
      notifyListeners();
    }
  }
}
