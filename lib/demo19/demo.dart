import 'package:flutter/material.dart';

import './column-demo.dart';
import './gridview-demo.dart';
import './listview-demo.dart';
import './row-demo.dart';

class DemoPage19 extends StatefulWidget {
  DemoPage19({Key key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<DemoPage19> {
  List<Map> demos = [
    {
      "title": "列表",
      "demo_page": 'ListViewDemo',
    },
    {
      "title": "宫格",
      "demo_page": 'GridViewDemo',
    },
    {
      "title": "column",
      "demo_page": 'ColumnDemo',
    },
    {
      "title": "row",
      "demo_page": 'RowDemo',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_staggered_animations'),
      ),
      body: ListView.separated(
        itemCount: demos.length,
        separatorBuilder: (content, index) {
          return new Divider(
            height: 1,
            color: Color(0xfff5f5f5),
          );
        },
        itemBuilder: (context, index) {
          return ListItem(demos[index]);
        },
      ),
    );
  }

  Widget ListItem(Map item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          switch (item['demo_page']) {
            case 'ListViewDemo':
              return ListViewDemo();
              break;
            case 'GridViewDemo':
              return GridViewDemo();
              break;
            case 'ColumnDemo':
              return ColumnDemo();
              break;
            case 'RowDemo':
              return RowDemo();
              break;
            default:
              return ListViewDemo();
          }
        }));
      },
      child: Container(
        height: 70,
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                item["title"],
                maxLines: 2,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black26,
            )
          ],
        ),
      ),
    );
  }
}
