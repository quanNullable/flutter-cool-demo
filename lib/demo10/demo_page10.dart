import 'package:flutter/material.dart';

import 'draggable_widget.dart';

/**
 * Author: Quan
 * Date: 2019-11-12 14:49
 */

class DemoPage10 extends StatefulWidget {
  DemoPage10({Key key}) : super(key: key);

  @override
  _DemoPage10State createState() {
    return _DemoPage10State();
  }
}

class _DemoPage10State extends State<DemoPage10> {
  List<String> names = [
    "LeBron James",
    "Kevin Durant",
    "Anthony Davis",
    "James Harden",
    "Stephen Curry",
    "Jeremy Shuhow Lin"
  ];
  Color _draggableColor = Colors.grey;
  OverlayEntry overlayEntry;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  showOverlay(BuildContext context) async {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
      return;
    }
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Container(
        height: 500,
        child: Stack(
          children: <Widget>[
            DraggableWidget(
              offset: Offset(100.0, 100.0),
              widgetColor: Colors.tealAccent,
            ),
            DraggableWidget(
              offset: Offset(200.0, 100.0),
              widgetColor: Colors.redAccent,
            ),
            Center(
              child: DragTarget(onAccept: (Color color) {
                _draggableColor = color;
              }, builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 200.0,
                  height: 200.0,
                  color: _draggableColor,
                );
              }),
            )
          ],
        ),
      );
    });
    overlayState.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ClipPath(
              clipper: BottomClipper(),
              child: Container(
                color: Colors.deepPurpleAccent,
                height: 150.0,
                child: AppBar(title: Text('ReorderableListViewDemo')),
              )),
          Expanded(
              child: ReorderableListView(
            children: names.map(_buildCard).toList(),
            onReorder: _onReorder,
          ))
        ],
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
            child: Icon(Icons.fiber_smart_record), onPressed: () => showOverlay(context));
      }),
    );
  }

  Widget _buildCard(String name) {
    return SizedBox(
      key: ObjectKey(name),
      height: 100,
      child: Card(
        color: Colors.lightBlueAccent.withOpacity(0.4),
        child: Center(
          child: Text(
            '$name',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex = newIndex - 1;
    var name = names.removeAt(oldIndex);
    names.insert(newIndex, name);
    setState(() {});
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30);

    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 4 * 3, size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 40);

    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
