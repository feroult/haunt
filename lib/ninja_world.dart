import 'dart:ui';

import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'characters/ninja.dart';
import 'levels/demo.dart';

class NinjaWorld extends Box2DComponent {
  NinjaComponent ninja;

  NinjaWorld() : super(scale: 4.0);

  void initializeWorld() {
    // add(GroundComponent(this));
    addAll(DemoLevel(this).bodies);
    add(ninja = NinjaComponent(this));
  }

  @override
  void update(t) {
    super.update(t);
    cameraFollow(ninja, horizontal: 0.4, vertical: 0.4);
  }

  void handleTap(Offset position) {
    ninja.stop();
  }

  void handleDragUpdate(DragUpdateDetails details) {
    ninja.handleDragUpdate(details);
  }

  void handleDragEnd(DragEndDetails details) {
    ninja.handleDragEnd(details);
  }
}
