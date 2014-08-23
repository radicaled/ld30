import 'dart:math';
import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'input_manager.dart';
import 'worlds/generator.dart';
import 'worlds/starfield.dart';

class Game {
  Stage stage;
  CanvasElement canvas;
  InputManager inputManager;

  Game(this.canvas) {
    stage = new Stage(canvas);
    inputManager = new InputManager(stage);

    RenderLoop renderLoop = new RenderLoop();

    renderLoop.addStage(stage);


    var starfield = new Starfield(800, 600);
    stage.addChild(starfield);
    renderLoop.juggler.addGroup(starfield.stars);

    int areaX = 0; int areaY = 0;
    var width = 60; var height = 60;
    var rand = new Random();
    var areaInc = 200;
    for(int i = 0; i < 10; i++) {
      var world = new World(400, 400);
      world.generate();

      // World has an area of 100 x 100
      // World cannot be within 20 of area border
      var x = rand.nextInt(80) + 20;
      var y = rand.nextInt(80) + 20;

      world.bitmap
        ..x = areaX + x
        ..y = areaY + y
        ..width = width
        ..height = height;
      stage.addChild(world.bitmap);

      areaX += areaInc;
      if (areaX > areaInc * 6) {
        areaX = 0;
        areaY = areaInc;
      }
    }
  }
}
