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

    dominoTest = createDomino();
    ballCage = createBallCage();
    background = new ParallaxComponent(dimensions, filenames);

    window.onPointerDataPacket = (packet) {
      var pointer = packet.data.first;
      input(pointer.physicalX, pointer.physicalY);
    };
  }

  DominoTest createDomino() {
    var demo = new DominoTest();
    demo.initialize();
    demo.initializeAnimation(dimensions);
    return demo;
  }

  BallCage createBallCage() {
    var demo = new BallCage();
    demo.initialize();
    demo.initializeAnimation(dimensions);
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
//    dominoTest.render(canvas);
    ballCage.render(canvas);
  }

  @override
  void update(double t) {
    if (!background.loaded) {
      return;
    }

    background.update(t);
    ballCage.update(t);
  }
}
