import 'package:flutter/material.dart';
import 'package:flutter_image_editor_demo/demo11/parent_animation_demo.dart';

import 'another_parent_animation_demo.dart';
import 'basic_animation_demo.dart';
import 'delayed_animation_demo.dart';
import 'hero_animation.dart';
import 'hidden_widget_animation_demo.dart';
import 'transforming_animation_demo.dart';
import 'value_change_animation_demo.dart';

/**
 * Author: Quan
 * Date: 2019-11-18 11:04
 */
class DemoPage11 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('动画'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              onPressed: () => _toPage(context, 1),
              child: Text(
                '平移放大',
              ),
            ),
            OutlineButton(
              onPressed: () => _toPage(context, 2),
              child: Text(
                '平移进入',
              ),
            ),
            OutlineButton(
              onPressed: () => _toPage(context, 3),
              child: Text(
                '梯次平移进入',
              ),
            ),
            OutlineButton(
              onPressed: () => _toPage(context, 4),
              child: Text(
                '打开收起',
              ),
            ),
            OutlineButton(
              onPressed: () => _toPage(context, 5),
              child: Text(
                '展开',
              ),
            ),
            OutlineButton(
              onPressed: () => _toPage(context, 6),
              child: Text(
                '文字变化',
              ),
            ),
            OutlineButton(
              onPressed: () => _toPage(context, 7),
              child: Text(
                '方变圆',
              ),
            ),
            OutlineButton(
              onPressed: () => _toPage(context, 8),
              child: Text(
                'Hero',
              ),
            ),
          ],
        ),
      ),
    );
  }

  _toPage(BuildContext context, int index) {
    Widget toPage;
    switch (index) {
      case 1:
        toPage = Animation1();
        break;
      case 2:
        toPage = Animation2();
        break;
      case 3:
        toPage = Animation3();
        break;
      case 4:
        toPage = Animation4();
        break;
      case 5:
        toPage = Animation5();
        break;
      case 6:
        toPage = Animation6();
        break;
      case 7:
        toPage = Animation7();
        break;
      case 8:
        toPage = Animation8();
        break;
    }
    if (toPage != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => toPage));
    }
  }
}
