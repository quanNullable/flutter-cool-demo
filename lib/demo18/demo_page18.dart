import 'package:flutter/material.dart';

import 'demos/city_select.dart';
import 'demos/city_select_custom_header.dart';
import 'demos/contact_list.dart';
import 'demos/index_suspension.dart';
import 'demos/page_scaffold.dart';

class DemoPage18 extends StatefulWidget {
  @override
  _DemoPage18State createState() => _DemoPage18State();
}

class _DemoPage18State extends State<DemoPage18> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AzListView example app'),
      ),
      body: ListPage([
        PageInfo("City Select", (ctx) => CitySelectRoute()),
        PageInfo("City Select(Custom header)", (ctx) => CitySelectCustomHeaderRoute()),
        PageInfo("Contacts List", (ctx) => ContactListRoute()),
        PageInfo("IndexBar & SuspensionView", (ctx) => IndexSuspensionRoute()),
      ]),
    );
  }
}
