import 'package:flutter/material.dart';
import '/log/log_model.dart';
import '/log/log_list_model.dart';
import '../conexao/end_points.dart';

class LogUI extends StatefulWidget {
  const LogUI({super.key, required this.title});

  final String title;

  @override
  State<LogUI> createState() => _LogUI();
}

class _LogUI extends State<LogUI> {
  Future<LogListModel>? logListFuture;

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
          child: Expanded(
            child: FutureBuilder<LogListModel>(
                future: logListFuture,
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
                          if (snapshot.data!.logList != null) {
                            if (snapshot.data!.logList.length > 0) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.logList.length,
                                  itemBuilder: (context, index) {
                                    return generateColum(
                                        snapshot.data!.logList[index]);
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
                              "1. log Ocorreu um erro: ${snapshot.error}");
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
      ),
    );
  }

  @override
  void initState() {
    isConnected().then((internet) {
      if (internet) {
        setState(() {
          logListFuture = getLogListData();
        });
      }
    });
    super.initState();
  }

  Future<void> refreshData() async {
    isConnected().then((internet) {
      if (internet) {
        setState(() {
          logListFuture = getLogListData();
        });
      }
    });
    super.initState();
  }

  Widget generateColum(LogModel item) => Card(
        child: ListTile(
          title: Text(
            (item.dataHora != null ? "${item.dataHora!}: " : "") +
                (item.acao != null ? item.acao! : ""),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
              (item.idLivro != null ? "idLivro: ${item.idLivro!}\n" : "") +
                  (item.titulo != null ? "título: ${item.titulo!}" : ""),
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      );
}
