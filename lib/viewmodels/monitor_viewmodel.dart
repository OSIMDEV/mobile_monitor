import 'package:flutter/cupertino.dart';
import 'package:mobile_monitor/models/Log.dart';
import 'package:mobile_monitor/services/monitor_service.dart';

class MonitorViewmodel extends ChangeNotifier {
  MonitorViewmodel(this._service) {
    _service.addListener((log) => add(log));
  }

  final MonitorService _service;

  String get ip => _service.ip;

  List<Log> _logs = [];

  List<Log> get logs => _logs;

  void add(Log log) {
    _logs = [log, ..._logs];
    notifyListeners();
  }

  @override
  void dispose() {
    _service.removeListener(add);
    super.dispose();
  }
}
