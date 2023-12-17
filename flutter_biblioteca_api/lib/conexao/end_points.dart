import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import '/book/book_model.dart';
import '/book/book_list_model.dart';
import '/log/log_model.dart';
import '/log/log_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

const String _noValueGiven = "";

String book = "https://www.googleapis.com/books/v1/volumes/";
String books = "https://www.googleapis.com/books/v1/volumes?q=";
String logGet = "http://192.168.0.112:80/tests/apiflutter/list.php";
String logPost = "http://192.168.0.112:80/tests/apiflutter/log.php";

Future<BookListModel> getBookListData(String? busca) async {
  if (busca != null) {
    final response = await http.get(
      //final uri = new Uri.http(config['API_ENDPOINT'], '/search', {"query": queryToSearch});
      Uri.parse(books + busca),
    );
    return BookListModel.fromJson(json.decode(response.body));
  } else {
    return BookListModel();
  }
}

Future<BookModel> getBookData(String? busca) async {
  if (busca != null) {
    final response = await http.get(
      //final uri = new Uri.http(config['API_ENDPOINT'], '/search', {"query": queryToSearch});
      Uri.parse(book + busca),
    );
    return BookModel.fromJson(json.decode(response.body));
  } else {
    return BookModel();
  }
}

Future<LogListModel> getLogListData([String id = _noValueGiven]) async {
  await Future.delayed(const Duration(seconds: 2), () {});
  http.Response response;
  if (identical(id, _noValueGiven)) {
    response = await http.get(
      Uri.parse(logGet),
    );
  } else {
    response = await http.get(
      Uri.parse(logGet).replace(queryParameters: {'id_livro': id}),
    );
  }
  return LogListModel.fromJson(json.decode(response.body));
}

Future<http.Response> createPost(LogModel log, String url) async {
  print("asdf ${jsonEncode(log)}");
  //Map<String, dynamic> data = new Map<String, dynamic>();
  //data['data'] = log;
  final response = await http.post(Uri.parse(logPost),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: ''
      },
      body: "[${jsonEncode(log)}]");
  print("321 ${jsonEncode(log)}");
  return response;
}

LogListModel postFromJson(String str) {
  final jsonData = json.decode(str);
  return LogListModel.fromJson(jsonData);
}

Future<LogListModel> callAPI(LogModel log) async {
  //LogListModel logs = await getLogListData();
  //LogModel log = LogModel(acao: "ADICIONOU", idLivro: "AZAZ", titulo: "Livro");
  print(log.toJson());
  //BookListModel.fromJson(json.decode(response.body));
  createPost(log, logPost).then((response) {
    print(response.body);
    if (response.statusCode == 200) {
      print("1. ${response.body}");
      /*print("gfff " +
          LogListModel.fromJson(json.decode(response.body))
              .logList
              .first
              .model);*/
      return LogListModel.fromJson(json.decode(response.body));
    } else {
      print("2. ${response.statusCode}");
      return response.statusCode.toString();
    }
  }).catchError((error) {
    print('erros : $error');
    return error.toString();
  });
  throw "Erro 1";
}

Future<void> postLog(LogModel log) async {
  var url = Uri.parse(logPost);
  var request = http.MultipartRequest('POST', url)
    ..fields['id_livro'] = log.idLivro!
    ..fields['acao'] = log.acao!
    ..fields['titulo'] = log.titulo != null ? log.titulo! : ""
    ..fields['data_hora'] = log.dataHora!;
  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Request successful');
      print(await response.stream.bytesToString());
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (error) {
    print('Error sending request: $error');
  }
}

/*
Future<LogListModel> postLog(String acao, String idLivro, String titulo) async {
  LogModel log = LogModel(acao: acao, idLivro: idLivro, titulo: titulo);
  final response = await http.post(logPost, body: json.encode([log.toJson()]));
  print("3. " + response.toString());
  return LogListModel.fromJson(json.decode(response.body));
}*/

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

Widget loadingView(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
      color: Theme.of(context).primaryColor,
      //backgroundColor: Colors.grey,
    ),
  );
}

Widget noDataView(String msg) => Center(
      child: Text(
        msg,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
    );
