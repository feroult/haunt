import 'dart:ui';

import 'package:flame/game.dart';

class HauntGame extends Game {
  Size dimensions;

  HauntGame(this.dimensions);

  @override
  void render(Canvas canvas) {
    canvas.save();
    var paint = new Paint()..color = new Color(0xffffffff);
    var offset = this.dimensions.center(new Offset(0.0, 0.0));
    canvas.drawCircle(offset, 100.0, paint);
  }

  @override
  void update(double t) {}
}
