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
    // add(new GroundComponent(this));
    addAll(new DemoLevel(this).bodies);
    add(ninja = new NinjaComponent(this));
  }

  @override
  void update(t) {
    super.update(t);
    cameraFollow(ninja, horizontal: 0.4, vertical: 0.4);
  }

  void handleTap(Offset position) {
    ninja.stop();
  }

  Drag handleDrag(Offset position) {
    return ninja.handleDrag(position);
  }
}
