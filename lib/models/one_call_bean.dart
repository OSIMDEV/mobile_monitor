import 'dart:convert';
import 'dart:ui';

import 'package:mobile_monitor/utils/color_utils.dart';

final class OneCallBean {
  static List<OneCallBean> fromJsonL(Map map) {
    final ret = <OneCallBean>[];
    try {
      ret.addAll([
        ...(jsonDecode(map['names']).map((e) {
          return OneCallBean(
            name: e,
            color: randColor,
          );
        }))
      ]);
    } catch (e) {}
    return ret;
  }

  factory OneCallBean.fromJson(Map map) {
    String name = '';
    try {
      name = map['name'];
    } catch (e) {}
    return OneCallBean(name: name, color: randColor);
  }

  OneCallBean({
    required this.name,
    required this.color,
  });

  String name;
  Color color;
}
