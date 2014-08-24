import 'dart:math';
import 'package:stagexl/stagexl.dart';
import 'package:noise_algorithms/noise_algorithms.dart';
import '../color_utils.dart';
import '../ai.dart';

class World extends Sprite {
  int radius;
  Bitmap bitmap;
  BitmapData bd;

  bool talkingTrash = false;
  World(width, height) {
    bd = new BitmapData(width, height);
  }

  void say(String message) {
    if (talkingTrash) { return; }
    talkingTrash = true;

    var tf = new TextField(message)
      ..x = this.x
      ..y = max(0, this.y - 20)
      ..textColor = Color.Yellow
      ..width = 12 * message.length
      ..height = 12;
    var t = new Tween(tf, 2.0, TransitionFunction.linear)
      ..animate.alpha.to(0.0)
      ..delay = 1.0
      ..onComplete = () {
        talkingTrash = false;
        tf.removeFromParent();
    };
    this.stage.juggler.add(t);
    this.parent.addChild(tf);
  }

  void generate() {
    generateTerrain();
    angryAI(this);
    this.addChild(bitmap);
  }

  void generateTerrain() {
    Random _rand = new Random();
    var perlin = new Perlin2(_rand.nextInt(100));
    var circle = new Circle(bd.width / 2, bd.height / 2, bd.width / 2);

    var matrix = bd.renderTextureQuad.drawMatrix;
    var context = bd.renderTexture.canvas.context2D;
    context.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);

    var generator;

    var worldSeed = _rand.nextInt(100);

    if (worldSeed >= 90) {
      generator = WorldTypes.verdantWorld;
    } else if (worldSeed >= 70 && worldSeed < 90) {
      generator = WorldTypes.waterWorld;
    } else if (worldSeed >= 10 && worldSeed < 70) {
      generator = WorldTypes.desertWorld;
    } else if (worldSeed < 10) {
      generator = WorldTypes.volcanoWorld;
    }

    for(int x = 0; x < bd.width; x++) {
      for(int y = 0; y < bd.height; y++) {
        // Planets are circular.
        if (!circle.contains(x, y)) {
          context.fillStyle = "rgba(0,0,0,0)";
          context.clearRect(x, y, 1, 1);
          context.fillRect(x, y, 1, 1);

          //bd.setPixel32(x, y, Color.Transparent);
          continue;
        }

        double value = perlin.noise(x / 100, y / 100).abs();
        // value *= 256;
        // int val = value.toInt();
        // int pixel = (val << 24) + (val << 16) + (max(0, (25 - val) * 8) << 8) + 0;

        value *= 256;
        int val = value.toInt();

        var cs = generator(val);

        context.fillStyle = cs.rgbaString;
        context.clearRect(x, y, 1, 1);
        context.fillRect(x, y, 1, 1);

        //bd.setPixel(x, y, pixel);
      }
    }
    bd.renderTexture.update();
    bitmap = new Bitmap(bd);
  }
}

class WorldColors {
  static ColorStruct greenHills = new ColorStruct(81, 177, 81);
  static ColorStruct greenValleys = new ColorStruct(39, 87, 39);

  static ColorStruct shallowWater = new ColorStruct(78, 82, 255);
  static ColorStruct deepWater    = new ColorStruct(32, 34, 87);

  static ColorStruct deserts = new ColorStruct(135, 108, 60);
  static ColorStruct desertGulley = new ColorStruct(92, 62, 9);

  static ColorStruct shallowLava = new ColorStruct(177, 42, 6);
  static ColorStruct deepLava = new ColorStruct(88, 22, 4);

  static ColorStruct mountainBase = new ColorStruct(150, 75, 0);
  static ColorStruct mountainPeak = new ColorStruct(0, 0, 0);
}


class WorldColorPair {
  ColorStruct start;
  ColorStruct finish;
  WorldColorPair(this.start, this.finish);
}

class WorldColorPairs {
  static WorldColorPair hills   = new WorldColorPair(WorldColors.greenHills, WorldColors.greenValleys);
  static WorldColorPair rivers  = new WorldColorPair(WorldColors.shallowWater, WorldColors.deepWater);

  static WorldColorPair deserts = new WorldColorPair(WorldColors.deserts, WorldColors.desertGulley);
  static WorldColorPair mountains = new WorldColorPair(WorldColors.mountainBase, WorldColors.mountainPeak);

  static WorldColorPair lava = new WorldColorPair(WorldColors.shallowLava, WorldColors.deepLava);
}


class WorldTypes {
  static ColorStruct _calc(height, WorldColorPair belowSeaLevel, WorldColorPair aboveSeaLevel) {
    var r, g, b;
    var start;
    var finish;

    if (height >= 20) {
      start = aboveSeaLevel.start;
      finish = aboveSeaLevel.finish;
    } else { // River
      start = belowSeaLevel.start;
      finish = belowSeaLevel.finish;
    }
    r = max(finish.red, start.red - height);
    g = max(finish.green, start.green - height);
    b = max(finish.blue, start.blue - height);
    return new ColorStruct(r, g, b);
  }

  static ColorStruct verdantWorld(num height) {
    return _calc(height ~/ 2, WorldColorPairs.rivers, WorldColorPairs.hills);
  }

  static ColorStruct desertWorld(num height) {
    return _calc(height ~/ 3, WorldColorPairs.deserts, WorldColorPairs.mountains);
  }

  static ColorStruct waterWorld(num height) {
    return _calc(height ~/ 3, WorldColorPairs.rivers, WorldColorPairs.rivers);
  }

  static ColorStruct volcanoWorld(num height) {
    return _calc(height, WorldColorPairs.lava, WorldColorPairs.deserts);
  }
}
