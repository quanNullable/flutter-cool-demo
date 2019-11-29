import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' as mat show Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:flutter_image_editor_demo/demo9/trim_path.dart';

import 'dash_path.dart';

class CommonPainter extends StatefulWidget {
  final PainterController painterController;

  CommonPainter(PainterController painterController)
      : this.painterController = painterController,
        super(key: ValueKey<PainterController>(painterController));

  @override
  _CommonPainterState createState() => _CommonPainterState();
}

class _CommonPainterState extends State<CommonPainter> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.painterController._globalKey = _globalKey;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = CustomPaint(
      willChange: true,
      painter: _PainterPainter(
        widget.painterController._pathHistory,
        repaint: widget.painterController,
      ),
    );
    child = ClipRect(child: child);
    if (widget.painterController.backgroundImage == null) {
      child = RepaintBoundary(
        key: _globalKey,
        child: GestureDetector(
          child: child,
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
        ),
      );
    } else {
      child = RepaintBoundary(
        key: _globalKey,
        child: Stack(
          alignment: FractionalOffset.center,
          fit: StackFit.expand,
          children: <Widget>[
            widget.painterController.backgroundImage,
            GestureDetector(
              child: child,
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
            )
          ],
        ),
      );
    }
    return Container(
      child: child,
      width: double.infinity,
      height: double.infinity,
    );
  }

  void _onPanStart(DragStartDetails start) {
    Offset pos = (context.findRenderObject() as RenderBox).globalToLocal(start.globalPosition);
    widget.painterController._pathHistory.add(pos);
    widget.painterController._notifyListeners();
  }

  void _onPanUpdate(DragUpdateDetails update) {
    Offset pos = (context.findRenderObject() as RenderBox).globalToLocal(update.globalPosition);
    widget.painterController._pathHistory.updateCurrent(pos);
    widget.painterController._notifyListeners();
  }

  void _onPanEnd(DragEndDetails end) {
    widget.painterController._pathHistory.endCurrent();
    widget.painterController._notifyListeners();
  }
}

class _PainterPainter extends CustomPainter {
  final _PathHistory _path;

  _PainterPainter(this._path, {Listenable repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_PainterPainter oldDelegate) => true;
}

class _PathHistory {
  List<MapEntry<Path, Paint>> _paths;
  List<MapEntry<Path, Paint>> _undone;
  List<Offset> _points = [];
  MyPaint currentPaint;
  MyPaint _backgroundPaint;
  bool _inDrag;
  double _startX; //start X with a tap
  double _startY; //start Y with a tap
  bool _startFlag = false;
  bool _erase = false;
  double _eraseArea = 1.0;
  bool _pathFound = false;

  _PathHistory() {
    _paths = List<MapEntry<Path, Paint>>();
    _undone = List<MapEntry<Path, Paint>>();
    _inDrag = false;
    _backgroundPaint = MyPaint();
  }

  bool canUndo() => _paths.length > 0;

  bool get erase => _erase;
  set erase(bool e) {
    _erase = e;
  }

  set eraseArea(double r) {
    _eraseArea = r;
  }

  void undo() {
    if (!_inDrag && canUndo()) {
      _undone.add(_paths.removeLast());
    }
  }

  bool canRedo() => _undone.length > 0;

  void redo() {
    if (!_inDrag && canRedo()) {
      _paths.add(_undone.removeLast());
    }
  }

  void clear() {
    if (!_inDrag) {
      _paths.clear();
      _undone.clear();
    }
  }

  set backgroundColor(color) => _backgroundPaint.color = color;

  void add(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;
      MyPath path = MyPath();
      path.points.add(startPoint);
      path.moveTo(startPoint.dx, startPoint.dy);
      _startX = startPoint.dx;
      _startY = startPoint.dy;
      _startFlag = true;
      _paths.add(MapEntry<Path, Paint>(path, currentPaint));
    }
  }

