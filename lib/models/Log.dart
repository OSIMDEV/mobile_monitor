import 'dart:convert';

import 'package:dart_mq/dart_mq.dart';

class Log {
  factory Log.from(Message payload) =>
      Log.fromMap(payload as Map<String, dynamic>);

  factory Log.fromJson(String json) =>
      Log.fromMap(jsonDecode(json) as Map<String, dynamic>);

  factory Log.fromMap(Map<String, dynamic> map) =>
      Log._(map['timestamp'] as String, map['log'] as String);

  Log._(this.timestamp, this.log);

  Map<String, dynamic> toMap() => {timestamp: timestamp, log: log};

  String toJson() => jsonEncode(toMap());

  final String timestamp;
  final String log;
}
