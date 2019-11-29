import 'package:flutter/material.dart';

/**
 * Author: Quan
 * Date: 2019-11-12 14:49
 */
class DemoPage8 extends StatefulWidget {
  DemoPage8({Key key}) : super(key: key);

  @override
  _DemoPage8State createState() => _DemoPage8State();
}

class _DemoPage8State extends State<DemoPage8> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _date) print("data selectied :${_date.toString()}");
    setState(() {
      _date = picked;
    });

    if (picked == null) _date = DateTime.now();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != _time) print("data selectied :${_time.toString()}");
    setState(() {
      _time = picked;
    });
    if (picked == null) _time = TimeOfDay.now();
  }

  final List<InputEntry> _lists = <InputEntry>[
    const InputEntry('android', 'A'),
    const InputEntry('java', 'J'),
    const InputEntry('php', 'P'),
    const InputEntry('web', 'W'),
  ];

  Iterable<Widget> get _rawChipWidget sync* {
    for (InputEntry value in _lists) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: RawChip(
          avatar: CircleAvatar(
            backgroundColor: Colors.redAccent.shade400,
            child: Text(value.initials),
          ),
          label: Text(value.name),
          onDeleted: () {
            // _inputs.add(value.name);
            setState(() {
              _lists.remove(value);
            });
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 100.0,
              ),
              padding: const EdgeInsets.all(8.0),
              color: Colors.teal.shade700,
              alignment: Alignment.center,
              child: Text('Hello World',
                  style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white)),
              foregroundDecoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/test.jpg'),
                  centerSlice: Rect.fromLTRB(370.0, 180.0, 1360.0, 530.0),
                ),
              ),
              transform: Matrix4.rotationZ(0.1),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(50.0),
                  1: FixedColumnWidth(100.0),
                  2: FixedColumnWidth(50.0),
                  3: FixedColumnWidth(100.0),
                },
                border: TableBorder.all(color: Colors.red, width: 1.0, style: BorderStyle.solid),
                children: const [
                  TableRow(
                    children: [
                      Text('A1'),
                      Text('B1'),
                      Text('C1'),
                      Text('D1'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('A2'),
                      Text('B2'),
                      Text('C2'),
                      Text('D2'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('A3'),
                      Text('B3'),
                      Text('C3'),
                      Text('D3'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  IconTheme(
                    //opacity: 设置透明
                    data: IconThemeData(
                      color: Colors.pink,
                      opacity: 0.6,
                    ),
                    child: Icon(Icons.favorite),
                  ),
                  IconTheme(
                    //opacity: 设置透明
                    data: IconThemeData(
                      color: Colors.pink,
                      opacity: 0.8,
                    ),
                    child: Icon(Icons.favorite),
                  ),
                  IconTheme(
                    //opacity: 设置透明
                    data: IconThemeData(
                      color: Colors.pink,
                      opacity: 1.0,
                    ),
                    child: Icon(Icons.favorite),
                  )
                ],
              ),
            ),
            Container(
                height: 60,
                alignment: Alignment.center,
                child: AppBar(
                  title: Text('My Fancy Dress'),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.playlist_play),
                      tooltip: 'Air it',
                      onPressed: () => {},
                    ),
                    IconButton(
                      icon: Icon(Icons.playlist_add),
                      tooltip: 'Restitch it',
                      onPressed: () => {},
                    ),
                    IconButton(
                      icon: Icon(Icons.playlist_add_check),
                      tooltip: 'Repair it',
                      onPressed: () => {},
                    ),
                  ],
                )),
            Container(
                height: 60,
                margin: EdgeInsets.only(top: 50),
                child: Scaffold(
                  //appBar: AppBar(title: const Text('Bottom App Bar')),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {},
                  ),
                  bottomNavigationBar: BottomAppBar(
                    shape: CircularNotchedRectangle(),
                    notchMargin: 10.0, // FloatingActionButton和BottomAppBar 之间的差距
                    color: Colors.pink,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                )),
            Builder(
                builder: (BuildContext context) => GestureDetector(
                      onTap: () {
                        final snackBar = SnackBar(
                          content: Text('这是一个SnackBar, 右侧有SnackBarAction'),
                          backgroundColor: Colors.red,
                          action: SnackBarAction(
                            // 提示信息上添加一个撤消的按钮
                            textColor: Colors.black,
                            label: '撤消',
                            onPressed: () {
                              // Some code to undo the change!
                            },
                          ),
                          duration: Duration(minutes: 1), // 持续时间
                          //animation,
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      child: Text('显示SnackBar'),
                    )),
            Container(
                height: 300.0,
                child: Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 150.0,
                          floating: false,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              title: Text("Collapsing Toolbar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  )),
                              background: Image.network(
                                "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                                fit: BoxFit.cover,

                                /// 色彩叠加  UI可以理解为两个色彩涂层，在图片混合一个色层
                                // color: Colors.redAccent,  //混合的颜色
                                // colorBlendMode: BlendMode.darken,  //混合方式

                                ///图片重复填充容器
                                // repeat: ImageRepeat.repeat,
                              )),
                        ),
                      ];
                    },
                    body: Center(
                      child: Text("向上提拉 ⬆ 查看效果..."),
                    ),
                  ),
                )),
            Text('日期选择'),
            RaisedButton(
              child: Text('date selected:${_date.toString()}'),
              onPressed: () {
                _selectDate(context);
              },
            ),
            Text('时间选择'),
            RaisedButton(
              child: Text('date selected:${_time.toString()}'),
              onPressed: () {
                _selectTime(context);
              },
            ),
            Wrap(
              children: _rawChipWidget.toList(),
            )
          ],
        ),
      ),
    );
  }
}

class InputEntry {
  final String name;
  final String initials;
  const InputEntry(this.name, this.initials);
}
