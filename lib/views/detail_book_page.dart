import 'package:book_app/controllers/book_controller.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  BookController? controller;
  @override
  void initState() {
    super.initState();
    controller = Provider.of<BookController>(context, listen: false);
    controller!.fetchDetailBookApi(widget.isbn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Buku"),
      ),
      body: Consumer<BookController>(builder: (context, controller, child) {
        return controller.detailBook == null
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
                                  imageUrl: controller.detailBook!.image!,
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            controller.detailBook!.image!,
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
                                  controller.detailBook!.title!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  controller.detailBook!.authors!,
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
                                                    int.parse(controller
                                                        .detailBook!.rating!)
                                                ? Colors.yellow
                                                : Colors.grey,
                                          )),
                                ),
                                Text(
                                  controller.detailBook!.subtitle!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  controller.detailBook!.price!,
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
                          style: ElevatedButton.styleFrom(),
                          onPressed: () async {
                            Uri uri = Uri.parse(controller.detailBook!.url!);
                            try {
                              (await canLaunchUrl(uri))
                                  ? launchUrl(uri)
                                  : debugPrint('tidak bersahasil');
                            } catch (e) {
                              debugPrint('error');
                            }
                          },
                          child: const Text('Buy')),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      controller.detailBook!.desc!,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Year : ${controller.detailBook!.year!}"),
                        Text("ISBN : ${controller.detailBook!.isbn13!}"),
                        Text("${controller.detailBook!.pages!} Pages"),
                        Text(
                            "Publisher : ${controller.detailBook!.publisher!}"),
                        Text("Language : ${controller.detailBook!.language!}"),
                        Text('Rating ${controller.detailBook!.rating!}'),
                      ],
                    ),
                    const Divider(),
                    controller.similiarBooks == null
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  controller.similiarBooks!.books!.length,
                              itemBuilder: (context, index) {
                                final current =
                                    controller.similiarBooks!.books![index];
                                return SizedBox(
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        current.image!,
                                        height: 100,
                                      ),
                                      Text(
                                        current.title!,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
              );
      }),
    );
  }
}
