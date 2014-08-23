import 'dart:math';
import 'package:stagexl/stagexl.dart';
import 'star.dart';

class Starfield extends Sprite {
  final stars = <Star>[];

  Starfield(width, height) {
    graphics
      ..rect(0, 0, width, height)
      ..fillColor(Color.Black);
    generate();
  }

  void generate() {
    Random rand = new Random();
    int w = width.toInt();
    int h = height.toInt();
    for (int i = 0; i < 400; i++) {
      var star = new Star(rand.nextInt(w), rand.nextInt(h));
      addChild(star);
    }
  }
}