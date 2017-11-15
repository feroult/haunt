import 'dart:async';
import 'dart:ui';

import 'package:flame/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';

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
  void update(double t) {}
}

class ParallaxComponent extends PositionComponent {
  List<Image> images = new List();
  bool loaded = false;
  Size dimensions;

  ParallaxComponent(this.dimensions, List<String> filenames) {
    _load(filenames);
  }

  void _load(List<String> filenames) {
    var futures =
        filenames.fold(new List<Future>(), (List<Future> result, filename) {
      result.add(Flame.images.load(filename).then((image) {
        images.add(image);
      }));
      return result;
    });
    Future.wait(futures).then((r) {
      loaded = true;
    });
  }

  @override
  void render(Canvas canvas) {
    if (!loaded) {
      return;
    }
    images.forEach((image) {
      final Rect rect =
          new Rect.fromLTWH(0.0, 0.0, dimensions.width, dimensions.height);
      canvas.translate(x, y);
      canvas.rotate(angle); // TODO: rotate around center
      paintImage(canvas: canvas, image: image, rect: rect, fit: BoxFit.cover);
    });
  }

  @override
  void update(double t) {
    // TODO: implement update
  }
}
