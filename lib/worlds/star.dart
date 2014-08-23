import 'dart:math';
import 'package:stagexl/stagexl.dart';

// I wrote this class because I might want to have each star "pulse"
// But I'm not sure it's the best idea... can the VM handle this many objects?
// TODO: ^^^^
class Star extends Sprite {
  double brightness;

  Star(int x, int y) {
    this.x = x;
    this.y = y;
    generate();
  }

  void generate() {
    brightness = new Random().nextInt(255) / 255;
    alpha = brightness;
    var color = Color.White;

    this.graphics
      ..rect(x, y, 1, 1)
      ..fillColor(color);
  }
}