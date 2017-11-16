/*******************************************************************************
 * Copyright (c) 2015, Daniel Murphy, Google
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *  * Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************/

library demo;

import 'dart:ui';

import 'package:box2d/box2d.dart' hide Timer;

import 'canvas_draw.dart';

/**
 * An abstract class for any Demo of the Box2D library.
 */
abstract class Demo {
  static const int WORLD_POOL_SIZE = 100;
  static const int WORLD_POOL_CONTAINER_SIZE = 10;

  /** All of the bodies in a simulation. */
  List<Body> bodies = new List<Body>();

  /** The gravity vector's y value. */
  static const double GRAVITY = -10.0;

  /** The timestep and iteration numbers. */
  static const int VELOCITY_ITERATIONS = 10;
  static const int POSITION_ITERATIONS = 10;

  /** The physics world. */
  World world;

  /** The debug drawing tool. */
  CanvasDraw debugDraw;

  Demo(String name) {
    this.world = new World.withPool(new Vector2(0.0, GRAVITY),
        new DefaultWorldPool(WORLD_POOL_SIZE, WORLD_POOL_CONTAINER_SIZE));
  }

  void update(t) {
    world.stepDt(t, VELOCITY_ITERATIONS, POSITION_ITERATIONS);
  }

  void render(canvas) {
    debugDraw.canvas = canvas;
    world.drawDebugData();
  }

  /**
   * Creates the canvas and readies the demo for animation. Must be called
   * before calling runAnimation.
   */
  void initializeAnimation(Size dimensions) {
    var extents = new Vector2(dimensions.width / 2, dimensions.height / 2);
    var viewport = new ViewportTransform(extents, extents, 15.0);

    // Create our canvas drawing tool to give to the world.
    debugDraw = new CanvasDraw(viewport);

    // Have the world draw itself for debugging purposes.
    world.debugDraw = debugDraw;
  }

  void initialize();
}
