import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

import 'haunt-game.dart';
import 'package:screen/screen.dart';

main() {
  Screen.keepOn(true);
  Flame.initializeWidget();
  Flame.util.fullScreen();
  runApp(new HauntGame().widget);
}
