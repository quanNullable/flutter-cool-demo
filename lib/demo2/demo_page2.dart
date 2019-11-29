import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_image_editor_demo/demo2/demo_page2_a.dart';
import 'package:image_editor/image_editor.dart';

import 'widget/clip_widget.dart';
import 'widget/flip_widget.dart';
import 'widget/rotate_widget.dart';

class DemoPage2 extends StatefulWidget {
  @override
  _DemoPage2State createState() => _DemoPage2State();
}

class _DemoPage2State extends State<DemoPage2> {
  ImageProvider provider;

  @override
  void initState() {
    super.initState();
    provider = AssetImage('assets/image/test.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple usage"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.extension),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DemoPage2A(),
            )),
            tooltip: "Use extended_image library",
          ),
          IconButton(
            icon: Icon(Icons.settings_backup_restore),
            onPressed: restore,
            tooltip: "Restore image to default.",
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Image(
              image: provider,
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    FlipWidget(
                      onTap: _flip,
                    ),
                    ClipWidget(
                      onTap: _clip,
                    ),
                    RotateWidget(
                      onTap: _rotate,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setProvider(ImageProvider provider) {
    this.provider = provider;
    setState(() {});
  }

  void restore() {
    setProvider(AssetImage('assets/image/test.jpg'));
  }

  Future<Uint8List> getAssetImage() async {
    final completer = Completer<Uint8List>();

    final config = createLocalImageConfiguration(context);
    final asset = AssetImage('assets/image/test.jpg');
    final key = await asset.obtainKey(config);
    final comp = asset.load(key);
    ImageStreamListener listener;
    listener = ImageStreamListener((info, flag) {
      comp.removeListener(listener);
      info.image.toByteData(format: ui.ImageByteFormat.png).then((data) {
        final l = data.buffer.asUint8List();
        completer.complete(l);
      });
    }, onError: (e, s) {
      completer.completeError(e, s);
    });

    comp.addListener(listener);

    asset.resolve(config);

    return completer.future;
  }

  void _flip(FlipOption flipOption) async {
    handleOption([flipOption]);
  }

  _clip(ClipOption clipOpt) async {
    handleOption([clipOpt]);
  }

  void _rotate(RotateOption rotateOpt) async {
    handleOption([rotateOpt]);
  }

  void handleOption(List<Option> options) async {
    ImageEditorOption option = ImageEditorOption();
    for (final o in options) {
      option.addOption(o);
    }

    final assetImage = await getAssetImage();

    final result = await ImageEditor.editImage(
      image: assetImage,
      imageEditorOption: option,
    );

    final img = MemoryImage(result);
    setProvider(img);
  }
}

Widget buildButton(String text, Function onTap) {
  return FlatButton(
    child: Text(text),
    onPressed: onTap,
  );
}
