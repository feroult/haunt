import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'haunt-game.dart';

main() async {
  await Flame.init(orientation: DeviceOrientation.portraitUp);
  runApp(new HauntGame());
}
