import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'colour_pen/water_brush_paint.dart';
import 'common_painter.dart';

/**
 * Author: Quan
 * Date: 2019-11-12 14:49
 */

class DemoPage9 extends StatefulWidget {
  DemoPage9({Key key}) : super(key: key);

  @override
  _DemoPage9State createState() {
    return _DemoPage9State();
  }
}

class _DemoPage9State extends State<DemoPage9> {
  bool _finished;
  PainterController _controller;
  PAINT_MODE _selectedMode = PAINT_MODE.PEN;

  @override
  void initState() {
    super.initState();
    _finished = false;
    _controller = newController();
  }

  PainterController newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.green;
    controller.backgroundImage = Image.asset('assets/image/test.jpg');
    controller.paintMode = _selectedMode;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.content_copy),
          tooltip: '新建',
          onPressed: () => setState(() {
            _finished = false;
            _controller = newController();
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        DropdownButton(
          value: _selectedMode,
          items: [
            DropdownMenuItem(
                value: PAINT_MODE.PEN,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.edit), Text('钢笔')],
                )),
            DropdownMenuItem(
                value: PAINT_MODE.POINT,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.dashboard), Text('点')],
                )),
            DropdownMenuItem(
                value: PAINT_MODE.DASH,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.sort), Text('虚线')],
                )),
            DropdownMenuItem(
                value: PAINT_MODE.TRIM,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.threesixty), Text('蛇')],
                )),
            DropdownMenuItem(
                child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Icon(Icons.brush), Text('毛笔')],
              ),
              onTap: () {
                setState(() {
                  _finished = true;
                });
                Future.delayed(const Duration(milliseconds: 200), () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text('水彩笔'),
                      ),
                      body: Container(
                        child: WaterBrushPaint(),
                      ),
                    );
                  }));
                });
              },
            ))
          ],
          onChanged: (value) {
            if (value == null) {
              return;
            }
            _controller.paintMode = value;
            setState(() {
              _selectedMode = value;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.undo),
          tooltip: '后退',
          onPressed: () {
            if (_controller.canUndo) _controller.undo();
          },
        ),
        IconButton(
          icon: Icon(Icons.redo),
          tooltip: '前进',
          onPressed: () {
            if (_controller.canRedo) _controller.redo();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: '清除',
          onPressed: () => _controller.clear(),
        ),
        IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              setState(() {
                _finished = true;
              });
              Uint8List bytes = await _controller.exportAsPNGBytes();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('预览'),
                  ),
                  body: Container(
                    child: Image.memory(bytes),
                  ),
                );
              }));
            }),
      ];
    }
    return Scaffold(
      appBar: AppBar(
          title: Text('涂鸦'),
          actions: actions,
          bottom: PreferredSize(
            child: DrawBar(_controller),
            preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
          )),
      body: CommonPainter(
        _controller,
      ),
    );
  }
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Container(
              child: Slider(
            value: _controller.thickness,
            onChanged: (value) => setState(() {
              _controller.thickness = value;
            }),
            min: 1.0,
            max: 20.0,
            activeColor: Colors.white,
          ));
        })),
        ColorPickerButton(_controller, false),
        ColorPickerButton(_controller, true),
      ],
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller, this._background);

  @override
  _ColorPickerButtonState createState() => _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_iconData, color: _color),
      tooltip: widget._background ? '更换背景颜色' : '更换画笔颜色',
      onPressed: () => _pickColor(),
    );
  }

  void _pickColor() {
    Color pickerColor = _color;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              alignment: Alignment.center,
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (Color c) => pickerColor = c,
              ));
        }).then((_) {
      if (mounted) {
        setState(() {
          _color = pickerColor;
        });
      }
    });
  }

  Color get _color =>
      widget._background ? widget._controller.backgroundColor : widget._controller.drawColor;

  IconData get _iconData => widget._background ? Icons.aspect_ratio : Icons.border_color;

  set _color(Color color) {
    if (widget._background) {
      widget._controller.backgroundColor = color;
    } else {
      widget._controller.drawColor = color;
    }
  }
}
