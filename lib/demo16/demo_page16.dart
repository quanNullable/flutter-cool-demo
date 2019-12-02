import 'package:flutter/material.dart';
import 'package:gesture_password/gesture_password.dart';
import 'package:gesture_password/mini_gesture_password.dart';

class DemoPage16 extends StatefulWidget {
  @override
  _DemoPage16State createState() => _DemoPage16State();
}

class _DemoPage16State extends State<DemoPage16> {
  GlobalKey<MiniGesturePasswordState> miniGesturePassword = GlobalKey<MiniGesturePasswordState>();

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Text('Plugin example app'),
      ),
      body: Column(
        children: <Widget>[
          Center(child: MiniGesturePassword(key: miniGesturePassword)),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                color: Colors.red,
                margin: const EdgeInsets.only(top: 100.0),
                child: GesturePassword(
                  width: 200.0,
                  successCallback: (s) {
                    print("successCallback$s");
                    scaffoldState.currentState
                        ?.showSnackBar(SnackBar(content: Text('successCallback:$s')));
                    miniGesturePassword.currentState?.setSelected('');
                  },
                  failCallback: () {
                    print('failCallback');
                    scaffoldState.currentState
                        ?.showSnackBar(SnackBar(content: Text('failCallback')));
                    miniGesturePassword.currentState?.setSelected('');
                  },
                  selectedCallback: (str) {
                    miniGesturePassword.currentState?.setSelected(str);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
