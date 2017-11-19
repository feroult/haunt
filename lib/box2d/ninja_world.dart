import 'dart:ui';

import 'package:box2d/box2d.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

import 'box2d_component.dart';

class NinjaWorld extends Box2DComponent {
  NinjaComponent ninja;

  NinjaWorld(Size dimensions) : super(dimensions);

  void initializeWorld() {
    add(new GroundComponent(this));
    add(ninja = new NinjaComponent(this));
  }

  void input(double x, double y) {
    ninja.input(x, y);
  }

  @override
  void update(t) {
    super.update(t);
    _followNinja();
  }

  void _followNinja() {
    Vector2 temp = new Vector2.zero();
    var position = ninja.getPosition();
    viewport.getWorldToScreen(position, temp);

    var margin = 0.25 * dimensions.width / 2;

    if (temp.x < dimensions.width / 2 - margin) {
      viewport.setCamera(
          dimensions.width / 2 + (position.x * viewport.scale) + margin,
          viewport.center.y,
          viewport.scale);
    }

    if (temp.x > dimensions.width / 2 + margin) {
      viewport.setCamera(
          dimensions.width / 2 + (position.x * viewport.scale) - margin,
          viewport.center.y,
          viewport.scale);
    }
  }
}

class GroundComponent extends BodyComponent {
  static final HEIGHT = 7.5;

  Image image;

  GroundComponent(box) : super(box) {
    _loadImage();
    _createBody();
  }

  void _loadImage() {
    Flame.images.load("layers/layer_07.png").then((image) {
      this.image = image;
    });
  }

  void _createBody() {
    final shape = new PolygonShape();
    shape.setAsBoxXY(viewport.width(1.0), HEIGHT);
    final fixtureDef = new FixtureDef();
    fixtureDef.shape = shape;
    fixtureDef.restitution = 0.0;
    fixtureDef.friction = 0.2;
    final bodyDef = new BodyDef();
    bodyDef.position = new Vector2(0.0, viewport.alignBottom(HEIGHT));
    Body groundBody = world.createBody(bodyDef);
    groundBody.createFixtureFromFixtureDef(fixtureDef);
    this.body = groundBody;
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
  static const num NINJA_RADIUS = 5.0;

  Image image;

  NinjaComponent(box2d) : super(box2d) {
    _loadImage();
    _createBody();
  }

  void _loadImage() {
    Flame.images.load("ninja.png").then((image) {
      this.image = image;
    });
  }

  @override
  void update(double t) {
    body.angularVelocity *= 0.9;
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

  void _createBody() {
    final shape = new CircleShape();
    shape.radius = NinjaComponent.NINJA_RADIUS;
    shape.p.x = 0.0;

    final activeFixtureDef = new FixtureDef();
    activeFixtureDef.shape = shape;
    activeFixtureDef.restitution = 0.0;
    activeFixtureDef.density = 0.05;
    activeFixtureDef.friction = 0.2;
    FixtureDef fixtureDef = activeFixtureDef;
    final activeBodyDef = new BodyDef();
    activeBodyDef.linearVelocity = new Vector2(0.0, -20.0);
    activeBodyDef.position = new Vector2(0.0, 15.0);
    activeBodyDef.type = BodyType.DYNAMIC;
    activeBodyDef.bullet = true;
    BodyDef bodyDef = activeBodyDef;

    this.body = world.createBody(bodyDef)
      ..createFixtureFromFixtureDef(fixtureDef);
  }

  Vector2 getPosition() {
    Vector2 center = new Vector2.zero();
    CircleShape circle = body.getFixtureList().getShape();
    body.getWorldPointToOut(circle.p, center);
//    viewport.getWorldToScreen(center, center);
    return center;
  }

  void input(double x, double y) {
    Vector2 currentForwardNormal =
        x < 500 ? new Vector2(-1.0, 0.0) : new Vector2(1.0, 0.0);
    body.applyForce(currentForwardNormal..scale(100.0), body.worldCenter);
  }
}
