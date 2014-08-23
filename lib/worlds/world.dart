import 'dart:math';
import 'package:stagexl/stagexl.dart';
import 'package:noise_algorithms/noise_algorithms.dart';

class World {
  int width;
  int height;

  Bitmap bitmap;
  BitmapData bd;

  World(this.width, this.height) {
    bd = new BitmapData(width, height);
  }

  void generate() {
    generateTerrain();
  }

  void generateTerrain() {
    Random rand = new Random();
    var perlin = new Perlin2(rand.nextInt(100));
    var circle = new Circle(width / 2, height / 2, width / 2);

    var matrix = bd.renderTextureQuad.drawMatrix;
    var context = bd.renderTexture.canvas.context2D;
    context.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);

    for(int x = 0; x < width; x++) {
      for(int y = 0; y < height; y++) {
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

        var hills = Color.White;
        var oceans = Color.Gray;

        int pixel = 0;

        var toRgb = (color) {
          var r = color >> 16 & 0xFF;
          var g = color >> 8 & 0xFF;
          var b = color & 0xFF;
          return [r, g, b];
        };

        var fromRgb = (r, g, b) {
          var rgb = (r << 16) + (g << 8) + (b);
          return rgb;
        };

        var red;
        var green;
        var blue;

        // if (val <= 128) {
        //   green = 128 - val;
        //   red = 255 - green;
        //   blue = 0;
        // } else {
        //   red = 0;
        //   blue = 255 - val;
        //   green = 255 - blue;
        // }

        if (val >= 20) {
          // RGB(81, 177, 81)
          // RGB(39, 87, 39)
          red = max(39, 81 - val);
          green = max(32, 177 - val);
          blue = max(39, 81 - val);
        } else { // River
          // RGB(78, 82, 255) -- max
          // RGB(32, 34, 87) -- min
          red = max(32, 78 - val);
          green = max(34, 82 - val);
          blue = max(87, 255 - val);
        }

        // if (val <= 128) {
        //   green = 128 - val;
        //   blue = 255 - green;
        //   red = 0;
        // } else {
        //   blue = 0;
        //   red = 128 - val;
        //   green = 128 - blue;
        // }

        pixel = val;

        pixel = fromRgb(red, green, blue);

        // if (value > 0.5) {
        //   pixel = colorize(hills, hills);
        // } else {
        //   pixel = colorize(oceans, oceans);
        // }
        // int val = value.toInt();
        // int pixel = val;
        // pixel += (val << 24) + (val << 16);
        // pixel += (max(0, (25 - val) * 8) << 8) + 0;

        context.fillStyle = "rgba($red,$green,$blue,1.0)";
        context.clearRect(x, y, 1, 1);
        context.fillRect(x, y, 1, 1);

        //bd.setPixel(x, y, pixel);
      }
    }
    bd.renderTexture.update();
    bitmap = new Bitmap(bd);
  }
}
