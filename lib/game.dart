import 'dart:math';
import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'input_manager.dart';
import 'game_state.dart';
import 'worlds/world.dart';
import 'worlds/starfield.dart';

class Game {
  Stage stage;
  CanvasElement canvas;
  InputManager inputManager;
  ResourceManager rm;
  GameState gs;

  Game(this.canvas) {
    stage = new Stage(canvas);
    inputManager = new InputManager(stage);
    gs = new GameState(stage);
    rm = new ResourceManager();

    rm.addSound('game', 'packages/ld30/music/game_music.wave');

    rm.load().then((rm) {
      rm.getSound('game').play(true);
    });

    RenderLoop renderLoop = new RenderLoop();

    renderLoop.addStage(stage);


    var starfield = new Starfield(800, 600);
    stage.addChild(starfield);
    renderLoop.juggler.addGroup(starfield.stars);

    var rand = new Random();
    num width = 60;
    num height = 60;

    // Seed a bunch of possible locations for planets.
    var points = new Set();
    for(int i = 0; i < 10000; i++) {
      points.add(new Point(rand.nextInt(700), rand.nextInt(500)));
    }

    // Remove any locations that intersect.
    var acceptablePoints = [];
    while(true) {
      if (points.length == 0) { break; }
      var point = points.first;
      var radius = width * 2;
      var circle = new Circle(point.x, point.y, radius);
      acceptablePoints.add(point);

      // Will always remove itself.
      points.removeWhere((p) => circle.containsPoint(p));
    }


    var worldCount = 10;
    var friendlyWorld = rand.nextInt(worldCount + 1);
    var i = 0;
    acceptablePoints.take(worldCount).forEach((point) {
      var world = new World(400, 400);
      if (i == friendlyWorld) { world.isFriendly = true; }
      world.generate();

      world
        ..x = point.y
        ..y = point.x
        ..width = width
        ..height = height;
      stage.addChild(world);
      i++;
    });

    gs.start();
  }
}
