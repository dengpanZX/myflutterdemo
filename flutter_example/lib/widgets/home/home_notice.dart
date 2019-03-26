import 'package:flutter/material.dart';
import 'package:flutter_example/rxdart/bloc_provider.dart';

class HomeNotice extends StatefulWidget {
  @override
  _HomeNotice createState() {
    return _HomeNotice();
  }
}

class _HomeNotice extends State<HomeNotice> {
  List<String> gridTitles = ['专业报告，深度分析', '平台公告', '社区治理公告', '等待更多'];
  List<Widget> images = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images
      ..add(Image.asset('assets/images/homepage_bbs.png'))
      ..add(Image.asset('assets/images/homepage_platform.png'))
      ..add(Image.asset('assets/images/homepage_report.png'))
      ..add(Image.asset('assets/images/homepage_more.png'));
  }

  onClick(int index) {
  }

  @override
  Widget build(BuildContext context) {
    final themeSelect = BlocProvider.of(context);
    return StreamBuilder(
      builder: _builder,
      stream: themeSelect.value,
      initialData: false,
    );
  }

  @override
  Widget _builder(BuildContext context, AsyncSnapshot snapshot) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 130.0,
        child: new GridView.count(
          physics: NeverScrollableScrollPhysics(),
          //      横轴数量 这里的横轴就是x轴 因为方向是垂直的时候 主轴是垂直的
          crossAxisCount: 2,
          //主轴间隔
          mainAxisSpacing: 2,
          childAspectRatio: 180 / 63,
          //横轴间隔
          crossAxisSpacing: 2,
          children: buildGridItem(snapshot.data),
        ));
  }

  List<Widget> buildGridItem(bool isNight) {
    List<Widget> lists = new List();
    for (int i = 0; i < 4; i++) {
      lists.add(GestureDetector(
          onTap: () {
            onClick(i);
          },
          child: new Container(
              color: isNight ? Colors.blue : Colors.white,
              height: 75.0,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(gridTitles[i],
                      style: new TextStyle(
                          color: const Color(0xff333333), fontSize: 13)),
                  images[i],
                ],
              ))));
    }
    return lists;
  }
}
