import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'haunt-game.dart';
import 'package:screen/screen.dart';

main() {
  Screen.keepOn(true);
  Flame.initializeWidget();
  Flame.util.fullScreen();

  SystemChrome
      .setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(new HauntGame().widget);
  });
}
