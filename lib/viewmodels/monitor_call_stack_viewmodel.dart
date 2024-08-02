import 'package:flutter/cupertino.dart';
import 'package:mobile_monitor/models/one_call_bean.dart';

final class MonitorCallStackViewModel extends ChangeNotifier {
  final oneCallBeans = <OneCallBean>[];

  void push(OneCallBean bean) {
    oneCallBeans.insert(
      0,
      bean,
    );
    notifyListeners();
  }

  void pop() {
    if (oneCallBeans.isNotEmpty) {
      oneCallBeans.removeAt(0);
    }
  }

  void addAll(Iterable<OneCallBean> beans) {
    oneCallBeans.addAll(beans);
  }

  void load(Iterable<OneCallBean> beans) {
    clear();
    addAll(beans);
  }

  void clear() {
    oneCallBeans.clear();
  }
}
