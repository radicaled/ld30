import 'dart:math';
import 'worlds/world.dart';

class WorldAI {
  final messages = <String>[];
  World world;
  WorldAI(this.world) {
    listen();
  }

  void listen() {
    Random r = new Random();
    world.onMouseClick.listen((me) {
      world.say(messages[r.nextInt(messages.length)]);
    });
  }
}

class WorldAIBuilder {
  WorldAI ai;
  World world;

  WorldAIBuilder(this.world) {
    ai = new WorldAI(world);
  }

  void message(String msg) => ai.messages.add(msg);
}

var angryAI = (world) {
  var builder = new WorldAIBuilder(world)
    ..message('You looking for a fight, mate?!')
    ..message('Enjoying yourself, yeah?')
    ..message('You bloody chav! Keep clicking!');

  return builder;
};