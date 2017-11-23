import 'dart:ui';

import 'package:flame/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:haunt/ninja_world.dart';

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

//    addGestureRecognizer(createTapRecognizer());
    Flame.util.addGestureRecognizer(createDragRecognizer());
  }

  TapGestureRecognizer createTapRecognizer() {
    return new TapGestureRecognizer()
      ..onTapUp = (TapUpDetails details) {
        ninjaWorld.input(details.globalPosition);
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

  GestureRecognizer createDragRecognizer() {
    return new ImmediateMultiDragGestureRecognizer()
      ..onStart = (Offset position) => ninjaWorld.handleDrag(position);
  }
}
