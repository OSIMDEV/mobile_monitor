import 'package:dart_mq/dart_mq.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:server_nano/server_nano.dart';

import 'apis.dart';

class LocalServer with ProducerMixin {
  static const defIP = '127.0.0.1';
  static const defPort = 8000;

  String _wifiIP = defIP;
  bool _isStarted = false;

  final Server _server;

  LocalServer() : _server = Server();

  String get wifiIP => _wifiIP;

  Future<String> _queryWifiIP() async {
    final info = NetworkInfo();
    return await info.getWifiIP() ?? defIP;
  }

  Future<void> start() async {
    if (!_isStarted) {
      _server.post(monitorCallStack, (req, res) async {
        final payload = await req.payload() ?? {};
        sendMessage(routingKey: monitorCallStack, payload: payload);
        await res.status(200).sendJson({'status': 'ok'});
      });
      _wifiIP = await _queryWifiIP();
      _server.listen(port: defPort);
      _isStarted = true;
    }
  }

  void stop() {
    if (_isStarted) {
      _server.stop();
      _isStarted = false;
    }
  }
}
