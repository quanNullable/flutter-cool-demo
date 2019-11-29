import 'package:flutter/material.dart';
import 'package:flutter_drag_scale/flutter_drag_scale.dart';

/**
 * Author: Quan
 * Date: 2019-11-12 14:49
 */
class DemoPage7 extends StatelessWidget {
  DemoPage7({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Drag & Double press scale"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: DragScaleContainer(
              doubleTapStillScale: true,
              child: Image.asset('assets/image/test.jpg'),
            )),
            Expanded(
                child: DragScaleContainer(
              doubleTapStillScale: false,
              child: Image.asset('assets/image/test.jpg'),
            ))
          ],
        ));
  }
}
