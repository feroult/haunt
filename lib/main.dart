import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

import 'haunt-game.dart';

main() {
  Flame.initializeWidget();
  Flame.util.fullScreen();
  runApp(new HauntGame().widget);
}
