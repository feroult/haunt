import 'dart:ui';

import 'package:flame/component.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'box2d/ninja_world.dart';

class HauntGame extends Game {
  Size dimensions;

  ParallaxComponent background;

  NinjaWorld ninjaWorld;

  HauntGame(this.dimensions) {
    var filenames = new List<String>();
    for (var i = 1; i <= 7; i++) {
      filenames.add("layers/layer_0${i}.png");
    }

    ninjaWorld = createNinjaWorld(dimensions);
    background = new ParallaxComponent(dimensions, filenames);

    addGestureRecognizer(createTapRecognizer());
  }

  TapGestureRecognizer createTapRecognizer() {
    return new TapGestureRecognizer()
      ..onTapUp = (TapUpDetails details) {
        print("tap: ${details.globalPosition}");
      };
  }

  NinjaWorld createNinjaWorld(Size dimensions) {
    var demo = new NinjaWorld(dimensions);
    demo.initializeWorld();
    return demo;
  }

  @override
  void render(Canvas canvas) {
    if (!background.loaded) {
      return;
    }
//    background.render(canvas);
    ninjaWorld.render(canvas);
  }

  @override
  void update(double t) {
    if (!background.loaded) {
      return;
    }

//    background.update(t);
    ninjaWorld.update(t);
  }
}

class HandleDrag extends Drag {
  static int counter = 0;
  int id = counter++;

  void update(DragUpdateDetails details) {
    print("drag update [${id}]: ${details.globalPosition}");
  }

  @override
  void cancel() {
    print("drag CANCELED [${id}]");
  }

  @override
  void end(DragEndDetails details) {
    print("drag end [${id}]: ${details.velocity}");
  }
}
