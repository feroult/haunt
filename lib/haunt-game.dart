import 'dart:collection';
import 'dart:ui';

import 'package:flame/component.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'box2d/ninja_world.dart';

class HauntGame extends Game {
  Size dimensions;

  ParallaxComponent background;

  NinjaWorld ninjaWorld;

  final Queue<PointerEvent> _pendingPointerEvents = new Queue<PointerEvent>();

  HauntGame(this.dimensions) {
    var filenames = new List<String>();
    for (var i = 1; i <= 7; i++) {
      filenames.add("layers/layer_0${i}.png");
    }

    ninjaWorld = createNinjaWorld(dimensions);
    background = new ParallaxComponent(dimensions, filenames);

    final tap = new TapGestureRecognizer()
      ..onTapUp = (TapUpDetails details) {
        var globalPosition = details.globalPosition
            .scale(window.devicePixelRatio, window.devicePixelRatio);
        print("tap: ${globalPosition}, ratio: ${window
            .devicePixelRatio}");
      };

    final drag = new ImmediateMultiDragGestureRecognizer()
      ..onStart = (Offset offset) {
        var handleDrag = new HandleDrag();
        print("drag start [${handleDrag.id}: ${offset}");
        return handleDrag;
      };

    GestureBinding.instance.pointerRouter.addGlobalRoute((PointerEvent e) {
      if (e is PointerDownEvent) {
        tap.addPointer(e);
        drag.addPointer(e);
      }
    });

//    window.onPointerDataPacket = (PointerDataPacket packet) {
//      PointerData pointer = packet.data.first;
//      print("pos: ${pointer.physicalX}, ${pointer.physicalY}");
//    };

//    window.onPointerDataPacket = (PointerDataPacket packet) {
//      _pendingPointerEvents.addAll(
//          PointerEventConverter.expand(packet.data, window.devicePixelRatio));
//
//      while (_pendingPointerEvents.isNotEmpty) {
//        var event = _pendingPointerEvents.removeFirst();
//        if (event is PointerDownEvent) {
//          print("here");
//          _tap.addPointer(event);
//        }
//      }
//
//
//
//
////      PointerData pointer = packet.data.first;
////      print("pointer: $pointer, ${pointer.pressure}, ${pointer.change}");
////      input(pointer);
//    };
  }

  NinjaWorld createNinjaWorld(Size dimensions) {
    var demo = new NinjaWorld(dimensions);
    demo.initializeWorld();
    return demo;
  }

  void input(PointerData pointer) {
    ninjaWorld.input(pointer);
  }

  @override
  void render(Canvas canvas) {
    if (!background.loaded) {
      return;
    }
//    background.render(canvas);
    ninjaWorld.render(canvas);
  }

  @override
  void update(double t) {
    if (!background.loaded) {
      return;
    }

//    background.update(t);
    ninjaWorld.update(t);
  }
}

class HandleDrag extends Drag {
  static int counter = 0;
  int id = counter++;

  void update(DragUpdateDetails details) {
    print("drag update [${id}]: ${details.globalPosition}");
  }


  @override
  void cancel() {
    print("drag CANCELED [${id}]");
  }

  @override
  void end(DragEndDetails details) {
    print("drag end [${id}]: ${details.velocity}");
  }
}
