import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

import 'haunt-game.dart';

main() async {
//  await normalFlame();
  await normalFlutter();
}

Future normalFlame() async {
  Flame.initialize();

  Flame.util.fullScreen();
  Flame.audio.disableLog();

  var dimensions = await Flame.util.initialDimensions();

//  new HauntGame(dimensions)..start();
}

normalFlutter() async {
  Flame.initializeWidget();
  Flame.util.fullScreen();
  var dimensions = await Flame.util.initialDimensions();
  runApp(new HauntGame(dimensions));
}
