import 'dart:math';
import 'package:stagexl/stagexl.dart';

// I wrote this class because I might want to have each star "pulse"
// But I'm not sure it's the best idea... can the VM handle this many objects?
// TODO: ^^^^
class Star extends Sprite implements Animatable {
  double brightest;
  double darkest;

  Tween _tween;
  var _rand = new Random();

  Star(int x, int y) {
    this.x = x;
    this.y = y;
    generate();

    targetValue = [brightest, darkest][_rand.nextInt(1)];
    twinkleStep = _rand.nextInt(555) * 0.001;

    _tween = new Tween(this, 2.0, TransitionFunction.easeOutBounce);
    _tween.animate.alpha.by(1.0);
    _tween.delay = 10.0;
    _tween.onComplete = () => _tween.animate.alpha.by(0.0);
  }

  void generate() {
    var a = _rand.nextInt(255) / 255, b = _rand.nextInt(255) / 255;
    brightest = max(a, b);
    darkest   = min(a, b);
    alpha = brightest;
    var color = Color.White;

    this.graphics
      ..rect(x, y, 1, 1)
      ..fillColor(color);
  }
  double targetValue = 1.0;
  double twinkleStep = 5.0; // 0.1

  bool advanceTime(num time) {
    var inc = (twinkleStep * time);
    if (alpha >= targetValue) {
      if (alpha >= brightest) { targetValue = darkest; } else { targetValue = brightest; }
    }

    if (alpha >= targetValue) {
      alpha = alpha - inc;
    } else {
      alpha = alpha + inc;
    }
    return true;
  }
}