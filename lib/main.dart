import 'package:flutter/widgets.dart';

import 'haunt-game.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(HauntGame().widget);
}
