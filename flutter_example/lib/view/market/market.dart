import 'package:flutter/material.dart';
import 'package:flutter_example/common/constant.dart';
import 'package:flutter_example/utils/net_utils.dart';
import 'package:flutter_example/model/market_title_item.dart';
import 'package:flutter_example/view/market/market_area.dart';

class Market extends StatefulWidget {
  @override
  _Market createState() {
    return _Market();
  }
}

class _Market extends State<Market> with SingleTickerProviderStateMixin {
  TabController _controller;
  List<MarketTitleItem> _resultList = new List();
  final List<Tab> myTabs = <Tab>[
    new Tab(text: '主区'),
    new Tab(text: '链改区'),
    new Tab(text: '孵化区'),
    new Tab(text: '创新区'),
    new Tab(text: '自选区'),
    new Tab(text: '排行榜'),
  ];

  @override
  void initState() {
    super.initState();
    _requestMarketTitle();
  }

  @override
  Widget build(BuildContext context) {
    if (_resultList.length > 0 ) {
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                elevation: 1,
                brightness: Brightness.light,
                bottom: new PreferredSize(
                    child: new Container(
                      //去掉点击背景
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                      ),
                      height: 46,
                      child: new TabBar(
                        tabs: myTabs,
                        controller: _controller,
                        labelColor: Color(0xff091224),
                        unselectedLabelColor: Color(0xff999999),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 1,
                        indicatorColor: Colors.black,
                        labelStyle:
                        TextStyle(fontSize: 14, color: Color(0xff091224)),
                        unselectedLabelStyle:
                        TextStyle(fontSize: 14, color: Color(0xff999999)),
                        isScrollable: true,
                        labelPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      ),
                    ),
                    preferredSize: null),
                title: new Image.asset('assets/images/bit.png')),
            preferredSize: Size.fromHeight(84)),
        body: new TabBarView(
          controller: _controller,
          children: _resultList.map((MarketTitleItem item) {
            return new MarketArea(areaId: item.id);
          }).toList(),
        ),
      );
    } else {
      return Container();
    }
  }

  void _requestMarketTitle() async{
    var responseList = [];
    var code = 0;
    myTabs.clear();
    try {
      var response = await NetUtils.get("/identity/dictionary/list/range");
      print(Constants.TAG + response.toString());
      code = response['code'];
      if (code == 1) {
        responseList = response['data'];
        setState(() {
          for (var responseItem in responseList) {
            MarketTitleItem item = new MarketTitleItem.fromJson(responseItem);
            myTabs.add(new Tab(text: item.name));
            _resultList.add(item);
          }
          myTabs..add(new Tab(text: "自选区"))
            ..add(new Tab(text: "排行榜"));
          MarketTitleItem itemCollect = new MarketTitleItem();
          itemCollect.id = "collect";
          MarketTitleItem itemRanking = new MarketTitleItem();
          itemRanking.id = "ranking";
          _resultList.add(itemCollect);
          _resultList.add(itemRanking);
        });
        _controller = new TabController(initialIndex: 0, vsync: this, length: myTabs.length);
      }
    } catch (e) {
      print(Constants.TAG + e.toString());
    }
  }
}
