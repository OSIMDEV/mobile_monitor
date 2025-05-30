import 'dart:async';

import 'package:dart_mq/dart_mq.dart';
import 'package:mobile_monitor/models/Log.dart';
import 'package:mobile_monitor/services/apis.dart';
import 'package:mobile_monitor/services/local_server.dart';

typedef MonitorServiceLogListener = void Function(Log);

class MonitorService with ConsumerMixin {
  MonitorService() {
    MQClient.initialize();
    MQClient.instance.declareQueue(monitorLog);
    _sController = StreamController<Log>.broadcast();
    _subscription = _sController.stream.listen(_onListen);
    subscribe(
      queueId: monitorLog,
      callback: (payload) {
        _sController.sink.add(Log.from(payload.payload));
      },
    );
  }

  Future<void> init() => _server.start();

  void addListener(MonitorServiceLogListener listener) {
    if (!_logListeners.contains(listener)) {
      _logListeners.add(listener);
    }
  }

  void removeListener(MonitorServiceLogListener listener) =>
      _logListeners.remove(listener);

  StreamSubscription<Log>? _subscription;

  late StreamController<Log> _sController;

  final LocalServer _server = LocalServer();

  String get ip => _server.wifiIP;

  final _logListeners = <MonitorServiceLogListener>[];

  void _onListen(Log log) {
    for (final listener in _logListeners) {
      listener(log);
    }
  }

  void dispose() {
    _logListeners.clear();
    _subscription?.cancel();
    _sController.close();
    unsubscribe(queueId: monitorLog);
    MQClient.instance.deleteQueue(monitorLog);
    MQClient.instance.close();
    _server.stop();
  }
}
