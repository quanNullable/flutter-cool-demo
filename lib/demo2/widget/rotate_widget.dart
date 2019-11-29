import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';

import 'expand_container.dart';

class RotateWidget extends StatefulWidget {
  final ValueChanged<RotateOption> onTap;

  const RotateWidget({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  _RotateWidgetState createState() => _RotateWidgetState();
}

class _RotateWidgetState extends State<RotateWidget> {
  int angle = 0;

  @override
  Widget build(BuildContext context) {
    return ExpandContainer(
      title: "rotate: $angle",
      child: Column(
        children: <Widget>[
          Slider(
            onChanged: (v) => setState(() => angle = v.toInt()),
            value: angle.toDouble(),
            min: 0,
            max: 359,
          ),
          SizedBox(
            width: double.infinity,
            child: FlatButton(
              child: Text("rotate"),
              onPressed: _rotate,
            ),
          ),
        ],
      ),
    );
  }

  void _rotate() {
    final opt = RotateOption(angle);
    widget.onTap?.call(opt);
  }
}