  void updateCurrent(Offset nextPoint) {
    if (_inDrag) {
      _pathFound = false;
      if (!_erase) {
        MyPath path = _paths.last.key;
        path.points.add(nextPoint);
        path.lineTo(nextPoint.dx, nextPoint.dy);
        _startFlag = false;
      } else {
        for (int i = 0; i < _paths.length; i++) {
          _pathFound = false;
          for (double x = nextPoint.dx - _eraseArea; x <= nextPoint.dx + _eraseArea; x++) {
            for (double y = nextPoint.dy - _eraseArea; y <= nextPoint.dy + _eraseArea; y++) {
              if (_paths[i].key.contains(Offset(x, y))) {
                _undone.add(_paths.removeAt(i));
                i--;
                _pathFound = true;
                break;
              }
            }
            if (_pathFound) {
              break;
            }
          }
        }
      }
    }
  }

  void endCurrent() {
    MyPath path = _paths.last.key;
    if ((_startFlag) && (!_erase)) {
      //if it was just a tap, draw a point and reset a flag
      path.addOval(Rect.fromCircle(center: Offset(_startX, _startY), radius: 1.0));
      _startFlag = false;
    }
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _backgroundPaint);
    for (MapEntry<Path, Paint> pathItem in _paths) {
      MyPaint paint = pathItem.value;
      MyPath path = pathItem.key;
      switch (paint.paintMode) {
        case PAINT_MODE.PEN:
          canvas.drawPath(path, paint);
          break;
        case PAINT_MODE.POINT:
          canvas.drawPoints(PointMode.points, path.points, paint);
          break;
        case PAINT_MODE.DASH:
          canvas.drawPath(
              dashPath(
                path,
                dashArray: CircularIntervalList<double>(<double>[15, 5]),
              ),
              paint);
          break;
        case PAINT_MODE.TRIM:
          canvas.drawPath(trimPath(path, 0.6, firstOnly: false), paint);
          break;
      }
    }
  }
}

class PainterController extends ChangeNotifier {
  Color _drawColor = Color.fromARGB(255, 0, 0, 0);
  Color _backgroundColor = Color.fromARGB(255, 255, 255, 255);
  mat.Image _bgimage;

  double _thickness = 1.0;
  double _erasethickness = 1.0;
  _PathHistory _pathHistory;
  GlobalKey _globalKey;
  PAINT_MODE _paintMode;

  PainterController() {
    _pathHistory = _PathHistory();
  }

  Color get drawColor => _drawColor;

  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  set paintMode(PAINT_MODE mode) {
    _paintMode = mode;
    _updatePaint();
  }

  PAINT_MODE get paintMode => _paintMode;

  Color get backgroundColor => _backgroundColor;

  set backgroundColor(Color color) {
    _backgroundColor = color;
    _updatePaint();
  }

  mat.Image get backgroundImage => _bgimage;

  set backgroundImage(mat.Image image) {
    _bgimage = image;
    _updatePaint();
  }

  double get thickness => _thickness;

  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  double get eraseThickness => _erasethickness;

  set eraseThickness(double t) {
    _erasethickness = t;
    _pathHistory._eraseArea = t;
    _updatePaint();
  }

  bool get eraser => _pathHistory.erase; //setter / getter for eraser
  set eraser(bool e) {
    _pathHistory.erase = e;
    _pathHistory._eraseArea = _erasethickness;
    _updatePaint();
  }

  void _updatePaint() {
    MyPaint paint = MyPaint();
    paint.paintMode = _paintMode;
    paint.color = drawColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = thickness;
    _pathHistory.currentPaint = paint;
    if (_bgimage != null) {
      _pathHistory.backgroundColor = Color(0x00000000);
    } else {
      _pathHistory.backgroundColor = _backgroundColor;
    }
    notifyListeners();
  }

  void undo() {
    _pathHistory.undo();
    notifyListeners();
  }

  void redo() {
    _pathHistory.redo();
    notifyListeners();
  }

  bool get canUndo => _pathHistory.canUndo();

  bool get canRedo => _pathHistory.canRedo();

  void _notifyListeners() {
    notifyListeners();
  }

  void clear() {
    _pathHistory.clear();
    notifyListeners();
  }

  Future<Uint8List> exportAsPNGBytes() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
    Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }
}

enum PAINT_MODE {
  PEN, //钢笔
  POINT, //喷墨
  DASH, //虚线
  TRIM
}

class MyPaint extends Paint {
  PAINT_MODE paintMode;
  MyPaint({this.paintMode = PAINT_MODE.PEN}) : super();
}

class MyPath extends Path {
  List<Offset> points = [];
}
