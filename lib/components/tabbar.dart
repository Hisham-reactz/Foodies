import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TabBarloop extends StatelessWidget {
// This widget is the root of your application.
  final data;
  TabBarloop({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: data["tab"],
      isScrollable: true,
      labelColor: Color(0xFFD63458),
      labelPadding: EdgeInsets.fromLTRB(5.w, 5.w, 5.w, 0),
      indicatorColor: Color(0xFFD63458),
      tabs: data["tablist"]
          .map<Widget>((d) => Tab(
                text: d['menu_category'],
              ))
          .toList(),
    );
  }
}
