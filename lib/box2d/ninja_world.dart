import 'dart:ui';

import 'package:box2d/box2d.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

import 'box2d_component.dart';
import 'custom_shape.dart';

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
    shape.setAsBoxXY(viewport.width(1.0), GroundComponent.HEIGHT);
    final fixtureDef = new FixtureDef();
    fixtureDef.shape = shape;
    fixtureDef.friction = 0.0;
    fixtureDef.restitution = 0.0;
    final bodyDef = new BodyDef();
    bodyDef.position =
        new Vector2(0.0, viewport.alignBottom(GroundComponent.HEIGHT));
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
    FixtureDef fixtureDef = _createFixture(_createShape());
    BodyDef bodyDef = createBodyDef();

    this.body = world.createBody(bodyDef)
      ..createFixtureFromFixtureDef(fixtureDef);
  }

  CustomShape _createShape() {
    final bouncingCircle = new CustomShape();
    bouncingCircle.radius = NINJA_RADIUS;
    bouncingCircle.p.x = 0.00001;
    return bouncingCircle;
  }

  FixtureDef _createFixture(CustomShape bouncingCircle) {
    final activeFixtureDef = new FixtureDef();
    activeFixtureDef.restitution = 0.0;
    activeFixtureDef.density = 0.05;
    activeFixtureDef.shape = bouncingCircle;
    return activeFixtureDef;
  }

  BodyDef createBodyDef() {
    final activeBodyDef = new BodyDef();
    activeBodyDef.linearVelocity = new Vector2(0.0, -20.0);
    activeBodyDef.position = new Vector2(15.0, 15.0);
    activeBodyDef.type = BodyType.DYNAMIC;
    activeBodyDef.bullet = true;
    return activeBodyDef;
  }

  void input(double x, double y) {
    Vector2 currentForwardNormal =
        x < 500 ? new Vector2(-1.0, 0.0) : new Vector2(1.0, 0.0);
    body.applyForce(currentForwardNormal..scale(100.0), body.worldCenter);
  }
}
