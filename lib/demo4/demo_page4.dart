import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_opencv/opencv.dart' as cv;

/**
 * Author: Quan
 * Date: 2019-11-12 14:49
 */
class DemoPage4 extends StatefulWidget {
  DemoPage4({Key key}) : super(key: key);

  @override
  _DemoPage4State createState() => _DemoPage4State();
}

class _DemoPage4State extends State<DemoPage4> {
  String _versionString = "Unknown";
  String _buildInformation = "Unknown";

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _versionString = await cv.versionString;
      _buildInformation = await cv.buildInformation;
    } on PlatformException {
      _versionString = "Failed to get OpenCV version.";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OpenCV for Flutter"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("OpenCV version: $_versionString"),
          Text("OpenCV buildInformation: $_buildInformation")
        ],
      ),
    );
  }
}
