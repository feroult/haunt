import 'dart:ui';

import 'package:flame/component.dart';
import 'package:flame/game.dart';

class HauntGame extends Game {
  Size dimensions;

  ParallaxComponent background;

  HauntGame(this.dimensions) {
    var filenames = new List<String>();
    for (var i = 1; i <= 7; i++) {
      filenames.add("layers/layer_0${i}.png");
    }

    background = new ParallaxComponent(dimensions, filenames);
  }

  @override
  void render(Canvas canvas) {
    background.render(canvas);
  }

  @override
  void update(double t) {
    background.update(t);
  }
}
