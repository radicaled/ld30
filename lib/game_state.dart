import 'dart:math';
import 'package:stagexl/stagexl.dart';
import 'ai.dart';

class GameState {
  int maxAttempts = 3;
  int currentAttempts = 0;
  Stage stage;

  TextField attemptText;
  Sprite winSprite = new Sprite();
  Sprite lossSprite = new Sprite();

  GameState(this.stage) {
    attemptText = new TextField('')
      ..x = 10
      ..y = 10
      ..width = 300
      ..height = 16
      ..textColor = Color.White;

    lossSprite.graphics
      ..rect(0, 0, 800, 600)
      ..fillColor(Color.Black);

    winSprite.graphics
      ..rect(0, 0, 800, 600)
      ..fillColor(Color.Black);


    updateStatus();
  }

  void start() {
    stage.addChild(attemptText);
    WorldAI.stream.listen((event) {
      switch(event) {
        case 'AI_ANGRY':
          currentAttempts += 1;
          if (currentAttempts >= maxAttempts) {
            loss();
          } else {
            updateStatus();
          }
          break;
        case 'AI_FRIENDLY':
          win();
          break;
      }
    });
  }

  void win() {
    var tf = new TextField('You won!', new TextFormat('Arial', 30, Color.White))
        ..x = (800 ~/ 2) - 100
        ..y = (600 ~/ 2) - 100
        ..width = 600
        ..height = 300;


    winSprite.addChild(tf);
    stage.addChild(winSprite);
  }

  void loss() {
    var tf = new TextField('You lost!', new TextFormat('Arial', 30, Color.White))
          ..x = (800 ~/ 2) - 100
          ..y = (600 ~/ 2) - 100
          ..width = 600
          ..height = 300;


    lossSprite.addChild(tf);
    stage.addChild(lossSprite);
  }

  void updateStatus() {
    attemptText.text = 'You have ${maxAttempts - currentAttempts} attempts remaining!';
  }

  void reset() {
    currentAttempts = 0;
  }
}