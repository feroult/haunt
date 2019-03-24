import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

import 'haunt-game.dart';

main() async {
  Flame.initializeWidget();
  runApp(new HauntGame().widget);
}
