import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_route.dart';
import 'demo1/demo_page1.dart';
import 'demo10/demo_page10.dart';
import 'demo11/demo_page11.dart';
import 'demo12/demo_page12.dart';
import 'demo13/demo_page13.dart';
import 'demo14/demo_page14.dart';
import 'demo15/demo_page15.dart';
import 'demo16/demo_page16.dart';
import 'demo17/demo_page17.dart';
import 'demo18/demo_page18.dart';
import 'demo2/demo_page2.dart';
import 'demo3/demo_page3.dart';
import 'demo4/demo_page4.dart';
import 'demo5/demo_page5.dart';
import 'demo6/demo_page6.dart';
import 'demo7/demo_page7.dart';
import 'demo8/demo_page8.dart';
import 'demo9/demo_page9.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: () => _toPage(context, 1),
                child: Text(
                  '对比度、亮度、旋转(native)',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 2),
                child: Text(
                  '裁剪、翻转、旋转(native)',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 3),
                child: Text(
                  '涂鸦、水印(flutter)',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 4),
                child: Text(
                  'open cv(插件未完成)',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 5),
                child: Text(
                  '画中画(flutter)',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 6),
                child: Text(
                  'flutter effects',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 7),
                child: Text(
                  '拖拽、放大',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 8),
                child: Text(
                  '其他',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 9),
                child: Text(
                  '个性涂鸦',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 10),
                child: Text(
                  '其他2',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 11),
                child: Text(
                  '动画',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 12),
                child: Text(
                  '卡片切换动效',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 13),
                child: Text(
                  '扫光',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 14),
                child: Text(
                  'loading',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 15),
                child: Text(
                  '文字特效',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 16),
                child: Text(
                  '手势密码',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 17),
                child: Text(
                  'viewpager 指示器',
                ),
              ),
              OutlineButton(
                onPressed: () => _toPage(context, 18),
                child: Text(
                  '快速选择列表',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _toPage(BuildContext context, int index) {
    Widget toPage;
    RouteType type = RouteType.rotate;
    switch (index) {
      case 1:
        toPage = DemoPage1();
        type = RouteType.fade;
        break;
      case 2:
        toPage = DemoPage2();
        type = RouteType.scale;
        break;
      case 3:
        toPage = DemoPage3();
        type = RouteType.slide;
        break;
      case 4:
        toPage = DemoPage4();
        type = RouteType.rotate;
        break;
      case 5:
        toPage = DemoPage5();
        break;
      case 6:
        toPage = DemoPage6();
        break;
      case 7:
        toPage = DemoPage7();
        break;
      case 8:
        toPage = DemoPage8();
        break;
      case 9:
        toPage = DemoPage9();
        break;
      case 10:
        toPage = DemoPage10();
        break;
      case 11:
        toPage = DemoPage11();
        break;
      case 12:
        toPage = DemoPage12();
        break;
      case 13:
        toPage = DemoPage13();
        break;
      case 14:
        toPage = DemoPage14();
        break;
      case 15:
        toPage = DemoPage15();
        break;
      case 16:
        toPage = DemoPage16();
        break;
      case 17:
        toPage = DemoPage17();
        break;
      case 18:
        toPage = DemoPage18();
        break;
    }
    if (toPage != null) {
      Navigator.push(context, CustomRoute(toPage, type: type));
    }
  }
}
