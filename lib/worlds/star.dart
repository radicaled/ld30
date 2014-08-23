import 'dart:math';
import 'package:stagexl/stagexl.dart';

// I wrote this class because I might want to have each star "pulse"
// But I'm not sure it's the best idea... can the VM handle this many objects?
// TODO: ^^^^
class Star extends Sprite implements Animatable {
  double brightest;
  double darkest;
  bool twinkles = false;
  bool isDistantSun = false;

  Tween _tween;
  var _rand = new Random();

  Star(int x, int y) {
    this.x = x;
    this.y = y;
    this.isDistantSun = _rand.nextInt(100) > 90;
    this.twinkles = _rand.nextInt(100) > 60 || isDistantSun;


    generate();

    _tween = new Tween(this, 2.0, TransitionFunction.easeOutBounce);
  }

  void generate() {
    var a = _rand.nextInt(255) / 255, b = _rand.nextInt(255) / 255;
    brightest = max(a, b);
    darkest   = min(a, b);
    alpha = brightest;
    var color = Color.White;
    if (isDistantSun) {
      brightest = 1.0;
      darkest   = 0.8;
      color = Color.Yellow;
    }
//    if (twinkles == true) {
//      color = Color.HotPink;
//    }

    this.graphics
      ..rect(x, y, 1, 1)
      ..fillColor(color);
  }

  num lastTwinkle = 0.0;
  num lastTwinkleReset = 8.0;

  bool advanceTime(num time) {
    _tween.advanceTime(time);
    // Legit worst way to handle this scenario.
    // But I'm lazy and this is Ludum Dare.
    if (twinkles && _tween.isComplete) {
      _tween = new Tween(this, 2.0, TransitionFunction.linear);
      _tween.animate.alpha.to(brightest);
      _tween.delay = _rand.nextInt(5);
      _tween.onComplete = () {
        _tween = new Tween(this, 2.0, TransitionFunction.linear);
        _tween.animate.alpha.to(darkest);
        _tween.delay = 0.5;
      };
    }
    return true;
  }
}