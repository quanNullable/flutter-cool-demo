import 'package:flutter/material.dart';

import 'p.dart';

/**
 * Author: Quan
 * Date: 2019-11-15 17:55
 */
class WaterBrushPaint extends StatefulWidget {
  WaterBrushPaint({
    Key key,
  }) : super(key: key);
  @override
  WaterBrushPaintState createState() {
    return WaterBrushPaintState();
  }
}

class WaterBrushPaintState extends State<WaterBrushPaint> with SingleTickerProviderStateMixin {
  MySketch sketch;
  PAnimator animator;

  @override
  void initState() {
    super.initState();
    sketch = MySketch();
    // Need an animator to call the draw() method in the sketch continuously,
    // otherwise it will be called only when touch events are detected.
    animator = PAnimator(this);
    animator.addListener(() {
      setState(() {
        sketch.redraw();
      });
    });
    animator.run();
  }

  @override
  Widget build(BuildContext context) {
    return PWidget(sketch);
  }
  @override
  void dispose() {
    animator.dispose();
    sketch.dispose();
    super.dispose();
  }
}
