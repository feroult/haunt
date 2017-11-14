import 'package:flame/flame.dart';

import 'haunt-game.dart';

main() async {
  Flame.util.enableEvents();
  Flame.audio.disableLog();

  var dimensions = await Flame.util.initialDimensions();

  new HauntGame(dimensions)..start();
}
