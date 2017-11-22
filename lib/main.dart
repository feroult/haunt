import 'package:flame/flame.dart';

import 'haunt-game.dart';

main() async {
  Flame.initialize();

  Flame.util.fullScreen();
  Flame.audio.disableLog();

  var dimensions = await Flame.util.initialDimensions();

  new HauntGame(dimensions)..start();
}
