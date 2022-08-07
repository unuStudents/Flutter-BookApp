// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({Key? key}) : super(key: key);

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  fetchDetailBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/books/9781484206485');
    var response =
        await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');
    // print(await http.read(Uri.parse('https:example.com/api.json')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
    );
  }
}
