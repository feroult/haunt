import 'dart:ui';

import 'package:box2d/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

class NinjaWorld extends Box2DComponent {
  NinjaComponent ninja;

  NinjaWorld(Size dimensions) : super(dimensions, scale: 8.0);

  void initializeWorld() {
    add(new GroundComponent(this));
    add(ninja = new NinjaComponent(this));
  }

  @override
  void update(t) {
    super.update(t);
    _followNinja();
  }

  void _followNinja() {
    cameraFollow(ninja, horizontal: 0.4, vertical: 0.9);
  }

  void input(Offset position) {
    ninja.input(position);
  }

  Drag handleDrag(Offset position) {
    return ninja.handleDrag(position);
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
    Flame.images.load("layers/layer_07_cropped.png").then((image) {
      this.image = image;
    });
  }

  void _createBody() {
    final shape = new PolygonShape();
    shape.setAsBoxXY(viewport.width(10000.0), HEIGHT);
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

//  @override
//  void drawPolygon(Canvas canvas, List<Offset> points) {
//    if (image == null) {
//      return;
//    }
//    paintImage(
//      canvas: canvas,
//      image: image,
//      rect: new Rect.fromPoints(points[0], points[2]),
//      repeat: ImageRepeat.repeatX,
//    );
//  }

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
//    body.angularVelocity *= 0.9;
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
    activeBodyDef.linearVelocity = new Vector2(0.0, 0.0);
    activeBodyDef.position = new Vector2(0.0, 15.0);
    activeBodyDef.type = BodyType.DYNAMIC;
    activeBodyDef.bullet = true;
    BodyDef bodyDef = activeBodyDef;

    this.body = world.createBody(bodyDef)
      ..createFixtureFromFixtureDef(fixtureDef);
  }

  void input(Offset position) {
    Vector2 force =
        position.dx < 250 ? new Vector2(-1.0, 0.0) : new Vector2(1.0, 0.0);
    body.applyForce(force..scale(10000.0), center);
  }

  Drag handleDrag(Offset position) {
    return new HandleNinjaDrag(this);
  }
}

class HandleNinjaDrag extends Drag {
  NinjaComponent ninja;

  HandleNinjaDrag(this.ninja);

  @override
  void update(DragUpdateDetails details) {
    impulse(details.delta);
  }

  @override
  void end(DragEndDetails details) {
    impulse(details.velocity.pixelsPerSecond);
  }

  void impulse(Offset velocity) {
    Vector2 force = new Vector2(velocity.dx, -velocity.dy)..scale(100.0);
    ninja.body.applyLinearImpulse(force, ninja.center, true);
  }
}
