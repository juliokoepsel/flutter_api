import 'dart:convert';

import 'package:flutter/material.dart';
import '/conexao/database.dart';
import 'book_model.dart';
import 'book_list_model.dart';
import '/log/log_model.dart';
import '/conexao/end_points.dart';
import 'book_ui.dart';
import 'favorite.dart';

class AddUI extends StatefulWidget {
  const AddUI({super.key, required this.title});

  final String title;

  @override
  State<AddUI> createState() => _AddUI();
}

class _AddUI extends State<AddUI> {
  Future<BookListModel>? bookListFuture;
  late DatabaseHandler handler;

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final TextEditingController buscaController = TextEditingController();

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
        child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: refreshData,
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: buscaController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Pesquise por um Livro",
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                    ),
                    onPressed: () async {
                      refreshData();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(19),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Expanded(
                child: FutureBuilder<BookListModel>(
                    future: bookListFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                              if (snapshot.data!.bookList != null) {
                                if (snapshot.data!.bookList.length > 0) {
                                  return ListView.builder(
                                      itemCount: snapshot.data!.bookList.length,
                                      itemBuilder: (context, index) {
                                        return generateColum(
                                            snapshot.data!.bookList[index]);
                                      });
                                } else {
                                  return noDataView(
                                      "1. Nenhum dado encontrado");
                                }
                              } else if (buscaController.text == "") {
                                return noDataView("");
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
            ])),
      ),
    );
  }

  @override
  void initState() {
    isConnected().then((internet) {
      if (internet) {
        setState(() {
          bookListFuture = getBookListData(null);
        });
      }
    });
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      setState(() {
        // bookListFuture = getBookListData(null);
      });
    });
  }

  Future<void> refreshData() async {
    isConnected().then((internet) {
      if (internet) {
        setState(() {
          bookListFuture = getBookListData(buscaController.text);
        });
      }
    });
    super.initState();
  }

  Future<int> addObj(Favorite obj) async {
    List<Favorite> objs = [obj];
    return await handler.insertFavorite(objs);
  }

  Widget generateColum(BookModel item) => Card(
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookUI(
                        title: "Livro",
                        selectedBookId: item.id!,
                      )),
            );
          },
          leading: item.volumeInfo!.imageLinks!.smallThumbnail != null
              ? Image.network(item.volumeInfo!.imageLinks!.smallThumbnail!)
              : Image.asset("assets/null.png"),
          title: Text(
            item.volumeInfo!.title != null ? item.volumeInfo!.title! : "",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            item.volumeInfo!.publishedDate != null
                ? item.volumeInfo!.publishedDate!
                : "",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
            onPressed: () async {
              Favorite obj = Favorite(
                  idLivro: item.id!,
                  titulo: item.volumeInfo!.title,
                  dataHora: item.volumeInfo!.publishedDate,
                  smallThumbnail: item.volumeInfo!.imageLinks?.smallThumbnail);
              await addObj(obj);
              LogModel log = LogModel(
                  idLivro: item.id!,
                  acao: "ADICIONOU",
                  titulo: item.volumeInfo!.title != null
                      ? item.volumeInfo!.title!
                      : "NONAME",
                  dataHora: DateTime.now().toString());

              postLog(log);

              print(log.toString());
              print(jsonEncode(log.toJson()));

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Livro adicionado à lista!")));
            },
            child: const Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        ),
      );
}
