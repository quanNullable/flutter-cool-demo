import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'anvil_effect/anvil_effect_widget.dart';
import 'anvil_effect/explosion_effect_widget.dart';
import 'scratch_card_widget.dart';
import 'text_effect/diff_scale_text.dart';
import 'text_effect/line_border_text.dart';
import 'text_effect/rainbow_text.dart';
import 'utils.dart';

class DemoPage6 extends StatefulWidget {
  @override
  _DemoPage6State createState() => _DemoPage6State();
}

class _DemoPage6State extends State<DemoPage6> {
  List<String> sentences = [];

  int diffScaleNext = 0;

  ui.Image _image;

  @override
  void initState() {
    super.initState();
    for (int i = 1; i < 10; i++) {
      sentences.add(String.fromCharCode(64 + i) * Random().nextInt(10));
    }
    Utils.getImage("assets/image/bg_gift_bag_bottom.png").then((image) {
      _image = image;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Effects'),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            createItem(ScratchCardWidget(
                strokeWidth: 20,
                threshold: 0.5,
                foreground: (canvas, size, offset) {
                  if (_image != null) {
                    double scale;
                    double dx = 0;
                    double dy = 0;
                    if (_image.width * size.height > size.width * _image.height) {
                      scale = size.height / _image.height;
                      dx = (size.width - _image.width * scale) / 2;
                    } else {
                      scale = size.width / _image.width;
                      dy = (size.height - _image.height * scale) / 2;
                    }
                    canvas.save();
                    canvas.translate(dx, dy);
                    canvas.scale(scale, scale);
                    canvas.drawImage(_image, Offset(0, 0), new Paint());
                    canvas.restore();
                  } else {
                    canvas.drawRect(
                        Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.grey);
                  }
                },
                child: Container(
                  color: Colors.blueAccent,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/image/icon_sm_sigin_status_three.png",
                    fit: BoxFit.scaleDown,
                    height: 20,
                  ),
                ))),
            Divider(),
            createItem(RainbowText(colors: [
              Color(0xFFFF2B22),
              Color(0xFFFF7F22),
              Color(0xFFEDFF22),
              Color(0xFF22FF22),
              Color(0xFF22F4FF),
              Color(0xFF5400F7),
            ], text: "Welcome to BBT", loop: true)),
            Divider(),
            createItem(ExplosionWidget(
                tag: "Explosion Text",
                child: Container(
                    alignment: Alignment.center,
                    color: Colors.blueAccent,
                    child: Text(
                      "Explosion Text",
                      style:
                          TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                    )))),
            Divider(),
            LineBorderText(
                child: createItem(Text(
                  "Border Effect",
                  style: TextStyle(fontSize: 20),
                )),
                autoAnim: true),
            Divider(),
            createItem(
                DiffScaleText(
                  text: sentences[diffScaleNext % sentences.length],
                  textStyle: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                bgColor: Colors.black, onTap: () {
              setState(() {
                diffScaleNext++;
              });
            }),
            Divider(),
            createItem(
                AnvilEffectWidget(
                  child: Text(
                    "👉AnvilEffect👈",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                bgColor: Colors.black),
          ],
        ),
      )),
    );
  }

  Widget createItem(Widget child, {VoidCallback onTap, Color bgColor = Colors.transparent}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          color: bgColor,
          child: child,
          height: 100,
          alignment: Alignment.center,
        ));
  }
}
