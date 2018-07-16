import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/widgets.dart';

class DemoLevel {
  List<BodyComponent> _bodies = new List();

  DemoLevel(Box2DComponent box) {
    _bodies.add(new WallBody(box, 1.0, 0.05, Alignment.topCenter));
    _bodies.add(new WallBody(box, 1.0, 0.05, Alignment.bottomCenter));
    _bodies.add(new WallBody(box, 0.05, 1.0, Alignment.centerRight));
    _bodies.add(new WallBody(box, 0.05, 1.0, Alignment.centerLeft));
  }

  List<BodyComponent> get bodies => _bodies;
}

class WallBody extends BodyComponent {
  double widthPercent;
  double heightPercent;
  Alignment alignment;

  WallBody(
      Box2DComponent box, this.widthPercent, this.heightPercent, this.alignment)
      : super(box) {
    _createBody();
  }

  void _createBody() {
    double width = box.viewport.width * widthPercent;
    double height = box.viewport.height * heightPercent;

    double x = alignment.x * (box.viewport.width - width);
    double y = (-alignment.y) * (box.viewport.height - height);

    final shape = new PolygonShape();
    shape.setAsBoxXY(width / 2, height / 2);
    final fixtureDef = new FixtureDef();
    fixtureDef.shape = shape;

    fixtureDef.restitution = 0.0;
    fixtureDef.friction = 0.2;
    final bodyDef = new BodyDef();
    bodyDef.position = new Vector2(x / 2, y / 2);
    Body groundBody = world.createBody(bodyDef);
    groundBody.createFixtureFromFixtureDef(fixtureDef);
    this.body = groundBody;
  }
}
