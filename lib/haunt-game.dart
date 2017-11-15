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
  void update(double t) {
    background.update(t);
  }
}

class ParallaxComponent extends PositionComponent {
  List<Image> images = new List();
  List<double> scrolls = new List();
  Size size;
  bool loaded = false;

  ParallaxComponent(this.size, List<String> filenames) {
    _load(filenames);
  }

  void _load(List<String> filenames) {
    var futures =
        filenames.fold(new List<Future>(), (List<Future> result, filename) {
      result.add(Flame.images.load(filename).then((image) {
        images.add(image);
        scrolls.add(0.0);
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

    prepareCanvas(canvas);
    _drawLayers(canvas);
  }

  void _drawLayers(Canvas canvas) {
    images.asMap().forEach((index, image) {
      var scroll = scrolls[index];

      Rect leftRect =
          new Rect.fromLTWH(0.0, 0.0, (1 - scroll) * size.width, size.height);
      Rect rightRect = new Rect.fromLTWH(
          (1 - scroll) * size.width, 0.0, scroll * size.width, size.height);

      paintImage(
          canvas: canvas,
          image: image,
          rect: leftRect,
          fit: BoxFit.cover,
          alignment: Alignment.centerRight);

      paintImage(
          canvas: canvas,
          image: image,
          rect: rightRect,
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft);
    });
  }

  @override
  void update(double delta) {
    if (!loaded) {
      return;
    }
    for (var i = 0; i < scrolls.length; i++) {
      var scroll = scrolls[i];
      scroll += (100 + i * 20) * delta / size.width;
      if (scroll > 1) {
        scroll = scroll % 1;
      }
      scrolls[i] = scroll;
    }
  }
}
