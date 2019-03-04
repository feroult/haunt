import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'haunt-game.dart';

main() async {
  await Flame.util.fullScreen();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);

  Flame.initializeWidget();
  runApp(new HauntGame().widget);
}
