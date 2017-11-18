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
    bodies.forEach((body) {
      body.update(t);
    });
  }

  @override
  void render(canvas) {
    bodies.forEach((body) {
      body.render(canvas);
    });
  }

  Body createBody(BodyDef def, {BodyComponent component}) {
    if (component == null) {
      component = new BodyComponent();
    }
    var body = world.createBody(def);
    component.viewport = viewport;
    component.body = body;
    bodies.add(component);
    return body;
  }

  void initialize();
}

class BodyComponent extends Component {
  Body body;

  ViewportTransform viewport;

  @override
  void update(double t) {
    // TODO: implement update
  }

  @override
  void render(Canvas canvas) {
    body.getFixtureList();
    for (Fixture fixture = body.getFixtureList();
        fixture != null;
        fixture = fixture.getNext()) {
      switch (fixture.getType()) {
        case ShapeType.CHAIN:
          throw new Exception("not implemented");
          break;
        case ShapeType.CIRCLE:
          _renderCircle(canvas, fixture);
          break;
        case ShapeType.EDGE:
          throw new Exception("not implemented");
          break;
        case ShapeType.POLYGON:
          break;
      }
    }
  }

  void _renderCircle(Canvas canvas, Fixture fixture) {
    Vector2 center = new Vector2.zero();
    CircleShape circle = fixture.getShape();
    body.getWorldPointToOut(circle.p, center);
    viewport.getWorldToScreen(center, center);
    renderCircle(
        canvas, new Offset(center.x, center.y), circle.radius * viewport.scale);
  }

  void renderCircle(Canvas canvas, Offset center, double radius) {
    final Paint paint = new Paint()
      ..color = new Color.fromARGB(255, 255, 255, 255);
    canvas.drawCircle(center, radius, paint);
  }
}
