import 'dart:ui';

import 'package:box2d/box2d.dart' hide Timer;
import 'package:flame/component.dart';

abstract class Box2DComponent extends Component {
  static const int DEFAULT_WORLD_POOL_SIZE = 100;
  static const int DEFAULT_WORLD_POOL_CONTAINER_SIZE = 10;
  static const double DEFAULT_GRAVITY = -10.0;
  static const int DEFAULT_VELOCITY_ITERATIONS = 10;
  static const int DEFAULT_POSITION_ITERATIONS = 10;

  Size dimensions;
  int velocityIterations;
  int positionIterations;

  World world;
  List<BodyComponent> bodies = new List();

  ViewportTransform viewport;

  Box2DComponent(this.dimensions,
      {int worldPoolSize: DEFAULT_WORLD_POOL_SIZE,
      int worldPoolContainerSize: DEFAULT_WORLD_POOL_CONTAINER_SIZE,
      double gravity: DEFAULT_GRAVITY,
      velocityIterations: DEFAULT_VELOCITY_ITERATIONS,
      int positionIterations: DEFAULT_POSITION_ITERATIONS}) {
    this.velocityIterations = velocityIterations;
    this.positionIterations = positionIterations;

    this.world = new World.withPool(new Vector2(0.0, gravity),
        new DefaultWorldPool(worldPoolSize, worldPoolContainerSize));

    var extents = new Vector2(dimensions.width / 2, dimensions.height / 2);
    this.viewport = new ViewportTransform(extents, extents, 20.0);
  }

  @override
  void update(t) {
    world.stepDt(t, velocityIterations, positionIterations);
  }

  @override
  void render(canvas) {
    bodies.forEach((body) {
      body.render(canvas, viewport);
    });
  }

  Body createBody(BodyDef def, {BodyRenderer renderer}) {
    var body = world.createBody(def);
    bodies.add(new BodyComponent(body, renderer: renderer));
    return body;
  }

  void initialize();
}

class BodyComponent {
  Body body;

  BodyRenderer renderer;

  BodyComponent(this.body, {BodyRenderer renderer}) {
    this.renderer = renderer != null ? renderer : new DefaultBodyRenderer();
  }

  void render(Canvas canvas, ViewportTransform viewport) {
    body.getFixtureList();
    for (Fixture fixture = body.getFixtureList();
        fixture != null;
        fixture = fixture.getNext()) {
      renderer.render(body, fixture, canvas, viewport);
    }
  }
}

class DefaultBodyRenderer extends BodyRenderer {
  @override
  void render(
      Body body, Fixture fixture, Canvas canvas, ViewportTransform viewport) {
    switch (fixture.getType()) {
      case ShapeType.CHAIN:
        break;
      case ShapeType.CIRCLE:
        _renderCircle(body, fixture, canvas, viewport);
        break;
      case ShapeType.EDGE:
        break;
      case ShapeType.POLYGON:
        break;
    }
  }

  void _renderCircle(
      Body body, Fixture fixture, Canvas canvas, ViewportTransform viewport) {
    final Paint paint = new Paint()
      ..color = new Color.fromARGB(255, 255, 255, 255);
    Vector2 center = new Vector2.zero();
    CircleShape circle = fixture.getShape();
    body.getWorldPointToOut(circle.p, center);
    viewport.getWorldToScreen(center, center);
    canvas.drawCircle(
        new Offset(center.x, center.y), circle.radius * viewport.scale, paint);
  }
}

abstract class BodyRenderer {
  void render(
      Body body, Fixture fixture, Canvas canvas, ViewportTransform viewport);
}
