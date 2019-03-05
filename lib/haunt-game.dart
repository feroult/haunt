import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:haunt/ninja_world.dart';

class HauntGame extends Game {

  final NinjaWorld ninjaWorld = new NinjaWorld();

  HauntGame() {
    Flame.util.addGestureRecognizer(createDragRecognizer());
    Flame.util.addGestureRecognizer(createTapRecognizer());
    ninjaWorld.initializeWorld();
  }

  @override
  void render(Canvas canvas) {
    ninjaWorld.render(canvas);
  }

  @override
  void update(double t) {
    ninjaWorld.update(t);
  }

  @override
  void resize(Size size) {
    ninjaWorld.resize(size);
  }

  GestureRecognizer createDragRecognizer() {
    return new ImmediateMultiDragGestureRecognizer()
      ..onStart = (Offset position) => ninjaWorld.handleDrag(position);
  }

  TapGestureRecognizer createTapRecognizer() {
    return new TapGestureRecognizer()
      ..onTapUp = (TapUpDetails details) {
        ninjaWorld.handleTap(details.globalPosition);
      };
  }
}
