import 'package:flutter/material.dart';

class AboutUI extends StatelessWidget {
  const AboutUI({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          "Este aplicativo de biblioteca com integração à API Google Books "
          "e a uma API local foi desenvolvio em Flutter por Júlio Werner "
          "Zanatta Koepsel como trabalho final da disciplina Programação "
          "Dispositivos Móveis, do professor Me. Cristhian Heck, "
          "do Instituto Federal Catarinense - Campus Rio do Sul."
          "\n\n2023-12-17",
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
