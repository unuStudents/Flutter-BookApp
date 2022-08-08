// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';

import 'package:book_app/models/book_detail_response.dart';
import 'package:book_app/models/book_list_respond.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({
    Key? key,
    required this.isbn,
  }) : super(key: key);
  final String isbn;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookDetailResponse? detailBook;
  fetchDetailBookApi() async {
    print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/books/${widget.isbn}');
    var response = await http.post(url);
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      detailBook = BookDetailResponse.fromJson(jsonDetail);
      setState(() {});
      fetchSimiliarBookApi(detailBook!.title!);
    }
    // print(await http.read(Uri.parse('https:example.com/api.json')));
  }

  BookListRespond? similiarBooks;
  fetchSimiliarBookApi(String title) async {
    print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/search/${title}');
    var response = await http.post(url);
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      similiarBooks = BookListRespond.fromJson(jsonDetail);
      setState(() {});
    }
    // print(await http.read(Uri.parse('https:example.com/api.json')));
  }

  @override
  void initState() {
    super.initState();
    fetchDetailBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Buku"),
      ),
      body: detailBook == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageViewScreen(
                                imageUrl: detailBook!.image!,
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          detailBook!.image!,
                          height: 150,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detailBook!.title!,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                detailBook!.authors!,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: List.generate(
                                    5,
                                    (index) => Icon(
                                          Icons.star,
                                          color: index <
                                                  int.parse(detailBook!.rating!)
                                              ? Colors.yellow
                                              : Colors.grey,
                                        )),
                              ),
                              Text(
                                detailBook!.subtitle!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                detailBook!.price!,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.green[900]),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            // fixedSize: Size(double.infinity, 50),
                            ),
                        onPressed: () {},
                        child: const Text('Buy')),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    detailBook!.desc!,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Year : ${detailBook!.year!}"),
                      Text("ISBN : ${detailBook!.isbn13!}"),
                      Text("${detailBook!.pages!} Pages"),
                      Text("Publisher : ${detailBook!.publisher!}"),
                      Text("Language : ${detailBook!.language!}"),
                      Text('Rating ${detailBook!.rating!}'),

                      // Text(detailBook!.isbn13!),
                    ],
                  ),
                  const Divider(),
                  // similiarBooks == null
                  //     ? const CircularProgressIndicator()
                  //     : ListView.builder(
                  //         shrinkWrap: true,
                  //         itemCount: similiarBooks!.books!.length,
                  //         physics: const NeverScrollableScrollPhysics(),
                  //         itemBuilder: (context, index) {
                  //           return Container();
                  //         },
                  //       )
                ],
              ),
            ),
    );
  }
}
