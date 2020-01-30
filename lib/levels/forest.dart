import 'dart:math';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/box2d/viewport.dart';
import 'package:flame/components/parallax_component.dart';
import 'package:flutter/painting.dart';


class BackgroundComponent extends ParallaxComponent {
  Viewport viewport;

  BackgroundComponent(this.viewport) {
    _loadImages();
  }

  void _loadImages() {
    var filenames = List<String>();
    for (var i = 1; i <= 6; i++) {
      filenames.add("layers/layer_0$i.png");
    }
    load(filenames);
  }

  @override
  void update(double t) {
    if (!loaded()) {
      return;
    }

    for (var i = 1; i <= 6; i++) {
      if (i <= 2) {
        updateScroll(i - 1, 0.5);
        continue;
      }
      int screens = pow(8 - i, 3);
      var scroll = viewport.getCenterHorizontalScreenPercentage(
          screens: screens.toDouble());
      updateScroll(i - 1, scroll);
    }
  }
}

class GroundComponent extends BodyComponent {
  static const HEIGHT = 6.20;

  ParallaxRenderer parallax;

  GroundComponent(Box2DComponent box) : super(box) {
    this.parallax = ParallaxRenderer("layers/layer_07_cropped.png");
    _createBody();
  }

  void _createBody() {
    final shape = PolygonShape();
    shape.setAsBoxXY(100000.0, HEIGHT);
    final fixtureDef = FixtureDef();
    fixtureDef.shape = shape;

    fixtureDef.restitution = 0.0;
    fixtureDef.friction = 0.2;
    final bodyDef = BodyDef();
    bodyDef.position = Vector2(0.0, -16.0);
    Body groundBody = world.createBody(bodyDef);
    groundBody.createFixtureFromFixtureDef(fixtureDef);
    this.body = groundBody;
  }

  @override
  void update(double t) {
    if (!parallax.loaded()) {
      return;
    }

    // TODO: abstract this
    var screens =
        parallax.image.width / viewport.size.width / window.devicePixelRatio;

    parallax.scroll =
        viewport.getCenterHorizontalScreenPercentage(screens: screens);
  }

  @override
  void renderPolygon(Canvas canvas, List<Offset> points) {
    if (!parallax.loaded()) {
      return;
    }

    var left = 0.0;
    var top = points[2].dy;
    var right = viewport.size.width;
    var bottom = points[0].dy;
    var rect = Rect.fromLTRB(left, top, right, bottom);
    parallax.render(canvas, rect);
  }
}
