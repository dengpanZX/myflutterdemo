import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_example/utils/net_utils.dart';
import 'package:flutter_example/common/constant.dart';
import 'package:flutter_example/model/hot_coin_item.dart';

class HomeHotCoin extends StatefulWidget {
  @override
  _HomeHotCoin createState() {
    return _HomeHotCoin();
  }
}

class _HomeHotCoin extends State<HomeHotCoin> {
  int _clickIndex = -1;
  int _pageIndex = 0;
  List<HotCoinItem> _resultList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: 139.0,
      child: new Column(
        children: <Widget>[buildTitle(), buildSwiper()],
      ),
    );
  }

  Widget buildTitle() {
    return Row(
      children: <Widget>[
        Image.asset('assets/images/homepage_hot_currency.png'),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            '热门币种',
            style: TextStyle(color: Color(0xFF091224), fontSize: 15),
          ),
        )
      ],
    );
  }

  Widget buildSwiper() {
    if (_resultList.length > 0) {
      return Container(
          height: 100,
          child: Swiper(
            itemBuilder: _swiperBuilder,
            itemCount: (_resultList.length / 3).ceil(),
            viewportFraction: 1,
            scale: 1,
            onIndexChanged: (index) {
              _pageIndex = index;
            },
            pagination: new SwiperPagination(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 10),
                builder: DotSwiperPaginationBuilder(
                    color: Color(0xffe3e3e3),
                    activeColor: Color(0xff091224),
                    size: 5,
                    activeSize: 5)),
            scrollDirection: Axis.horizontal,
            autoplay: true,
          ));
    } else {
      return Container(height: 100);
    }
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _coinInfoBuilder(_pageIndex * 3 + 0),
        _coinInfoBuilder(_pageIndex * 3 + 1),
        _coinInfoBuilder(_pageIndex * 3 + 2)
      ],
    );
  }

  Widget _coinInfoBuilder(int position) {
    if (position < _resultList.length) {
      return GestureDetector(
          onTap: () {
            setState(() {
              _clickIndex = position;
            });
          },
          child: new Container(
            margin: EdgeInsets.fromLTRB(5, 10, 0, 10),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            color: _clickIndex == position ? Color(0xffF0F0F0) : Colors.white,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "${_resultList[position].sellName}/${_resultList[position].buyName}",
                  style: TextStyle(
                      color: Color(0xff333333), fontSize: 12, height: 1.2),
                ),
                new Text(
                  "${_resultList[position].last}",
                  style: TextStyle(
                      color: _resultList[position].range == 0
                          ? Color(0xff999999)
                          : _resultList[position].range < 0
                              ? Color(0xffC34935)
                              : Color(0xff2B8A5E),
                      fontSize: 18,
                      height: 1.2),
                ),
                new Text(_resultList[position].range > 0 ? "+${_resultList[position].range}%" :"${_resultList[position].range}%",
                  style: TextStyle(
                      color: _resultList[position].range == 0
                          ? Color(0xff999999)
                          : _resultList[position].range < 0
                              ? Color(0xffC34935)
                              : Color(0xff2B8A5E),
                      fontSize: 12,
                      height: 1.2),
                ),
                new Text(
                  "≈24001.21 CNY",
                  style: TextStyle(
                      color: Color(0xff999999), fontSize: 12, height: 1.2),
                ),
              ],
            ),
          ));
    } else {
      return new Container();
    }
  }

  void setClickPosition(int position) {
    setState(() {
      _clickIndex = position;
    });
  }

  void requestData() async {
    final _param = {"isHot": 1};
    var responseList = [];
    var code = 0;
    try {
      var response = await NetUtils.get("/trade/tradePair/simplePage",
          params: _param);
      code = response['code'];
      if (code == 1) {
        responseList = response['rows'];
        setState(() {
          for (var responseItem in responseList) {
            HotCoinItem item = new HotCoinItem.fromJson(responseItem);
            _resultList.add(item);
          }
        });
      }
    } catch (e) {
      print(Constants.TAG + e.toString());
    }
  }
}
