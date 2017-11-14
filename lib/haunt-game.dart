import 'dart:ui';

import 'package:flame/component.dart';
import 'package:flame/game.dart';

class HauntGame extends Game {
  Size dimensions;

  Layer layer1;

  HauntGame(this.dimensions) {
    this.layer1 = new Layer(dimensions);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    layer1.render(canvas);
  }

  @override
  void update(double t) {}
}

class Layer extends SpriteComponent {
  double maxY;

  Layer(Size dimensions)
      : super.rectangle(dimensions.width, dimensions.height,
            'layers/layer_01_1920x1080.png') {
    this.angle = 0.0;
  }

  @override
  void update(double t) {}
}
