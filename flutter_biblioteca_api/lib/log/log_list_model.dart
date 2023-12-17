import 'log_model.dart';

class LogListModel {
  List<LogModel>? logList;

  LogListModel({this.logList});

  LogListModel.fromJson(List<dynamic> parsedJson) {
    logList = [];
    for (var v in parsedJson) {
      logList!.add(LogModel.fromJson(v));
    }
  }
}
