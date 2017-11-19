import 'dart:ui';

import 'package:box2d/box2d.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

import 'custom_shape.dart';
import 'demo.dart';

class NinjaWorld extends Box2DComponent {
  Body ninja;

  static const num NINJA_RADIUS = 5.0;

  NinjaWorld(Size dimensions) : super(dimensions);

  void initializeWorld() {
    createGround();
    createNinja();
  }

  void createGround() {
    var height = 7.5;
    final shape = new PolygonShape();
    shape.setAsBoxXY(viewport.width(1.0), height);
    final fixtureDef = new FixtureDef();
    fixtureDef.shape = shape;
    fixtureDef.friction = 0.0;
    fixtureDef.restitution = 0.0;
//    fixtureDef.filter = new Filter()..maskBits = 0x000;
    final bodyDef = new BodyDef();
    bodyDef.position = new Vector2(0.0, viewport.alignBottom(height));
    Body groundBody = createBody(bodyDef, component: new GroundComponent());
    groundBody.createFixtureFromFixtureDef(fixtureDef);
  }

  void createNinja() {
    // Create a bouncing ball.
    final bouncingCircle = new CustomShape();
    bouncingCircle.radius = NINJA_RADIUS;
    bouncingCircle.p.x = 0.00001;

    // Create fixture for that ball shape.
    final activeFixtureDef = new FixtureDef();
    activeFixtureDef.restitution = 0.0;
    activeFixtureDef.density = 0.05;
    activeFixtureDef.shape = bouncingCircle;

    // Create the active ball body.
    final activeBodyDef = new BodyDef();
    activeBodyDef.linearVelocity = new Vector2(0.0, -20.0);
    activeBodyDef.position = new Vector2(15.0, 15.0);
    activeBodyDef.type = BodyType.DYNAMIC;
    activeBodyDef.bullet = true;
    ninja = createBody(activeBodyDef, component: new NinjaComponent());
    ninja.createFixtureFromFixtureDef(activeFixtureDef);
  }

  void input(double x, double y) {
    Vector2 currentForwardNormal = new Vector2(0.0, 5.0);
    ninja.applyForce(currentForwardNormal..scale(100.0), ninja.worldCenter);
  }
}

class GroundComponent extends BodyComponent {
  Image image;

  GroundComponent() {
    Flame.images.load("layers/layer_07.png").then((image) {
      this.image = image;
    });
  }

  @override
  void drawPolygon(Canvas canvas, List<Offset> points) {
    if (image == null) {
      return;
    }
    paintImage(
        canvas: canvas,
        image: image,
        rect: new Rect.fromPoints(points[0], points[2]),
        alignment: Alignment.bottomCenter,
        fit: BoxFit.cover);
  }
}

class NinjaComponent extends BodyComponent {
  Image image;

  NinjaComponent() {
    Flame.images.load("ninja.png").then((image) {
      this.image = image;
    });
  }

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    if (image == null) {
      return;
    }
    paintImage(
        canvas: canvas,
        image: image,
        rect: new Rect.fromCircle(center: center, radius: radius),
        fit: BoxFit.contain);
  }
}
