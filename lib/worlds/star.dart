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
    brightness = new Random().nextInt(100) / 100;
    this.graphics
      ..rect(x, y, 1, 1)
      ..fillColor(Color.White);
  }
}