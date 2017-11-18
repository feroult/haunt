import 'dart:ui';

import 'package:box2d/box2d.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

import 'custom_shape.dart';
import 'demo.dart';

class BallCage extends Box2DComponent {
  Body ball;

  /** Starting position of ball cage in the world. */
  static const double START_X = -20.0;
  static const double START_Y = -20.0;

  /** The radius of the balls forming the arena. */
  static const num WALL_BALL_RADIUS = 2.0;

  /** Radius of the active ball. */
  static const num ACTIVE_BALL_RADIUS = 5.0;

  BallCage(Size dimensions) : super(dimensions);

  void initialize() {
    // Define the circle shape.
    final circleShape = new CircleShape();
    circleShape.radius = WALL_BALL_RADIUS;
    circleShape.p.x = 0.00001;

    // Create fixture using the circle shape.
    final circleFixtureDef = new FixtureDef();
    circleFixtureDef.shape = circleShape;
    circleFixtureDef.friction = .9;
    circleFixtureDef.restitution = 1.0;

    // Create a body def.
    final circleBodyDef = new BodyDef();

    int maxShapeinRow = 10;
    final num borderLimitX = START_X + maxShapeinRow * 2 * circleShape.radius;
    final num borderLimitY = START_Y + maxShapeinRow * 2 * circleShape.radius;

    for (int i = 0; i <= maxShapeinRow; i++) {
      final double shiftX = START_X + circleShape.radius * 2 * i;
      final double shiftY = START_Y + circleShape.radius * 2 * i;

      circleBodyDef.position = new Vector2(shiftX, START_Y);
      Body circleBody = createBody(circleBodyDef);
      circleBody.createFixtureFromFixtureDef(circleFixtureDef);

      circleBodyDef.position = new Vector2(shiftX, borderLimitY);
      circleBody = createBody(circleBodyDef);
      circleBody.createFixtureFromFixtureDef(circleFixtureDef);

      circleBodyDef.position = new Vector2(START_X, shiftY);
      circleBody = createBody(circleBodyDef);
      circleBody.createFixtureFromFixtureDef(circleFixtureDef);

      circleBodyDef.position = new Vector2(borderLimitX, shiftY);
      circleBody = createBody(circleBodyDef);
      circleBody.createFixtureFromFixtureDef(circleFixtureDef);
    }

    // Create a bouncing ball.
    final bouncingCircle = new CustomShape();
    bouncingCircle.radius = ACTIVE_BALL_RADIUS;
    bouncingCircle.p.x = 0.00001;

    // Create fixture for that ball shape.
    final activeFixtureDef = new FixtureDef();
    activeFixtureDef.restitution = 1.0;
    activeFixtureDef.density = 0.05;
    activeFixtureDef.shape = bouncingCircle;

    // Create the active ball body.
    final activeBodyDef = new BodyDef();
    activeBodyDef.linearVelocity = new Vector2(0.0, -20.0);
    activeBodyDef.position = new Vector2(15.0, 15.0);
    activeBodyDef.type = BodyType.DYNAMIC;
    activeBodyDef.bullet = true;
    ball = createBody(activeBodyDef, component: new NinjaComponent());
    ball.createFixtureFromFixtureDef(activeFixtureDef);
  }

  void input(double x, double y) {
    Vector2 currentForwardNormal = new Vector2(0.0, 5.0);
    ball.applyForce(currentForwardNormal..scale(1000.0), ball.worldCenter);
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
