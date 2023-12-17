import 'dart:convert';

import 'package:flutter/material.dart';
import '/conexao/database.dart';
import '/log/log_model.dart';
import '/conexao/end_points.dart';
import 'book_ui.dart';
import 'favorite.dart';

class BookListUI extends StatefulWidget {
  const BookListUI({super.key, required this.title});

  final String title;

  @override
  State<BookListUI> createState() => _BookListUI();
}

class _BookListUI extends State<BookListUI> {
  late DatabaseHandler handler;

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Biblioteca API',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('Livros'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/list');
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Log'),
              onTap: () {
                Navigator.pushNamed(context, '/log');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_box_sharp),
              title: const Text('Sobre'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: refreshData,
            child: Column(children: [
              Expanded(
                child: FutureBuilder(
                    future: handler.retrieveFavorites(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return generateColum(snapshot.data![index]);
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
              const SizedBox(height: 70),
            ])),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/add').then((_) => setState(() {}));
        },
        tooltip: 'Adicionar Livro',
        child: const Icon(Icons.add),
      ),
    );
  }

  /*
  @override
  void initState() {
    isConnected().then((internet) {
      if (internet) {
        setState(() {
          bookListFuture = getBookListData("quilting");
        });
      }
    });
    super.initState();
  }
  */

  Future<void> refreshData() async {
    isConnected().then((internet) {
      if (internet) {
        setState(() {});
      }
    });
    super.initState();
  }

  Widget generateColum(Favorite item) => Card(
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookUI(
                        title: "Livro",
                        selectedBookId: item.idLivro,
                      )),
            );
          },
          leading: item.smallThumbnail != null
              ? Image.network(item.smallThumbnail!)
              : Image.asset("assets/null.png"),
          title: Text(
            item.titulo != null ? item.titulo! : "",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            item.dataHora != null ? item.dataHora! : "",
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
              await handler.deleteFavorite(item.idLivro);
              LogModel log = LogModel(
                  idLivro: item.idLivro,
                  acao: "REMOVEU",
                  titulo: item.titulo != null ? item.titulo! : "NONAME",
                  dataHora: DateTime.now().toString());

              postLog(log);

              print(log.toString());
              print(jsonEncode(log.toJson()));

              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Livro removido da lista!")));
            },
            child: const Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        ),
      );
}
