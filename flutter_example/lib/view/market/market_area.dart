import 'package:flutter/material.dart';
import 'package:flutter_example/common/constant.dart';
import 'package:flutter_example/utils/net_utils.dart';
import 'package:flutter_example/model/ranking_coin_item.dart';

class MarketArea extends StatefulWidget {
  MarketArea({Key key, @required this.areaId}) : super(key: key);
  final String areaId;

  @override
  _MarketArea createState() {
    return _MarketArea();
  }
}

class _MarketArea extends State<MarketArea> {
  List<RankCoinItem> _resultList = new List();
  int _selectIndex = -1;
  bool isLoading = true;
  int currentPage = 0;
  var isFirstLoad = true;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var position = _scrollController.position;
      // 小于50px时，触发上拉加载；
      if (position.maxScrollExtent - position.pixels < 50) {
        _loadMore();
      }
    });
      _requestData();
  }

  @override
  Widget build(BuildContext context) {
    if (_resultList.length > 0) {
      return RefreshIndicator(
        child: ListView.builder(
          controller: _scrollController,
          physics: new AlwaysScrollableScrollPhysics(),
          itemCount: _resultList.length == 0
              ? 0
              : !isLoading ? _resultList.length + 1 : _resultList.length,
          itemBuilder: (BuildContext context, int index) =>
              listItemBuild(context, index),
        ),
        onRefresh: _requestData,
      );
    } else {
      if (isFirstLoad) {
        isFirstLoad = false;
        return new Container(
          color: Colors.white,
//          child: new Center(
//            child: new CircularProgressIndicator(),
//          ),
        );
      } else {
        return new Container(color: Colors.white, child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/no_data.png"),
              Text("暂无数据",
                  style: TextStyle(color: Color(0xFF333333), fontSize: 15))
            ],
          ),
        ),);
      }
    }
  }

  Widget listItemBuild(BuildContext context, int index) {
    if (index < _resultList.length) {
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
                new Image.network(
                  Constants.IMAGE_BASE_URL + _resultList[index].logo,
                  width: 16,
                  height: 16,
                ),
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
                      child: Text(
                          _resultList[index].range > 0
                              ? "+${_resultList[index].range}%"
                              : "${_resultList[index].range}%",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                    )),
              ],
            ),
          ),
        ),
      );
    }
    return _getMoreWidget();
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

  void _loadMore() async {
    if (!isLoading) {
      setState(() {});
      Future.delayed(Duration(milliseconds: 200), () {
        isLoading = true;
        _requestData();
      });
    }
  }

  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                '加载中...',
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestData() async {
    var responseList = [];
    var code = 0;
    var response;
    try {
      if ("collect" == widget.areaId) {
        response = await NetUtils.get("/trade/collectTradePair");
      } else if ("ranking" == widget.areaId) {
        response = await NetUtils.get("/trade/market/ranking/20");
      } else {
        currentPage++;
        Map<String, dynamic> map = {
          "tradeVersionId": widget.areaId,
          "size": 20,
          "current": currentPage
        };
        response =
            await NetUtils.get("/trade/tradePair/simplePage", params: map);
      }
      isLoading = true;
      code = response['code'];
      if (code == 1) {
        if ("collect" == widget.areaId || "ranking" == widget.areaId)
          responseList = response['data'];
        else
          responseList = response['rows'];
        if (responseList.length > 0) {
          for (var responseItem in responseList) {
            RankCoinItem item = new RankCoinItem.fromJson(responseItem);
            _resultList.add(item);
          }
          if ("collect" != widget.areaId &&
              "ranking" != widget.areaId &&
              _resultList.length == currentPage * 20) isLoading = false;
        }
      }
    } catch (e) {
      print(Constants.TAG + e.toString());
    } finally {
      setState(() {

      });
    }
  }
}
