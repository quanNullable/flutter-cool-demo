import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class DemoPage17 extends StatefulWidget {
  @override
  _DemoPage17State createState() => _DemoPage17State();
}

class RadioGroup extends StatefulWidget {
  final List<String> titles;

  final ValueChanged<int> onIndexChanged;

  const RadioGroup({Key key, this.titles, this.onIndexChanged}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RadioGroupState();
  }
}

class _RadioGroupState extends State<RadioGroup> {
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < widget.titles.length; ++i) {
      list.add(((String title, int index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Radio<int>(
                value: index,
                groupValue: _index,
                onChanged: (int index) {
                  setState(() {
                    _index = index;
                    widget.onIndexChanged(_index);
                  });
                }),
            Text(title)
          ],
        );
      })(widget.titles[i], i));
    }

    return Wrap(
      children: list,
    );
  }
}

class _DemoPage17State extends State<DemoPage17> {
  int _index = 1;

  double size = 20.0;
  double activeSize = 30.0;

  PageController controller;

  PageIndicatorLayout layout = PageIndicatorLayout.SLIDE;

  List<PageIndicatorLayout> layouts = PageIndicatorLayout.values;

  bool loop = false;

  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  @override
  void didUpdateWidget(DemoPage17 oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Container(
        color: Colors.red,
      ),
      Container(
        color: Colors.green,
      ),
      Container(
        color: Colors.blueAccent,
      ),
      Container(
        color: Colors.grey,
      )
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text('page_indicator'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Checkbox(
                    value: loop,
                    onChanged: (bool value) {
                      setState(() {
                        if (value) {
                          controller = TransformerPageController(itemCount: 4, loop: true);
                        } else {
                          controller = PageController(
                            initialPage: 0,
                          );
                        }
                        loop = value;
                      });
                    }),
                Text("loop"),
              ],
            ),
            RadioGroup(
              titles: layouts.map((s) {
                var str = s.toString();
                return str.substring(str.indexOf(".") + 1);
              }).toList(),
              onIndexChanged: (int index) {
                setState(() {
                  _index = index;
                  layout = layouts[index];
                });
              },
            ),
            Expanded(
                child: Stack(
              children: <Widget>[
                loop
                    ? TransformerPageView.children(
                        children: children,
                        pageController: controller,
                      )
                    : PageView(
                        controller: controller,
                        children: children,
                      ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: PageIndicator(
                      layout: layout,
                      size: size,
                      activeSize: activeSize,
                      controller: controller,
                      space: 5.0,
                      count: 4,
                    ),
                  ),
                )
              ],
            ))
          ],
        ));
  }
}
