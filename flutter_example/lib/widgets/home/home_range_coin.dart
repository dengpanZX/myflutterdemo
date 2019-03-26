import 'package:flutter/material.dart';
import 'package:flutter_example/common/constant.dart';
import 'package:flutter_example/utils/net_utils.dart';
import 'package:flutter_example/model/ranking_coin_item.dart';

class HomeRangeCoin extends StatefulWidget {
  @override
  _HomeRangeCoin createState() {
    return _HomeRangeCoin();
  }
}

class _HomeRangeCoin extends State<HomeRangeCoin> {
  int _selectIndex = -1;
  List<RankCoinItem> _resultList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestData();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        buildTitle(),
        new Container(
          height: 510,
          color: Colors.white,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _resultList.length,
            itemBuilder: (BuildContext context, int index) =>
                listItemBuild(context, index),
          ),
        )
      ],
    );
  }

  Widget buildTitle() {
    return new Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(top: 9),
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        color: Colors.white,
        height: 40,
        child: Row(
          children: <Widget>[
            Image.asset('assets/images/homepage_or.png'),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                '涨幅榜',
                style: TextStyle(color: Color(0xFF091224), fontSize: 15),
              ),
            )
          ],
        ));
  }

  Widget listItemBuild(BuildContext context, int index) {
    return new GestureDetector(
      onTap: () {
        setState(() {
          _selectIndex = index;
        });
      },
      child: Container(
        height: 51,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        color: _selectIndex == index ? Color(0xffEEEEEE) : Colors.white,
        child: Center(
          child: new Row(
            children: <Widget>[
              Text("${index + 1}.",
                  style: TextStyle(color: Color(0xff999999), fontSize: 15)),
              _coinNameBuild(index),
              _coinPirceBuild(index),
              Container(
                  height: 29,
                  width: 76,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(3.0),
                      color: _resultList[index].range == 0
                          ? Color(0xff999999)
                          : _resultList[index].range < 0
                              ? Color(0xffC34935)
                              : Color(0xff2B8A5E)),
                  child: Center(
                    child: Text(_resultList[index].range > 0 ? "+${_resultList[index].range}%" :"${_resultList[index].range}%",
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coinNameBuild(int index) {
    return new Expanded(
        child: Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(_resultList[index].sellName,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff000000),
                            height: 1.2)),
                    Text("/${_resultList[index].buyName}",
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff9999999),
                            height: 1.2)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("24H量",
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff9999999),
                            height: 1.2)),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(_resultList[index].volume.toString(),
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xff9999999),
                              height: 1.2)),
                    )
                  ],
                )
              ],
            )));
  }

  Widget _coinPirceBuild(int index) {
    return new Expanded(
        child: Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_resultList[index].last.toString(),
                    style: TextStyle(
                        fontSize: 14, color: Color(0xff000000), height: 1.2)),
                Text("￥0.66",
                    style: TextStyle(
                        fontSize: 11, color: Color(0xff9999999), height: 1.2)),
              ],
            )));
  }

  void requestData() async {
    var responseList = [];
    var code = 0;
    try {
      var response =
          await NetUtils.get("/trade/market/ranking/10");
      print(Constants.TAG + response.toString());
      code = response['code'];
      if (code == 1) {
        responseList = response['data'];
        setState(() {
          for (var responseItem in responseList) {
            RankCoinItem item = new RankCoinItem.fromJson(responseItem);
            _resultList.add(item);
          }
        });
      }
    } catch (e) {
      print(Constants.TAG + e.toString());
    }
  }
}
