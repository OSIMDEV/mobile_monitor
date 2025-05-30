import 'dart:convert';

class Log {
  factory Log.from(Object payload) =>
      Log.fromMap(payload as Map<dynamic, dynamic>);

  factory Log.fromJson(String json) =>
      Log.fromMap(jsonDecode(json) as Map<dynamic, dynamic>);

  factory Log.fromMap(Map<dynamic, dynamic> map) =>
      Log._(map['timestamp'] as String, map['log'] as String);

  Log._(this.timestamp, this.log);

  Map<dynamic, dynamic> toMap() => {'timestamp': timestamp, 'log': log};

  String toJson() => jsonEncode(toMap());

  final String timestamp;
  final String log;
}
