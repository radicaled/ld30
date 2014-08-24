import 'dart:math';
import 'package:stagexl/stagexl.dart';
import 'ai.dart';
import 'game.dart';

class GameState {
  int maxAttempts = 3;
  int currentAttempts = 0;
  Stage stage;

  TextField attemptText;
  Sprite winSprite = new Sprite();
  Sprite lossSprite = new Sprite();
  Sprite resetButton = new Sprite();

  GameState(this.stage) {
    attemptText = new TextField('')
      ..x = 10
      ..y = 10
      ..width = 300
      ..height = 16
      ..textColor = Color.White;

    var resetText = new TextField('Reset?');
    resetButton
            ..x = 800 ~/ 2
            ..y = 600 ~/ 2;
    resetButton.graphics
            ..rect(0, 0, 60, 60)
            ..fillColor(Color.Yellow);

    resetButton.onMouseClick.listen((me) {
      reset();
    });

    resetButton.addChild(resetText);



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

    winSprite.graphics
      ..clear()
      ..rect(0, 0, 800, 600)
      ..fillColor(Color.Black);

    winSprite.addChild(tf);
    winSprite.addChild(resetButton);
    stage.addChild(winSprite);
  }

  void loss() {
    var tf = new TextField('You lost!', new TextFormat('Arial', 30, Color.White))
          ..x = (800 ~/ 2) - 100
          ..y = (600 ~/ 2) - 100
          ..width = 600
          ..height = 300;

    lossSprite.graphics
          ..clear()
          ..rect(0, 0, 800, 600)
          ..fillColor(Color.Black);

    lossSprite.addChild(tf);
    lossSprite.addChild(resetButton);
    stage.addChild(lossSprite);
  }

  void updateStatus() {
    attemptText.text = 'You have ${maxAttempts - currentAttempts} attempts remaining!';
  }

  void reset() {
    Game.current.generateWorlds();
    currentAttempts = 0;
    winSprite.removeFromParent();
    lossSprite.removeFromParent();
    updateStatus();
  }
}