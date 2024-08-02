import 'dart:math';
import 'dart:ui';

final rand = Random.secure();

Color get randColor {
  double factor = rand.nextDouble();
  int red = _scale(factor, 0, 255);
  factor = rand.nextDouble();
  int green = _scale(factor, 0, 255);
  factor = rand.nextDouble();
  int blue = _scale(factor, 0, 255);
  return _makeColor(red, green, blue);
}

int _scale(double x, double s, double e) => (s + x * (e - s)).toInt();
Color _makeColor(
  int r,
  int g,
  int b, {
  double opacity = 1.0,
}) =>
    Color.fromRGBO(r, g, b, opacity);
