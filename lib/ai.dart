import 'dart:math';
import 'dart:async';
import 'worlds/world.dart';

class WorldAI {
  final messages = <String>[];
  static StreamController<String> _sc = new StreamController();
  static Stream<String> stream = _sc.stream;

  bool winner = false;

  World world;
  WorldAI(this.world) {
    listen();
  }

  void listen() {
    Random r = new Random();
    world.onMouseClick.listen((me) {
      world.say(messages[r.nextInt(messages.length)]);
      if (winner) {
        _sc.add('AI_FRIENDLY');
      } else {
        _sc.add('AI_ANGRY');
      }
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
  set winner(val) => ai.winner = val;
}

var angryAI = (world) {
  return new WorldAIBuilder(world)
    ..message('You looking for a fight, mate?!')
    ..message('Enjoying yourself, yeah?')
    ..message('You bloody chav! Keep clicking!');
};

var friendlyAI = (world) {
  return new WorldAIBuilder(world)
    ..message('You found me, champ!')
    ..message('Good job, guy!')
    ..message('Alright, fellah! I knew you could do it!')
    ..winner = true;
};