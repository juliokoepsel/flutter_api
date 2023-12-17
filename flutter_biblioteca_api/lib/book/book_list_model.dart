import 'book_model.dart';

class BookListModel {
  List<BookModel>? bookList;

  BookListModel({this.bookList});

  BookListModel.fromJson(Map<String, dynamic> parsedJson) {
    bookList = [];
    for (var v in parsedJson['items']) {
      bookList!.add(BookModel.fromJson(v));
    }
  }
}
