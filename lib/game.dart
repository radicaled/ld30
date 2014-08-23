import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'input_manager.dart';
import 'worlds/generator.dart';

class Game {
  Stage stage;
  CanvasElement canvas;
  InputManager inputManager;

  Game(this.canvas) {
    stage = new Stage(canvas);
    inputManager = new InputManager(stage);

    var renderLoop = new RenderLoop();

    renderLoop.addStage(stage);

//    var shape = new Shape();
//    shape.graphics.circle(100, 100, 60);
//    shape.graphics.fillColor(Color.Red);
//    stage.addChild(shape);

//    inputManager.on('A').listen((ke) => shape.x += 1);

    var world = new World(400, 400);
    world.generate();
    stage.addChild(world.bitmap);
  }
}
