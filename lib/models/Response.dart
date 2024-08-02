import 'package:dart_mq/dart_mq.dart';
import 'package:mobile_monitor/models/one_call_bean.dart';

final class Response {
  factory Response.from(Message payload) {
    final p = payload.payload;
    OperationType type = OperationType.none;
    Response? response;
    try {
      final map = p as Map;
      type = OperationType.op(map['type']);
      response = Response(type: type);
      if (OperationType.push == type) {
        final oneCallBean = OneCallBean.fromJson(map);
        if ('' != oneCallBean.name) {
          response.value.add(oneCallBean);
        }
      } else if (OperationType.addAll == type || OperationType.load == type) {
        final oneCallBeans = OneCallBean.fromJsonL(map).where(
          (element) => '' != element.name,
        );
        if (oneCallBeans.isNotEmpty) {
          response.value.addAll(oneCallBeans);
        }
      } else if (OperationType.showToast == type) {
        response.extra = map['info'];
      }
    } catch (e) {}
    return response ?? Response(type: OperationType.none);
  }

  Response({
    required this.type,
  });

  OperationType type;
  List<OneCallBean> value = [];
  Object? extra;
}

enum OperationType {
  push,
  pop,
  addAll,
  clear,
  load,
  showToast,
  none;

  static op(String name) => switch (name) {
        'push' => push,
        'pop' => pop,
        'addAll' => addAll,
        'clear' => clear,
        'load' => load,
        'showToast' => showToast,
        _ => none,
      };
}
