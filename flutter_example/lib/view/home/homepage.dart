import 'package:flutter/material.dart';
import '../../widgets//home/SwiperPage.dart';
import '../../widgets/home/home_notice.dart';
import '../../widgets/home/home_hotcoin.dart';
import '../../widgets/home/home_range_coin.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          brightness: Brightness.light,
          elevation: 1,
          title: new Image.asset('assets/images/bit.png')),
      body: ListView(
        children: <Widget>[
          SwiperPage(),
          HomeNotice(),
          HomeHotCoin(),
          HomeRangeCoin()
        ],
      ),
    );
  }
}
