import 'dart:io';

import 'package:flutter/material.dart';
import '/book/book_list_ui.dart';
import 'book/add_ui.dart';
import '/log/log_ui.dart';
import '/about/about_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = CustomHttpOverrides();
  runApp(const MyApp());
}

late String selectedBookId;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Biblioteca API',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/list',
      routes: {
        '/list': (context) => const BookListUI(title: 'Lista de Livros'),
        '/add': (context) => const AddUI(title: 'Procurar Livros'),
        '/log': (context) => const LogUI(title: 'Log de Ações'),
        '/about': (context) => const AboutUI(title: 'Sobre'),
      },
    );
  }
}

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
