/// Author: Quan
/// Date: 2019-11-12 10:09
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_editor/flutter_image_editor.dart';

class DemoPage1 extends StatefulWidget {
  @override
  _WidgetEditableImage createState() => _WidgetEditableImage();
}

class _WidgetEditableImage extends State<DemoPage1> {
  StreamController<Uint8List> _pictureStream;
  double _contrast;
  double _brightness;
  double _degrees;
  ByteData pictureByteData;
  Uint8List picture;

  @override
  void initState() {
    initImageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
//          title: Text('Scrawl'),
            ),
        body: _pictureStream == null ? SizedBox.shrink() : containerEditableImage());
  }

  void updatePicture() async {
    var retorno = await PictureEditor.editImage(picture, _contrast, _brightness);
    _pictureStream.add(retorno);
  }

  void setBrightness(double valor) {
    setState(() {
      _brightness = valor;
    });
  }

  void setDegrees(double valor) {
    setState(() {
      _degrees = valor;
    });
  }

  void setContrast(double valor) {
    setState(() {
      _contrast = valor;
    });
  }

  void initImageData() async {
    ByteData bytes = await rootBundle.load('assets/image/test.jpg');
    final buffer = bytes.buffer;
    var image = buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    _pictureStream = new StreamController<Uint8List>();
    _brightness = 0;
    _degrees = 0;
    _contrast = 1;
    pictureByteData = ByteData.view(image.buffer);
    picture = pictureByteData.buffer
        .asUint8List(pictureByteData.offsetInBytes, pictureByteData.lengthInBytes);
    setState(() {});
  }

  rotateImage() async {
    var retorno = await PictureEditor.rotateImage(picture, _degrees);
    _pictureStream.add(retorno);
  }

  Widget containerEditableImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        Container(
            height: 300,
            width: 300,
            child: StreamBuilder(
              stream: _pictureStream.stream,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return Image.memory(
                    snapshot.data,
                    gaplessPlayback: true,
                    fit: BoxFit.contain,
                  );
                } else {
                  return Image.memory(
                    picture,
                    gaplessPlayback: true,
                    fit: BoxFit.contain,
                  );
                }
              },
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("对比度"),
                    Slider(
                      label: '对比度',
                      min: 0,
                      max: 10,
                      value: _contrast,
                      onChanged: (valor) {
                        setContrast(valor);
                        updatePicture();
                      },
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("亮度"),
                    Slider(
                      label: '亮度',
                      min: -255,
                      max: 255,
                      value: _brightness,
                      onChanged: (valor) {
                        setBrightness(valor);
                        updatePicture();
                      },
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("旋转"),
                    Slider(
                      label: '旋转角度',
                      min: 0,
                      max: 360,
                      value: _degrees,
                      onChanged: (valor) {
                        setDegrees(valor);
                        rotateImage();
                      },
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
