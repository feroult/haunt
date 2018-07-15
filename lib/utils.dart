import 'dart:ui';

import 'package:flame/flame.dart';

class ImagesLoader {
  Map<String, Image> images = new Map();

  int loading = 0;

  void load(String key, String filename) {
    loading++;
    Flame.images.load(filename).then((image) {
      images[key] = image;
      loading--;
    });
  }

  bool get isLoading => loading != 0;

  get(String key) => images[key];
}

