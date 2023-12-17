import 'package:flutter/material.dart';

import '../conexao/end_points.dart';
import 'book_model.dart';

class BookUI extends StatefulWidget {
  const BookUI({super.key, required this.title, required this.selectedBookId});

  final String title;
  final String selectedBookId;

  @override
  State<BookUI> createState() => _BookUI();
}

class _BookUI extends State<BookUI> {
  late Future<BookModel>? selectedBook;

  @override
  void initState() {
    isConnected().then((internet) {
      if (internet) {
        setState(() {
          selectedBook = getBookData(widget.selectedBookId);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: FutureBuilder(
              future: selectedBook,
              builder:
                  (BuildContext context, AsyncSnapshot<BookModel> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    {
                      return loadingView(context);
                    }
                  case ConnectionState.active:
                    {
                      break;
                    }
                  case ConnectionState.done:
                    {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          if (snapshot.data!.id != null) {
                            return ListView.builder(
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            snapshot.data!.volumeInfo!.title !=
                                                    null
                                                ? "Título: ${snapshot.data!.volumeInfo!.title!}"
                                                : "",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.justify,
                                          ),
                                          subtitle: Text(
                                            (snapshot.data!.id != null
                                                    ? "ID: ${snapshot.data!.id!}"
                                                    : "") +
                                                (snapshot.data!.volumeInfo!
                                                            .authors !=
                                                        null
                                                    ? "\nAutores: ${snapshot.data!.volumeInfo!.authors.toString()}"
                                                    : "") +
                                                (snapshot.data!.volumeInfo!
                                                            .publisher !=
                                                        null
                                                    ? "\nEditora: ${snapshot.data!.volumeInfo!.publisher}"
                                                    : "") +
                                                (snapshot.data!.volumeInfo!
                                                            .publishedDate !=
                                                        null
                                                    ? "\nData de publicação: ${snapshot.data!.volumeInfo!.publishedDate!}"
                                                    : "") +
                                                (snapshot.data!.volumeInfo!
                                                            .description !=
                                                        null
                                                    ? "\nDescrição: ${snapshot.data!.volumeInfo!.description!}"
                                                    : ""),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        snapshot.data!.volumeInfo!.imageLinks!
                                                    .thumbnail !=
                                                null
                                            ? Image.network(snapshot
                                                .data!
                                                .volumeInfo!
                                                .imageLinks!
                                                .thumbnail!)
                                            : Image.asset("assets/null.png"),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return noDataView("1. Nenhum dado encontrado");
                          }
                        } else {
                          return noDataView("2. Nenhum dado encontrado");
                        }
                      } else if (snapshot.hasError) {
                        print(snapshot.stackTrace);
                        return noDataView(
                            "1. book Ocorreu um erro: ${snapshot.error}");
                      } else {
                        return noDataView("2. Ocorreu um erro");
                      }
                    }
                  case ConnectionState.none:
                    {
                      return loadingView(context);
                    }
                }
                throw "Error1";
              }),
        ),
      ),
    );
  }
}
