import 'dart:ui';

import 'package:flame/component.dart';
import 'package:flame/game.dart';

class HauntGame extends Game {
  Size dimensions;

  var layers = new List<Layer>();

  var loaded = false;

  HauntGame(this.dimensions) {
    for (var i = 7; i >= 1; i--) {
      layers.add(new Layer("layers/layer_0${i}_1920x1080.png", dimensions));
    }
    loaded = true;
  }

  @override
  void render(Canvas canvas) {
    layers.forEach((layer) {
      layer.render(canvas);
    });
  }

  @override
  void update(double t) {}
}

class Layer extends SpriteComponent {
  Layer(String uri, Size dimensions)
      : super.rectangle(dimensions.width, dimensions.height, uri) {
    this.x = 0.0;
    this.y = 0.0;
    this.angle = 0.0;
  }

  @override
  void update(double t) {}
}
