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

import 'dart:ui';

import 'package:box2d/box2d.dart';

class CanvasDraw extends DebugDraw {
  /** The canvas rendering context with which to draw. */

  Canvas canvas;

  CanvasDraw(ViewportTransform viewport) : super(viewport) {
    assert(null != viewport);
  }

  /**
   * Draw a closed polygon provided in CCW order. WARNING: This mutates
   * [vertices].
   */
  void drawPolygon(List<Vector2> vertices, int vertexCount, Color3i color) {
    _drawPolygonPath(vertexCount, vertices, _createPaint(color));
  }

  /**
   * Draw a solid closed polygon provided in CCW order. WARNING: This mutates
   * [vertices].
   */
  void drawSolidPolygon(
      List<Vector2> vertices, int vertexCount, Color3i color) {
    _drawPolygonPath(
        vertexCount, vertices, _createPaint(color, style: PaintingStyle.fill));
  }

  /** Draw a line segment. WARNING: This mutates [p1] and [p2]. */
  void drawSegment(Vector2 p1, Vector2 p2, Color3i color) {
    getWorldToScreenToOut(p1, p1);
    getWorldToScreenToOut(p2, p2);

    var path = new Path();
    path.moveTo(p1.x, p1.y);
    path.lineTo(p2.x, p2.y);

    canvas.drawPath(path, _createPaint(color));
  }

  /** Draw a circle. WARNING: This mutates [center]. */
  void drawCircle(Vector2 center, num radius, Color3i color, [Vector2 axis]) {
    radius *= viewportTransform.scale;
    _drawnCirclePath(center, radius, _createPaint(color));
  }

  /** Draw a solid circle. WARNING: This mutates [center]. */
  void drawSolidCircle(
      Vector2 center, num radius, Vector2 axis, Color3i color) {
    radius *= viewportTransform.scale;
    drawPoint(center, radius, color);
  }

  /**
   * Draws the given point with the given *unscaled* radius, in the given [color].
   * WARNING: This mutates [point].
   */
  void drawPoint(Vector2 point, num radiusOnScreen, Color3i color) {
    _drawnCirclePath(
        point, radiusOnScreen, _createPaint(color, style: PaintingStyle.fill));
  }

  /**
   * Draw a transform. Choose your own length scale. WARNING: This mutates
   * [xf.position].
   */
  void drawTransform(Transform xf, Color3i color) {
    drawCircle(xf.p, 0.1, color);
    // TODO(rupertk): Draw rotation representation (drawCircle axis parameter?)
  }

  /** Draw a string. */
  void drawStringXY(num x, num y, String s, Color3i color) {
    var paragraphBuilder = new ParagraphBuilder(new ParagraphStyle())
      ..addText(s);

    canvas.drawParagraph(paragraphBuilder.build(), new Offset(x, y));
  }

  void drawParticles(List<Vector2> centers, double radius,
      List<ParticleColor> colors, int count) {
    throw "Unimplemented";
  }

  void drawParticlesWireframe(List<Vector2> centers, double radius,
      List<ParticleColor> colors, int count) {
    throw "Unimplemented";
  }

  void _drawPolygonPath(int vertexCount, List<Vector2> vertices, Paint paint) {
    // TODO(gregbglw): Do a single ctx transform rather than convert all of
    // these vectors.
    for (int i = 0; i < vertexCount; ++i) {
      getWorldToScreenToOut(vertices[i], vertices[i]);
    }

    var path = new Path();
    path.moveTo(vertices[0].x, vertices[0].y);

    // Draw lines to all of the remaining points.
    for (int i = 1; i < vertexCount; ++i) {
      path.lineTo(vertices[i].x, vertices[i].y);
    }

    // Draw a line back to the starting point.
    path.lineTo(vertices[0].x, vertices[0].y);

    canvas.drawPath(path, paint);
  }

  void _drawnCirclePath(Vector2 center, num radius, Paint paint) {
    getWorldToScreenToOut(center, center);

//    print("Circle: ${center.x}, ${center.y}, $radius, $paint");

    canvas.drawCircle(new Offset(center.x, center.y), radius, paint);
  }

  Paint _createPaint(Color3i color,
      {PaintingStyle style: PaintingStyle.stroke}) {
    final Paint paint = new Paint()
      ..color = new Color.fromARGB(255, color.x, color.y, color.z)
      ..style = style;
    return paint;
  }
}
