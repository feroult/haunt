import 'dart:ui';

import 'package:flame/component.dart';
import 'package:flame/game.dart';

import 'box2d/ball_cage.dart';
import 'box2d/domino_test.dart';

class HauntGame extends Game {
  Size dimensions;

  ParallaxComponent background;

  BallCage ballCage;
  DominoTest dominoTest;

  HauntGame(this.dimensions) {
    var filenames = new List<String>();
    for (var i = 1; i <= 7; i++) {
      filenames.add("layers/layer_0${i}.png");
    }

    dominoTest = createDomino(dimensions);
    ballCage = createBallCage(dimensions);
    background = new ParallaxComponent(dimensions, filenames);

    window.onPointerDataPacket = (packet) {
      var pointer = packet.data.first;
      input(pointer.physicalX, pointer.physicalY);
    };
  }

  DominoTest createDomino(Size dimensions) {
    var demo = new DominoTest(dimensions);
    demo.initializeWorld();
    return demo;
  }

  BallCage createBallCage(Size dimensions) {
    var demo = new BallCage(dimensions);
    demo.initializeWorld();
    return demo;
  }

  void input(double x, double y) {
    ballCage.input(x, y);
  }

  @override
  void render(Canvas canvas) {
    if (!background.loaded) {
      return;
    }
    background.render(canvas);
    ballCage.render(canvas);
//    dominoTest.render(canvas);
  }

  @override
  void update(double t) {
    if (!background.loaded) {
      return;
    }

    background.update(t);
    ballCage.update(t);
//    dominoTest.update(t);
  }
}
