import 'dart:ui';

import 'package:box2d/box2d.dart' hide Timer;
import 'package:flame/component.dart';

abstract class Box2DComponent extends Component {
  static const int DEFAULT_WORLD_POOL_SIZE = 100;
  static const int DEFAULT_WORLD_POOL_CONTAINER_SIZE = 10;
  static const double DEFAULT_GRAVITY = -10.0;
  static const int DEFAULT_VELOCITY_ITERATIONS = 10;
  static const int DEFAULT_POSITION_ITERATIONS = 10;
  static const double DEFAULT_SCALE = 20.0;

  Size dimensions;
  int velocityIterations;
  int positionIterations;

  World world;
  List<BodyComponent> bodies = new List();

  Viewport viewport;

  Box2DComponent(this.dimensions,
      {int worldPoolSize: DEFAULT_WORLD_POOL_SIZE,
      int worldPoolContainerSize: DEFAULT_WORLD_POOL_CONTAINER_SIZE,
      double gravity: DEFAULT_GRAVITY,
      this.velocityIterations: DEFAULT_VELOCITY_ITERATIONS,
      this.positionIterations: DEFAULT_POSITION_ITERATIONS,
      double scale: DEFAULT_SCALE}) {
    this.world = new World.withPool(new Vector2(0.0, gravity),
        new DefaultWorldPool(worldPoolSize, worldPoolContainerSize));
    this.viewport = new Viewport(dimensions, scale);
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

  void initializeWorld();
}

class Viewport extends ViewportTransform {
  Size dimensions;

  double scale;

  Viewport(this.dimensions, this.scale)
      : super(new Vector2(dimensions.width / 2, dimensions.height / 2),
            new Vector2(dimensions.width / 2, dimensions.height / 2), scale);

  double alignBottom(double height) =>
      -(dimensions.height / 2 / scale) + height;

  double width(int percent) {
    return percent * (dimensions.width / 2 / scale);
  }
}

class BodyComponent extends Component {
  static const MAX_POLYGON_VERTICES = 10;

  Body body;

  ViewportTransform viewport;

  @override
  void update(double t) {
    // usually all update will be handled by the world physics
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
          _renderPolygon(canvas, fixture);
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

  void _renderPolygon(Canvas canvas, Fixture fixture) {
    PolygonShape polygon = fixture.getShape();
    assert(polygon.count <= MAX_POLYGON_VERTICES);
    List<Vector2> vertices = new Vec2Array().get(polygon.count);

    for (int i = 0; i < polygon.count; ++i) {
      body.getWorldPointToOut(polygon.vertices[i], vertices[i]);
      viewport.getWorldToScreen(vertices[i], vertices[i]);
    }

    List<Offset> points = new List();
    for (int i = 0; i < polygon.count; i++) {
      points.add(new Offset(vertices[i].x, vertices[i].y));
    }

    drawPolygon(canvas, points);
  }

  void drawPolygon(Canvas canvas, List<Offset> points) {
    final path = new Path()..addPolygon(points, true);
    final Paint paint = new Paint()
      ..color = new Color.fromARGB(255, 255, 255, 255);
//    canvas.drawPath(path, paint);
  }
}
