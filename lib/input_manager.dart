import 'package:stagexl/stagexl.dart';
import 'dart:async';

class InputManager {
  Stage stage;
  InputManager(this.stage) {
    stage.focus = stage;
  }

  Stream on(String key) {
    return stage.onKeyDown.where((KeyboardEvent ke) {
      return new String.fromCharCode(ke.keyCode).toUpperCase() == key.toUpperCase();
    });
  }
}