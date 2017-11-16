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

  @override
  void render(Canvas canvas) {
    background.render(canvas);
//    dominoTest.render(canvas);
    ballCage.render(canvas);
  }

  @override
  void update(double t) {
    background.update(t);
  }
}
