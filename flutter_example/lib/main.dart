import 'package:flutter/material.dart';
import 'view/home/homepage.dart';
import 'view/market/market.dart';
import 'view/trade/trade.dart';
import 'package:flutter/services.dart';
import 'view/order/ThemePage.dart';
import 'rxdart/bloc_provider.dart';
import 'theme/themes.dart';

void main() {
  runApp(BlocProvider(child: new MyApp(),));
// 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

const int ThemeColor = 0xFFC91B3A;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Widget _builder(BuildContext context, AsyncSnapshot snapshot) {
    return MaterialApp(
      theme: snapshot.data ? AppTheme().darkTheme : AppTheme().lightTheme,
      home: MainPage(),
    );
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
}

class MainPage extends StatefulWidget {

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin {
  int _tabIndex = -1;
  var tabImages;
  var appBarTitles = ['首页', '行情', '交易', '订单', '我'];
  TabController controller;


  @override
  void initState() {
    super.initState();
    _initTabIndex();
    controller = new TabController(initialIndex: 0, vsync: this, length: 5);
    controller.addListener(() {
      if (controller.indexIsChanging) {
        _onTabChange();
      }
    });
  }

  /*
   * 根据image路径获取图片
   * 这个图片的路径需要在 pubspec.yaml 中去定义
   */
  Image getTabImage(path) {
    return new Image.asset(path);
  }

  /*
   * 根据索引获得对应的normal或是press的icon
   */
  Image getTabIcon(int curIndex) {
    if (_tabIndex == -1 || curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(color: const Color(0xff091224), fontSize: 12));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(color: const Color(0xff666666), fontSize: 12));
    }
  }

  /*
   * 存储的四个页面，和Fragment一样
   */
  var _bodys;

  void initData() {
    /*
      bottom的按压图片
     */
    tabImages = [
      [
        getTabImage('assets/images/homepage.png'),
        getTabImage('assets/images/homepage_select.png')
      ],
      [
        getTabImage('assets/images/market.png'),
        getTabImage('assets/images/market_select.png')
      ],
      [
        getTabImage('assets/images/trade.png'),
        getTabImage('assets/images/trade_select.png')
      ],
      [
        getTabImage('assets/images/order.png'),
        getTabImage('assets/images/order_select.png')
      ],
      [
        getTabImage('assets/images/mine.png'),
        getTabImage('assets/images/mine_select.png')
      ]
    ];

    _bodys = [
      new HomePage(),
      new Market(),
      new Trade(),
      new ThemePage(),
      new HomePage()
    ];
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
    initData();
    // TODO: implement build
    return Scaffold(
        body: new TabBarView(
          controller: controller,
          children: _bodys,
          // 禁止左右滑动
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: new Material(
            child: SafeArea(
          child: Container(
            height: 65.0,
            decoration: BoxDecoration(
              color: snapshot.data ? Colors.black :const Color(0xFFFFFFFF),
            ),
            child: new TabBar(
              indicatorColor: Colors.white,
              controller: controller,
              labelColor: const Color(0xFF091224),
              unselectedLabelColor: const Color(0xFF666666),
              tabs: [
                new Tab(icon: getTabIcon(0), text: appBarTitles[0]),
                new Tab(icon: getTabIcon(1), text: appBarTitles[1]),
                new Tab(icon: getTabIcon(2), text: appBarTitles[2]),
                new Tab(icon: getTabIcon(3), text: appBarTitles[3]),
                new Tab(icon: getTabIcon(4), text: appBarTitles[4])
              ],
            ),
          ),
        )));
  }

  void _onTabChange() {
    if (this.mounted) {
      this.setState(() {
        _tabIndex = controller.index;
      });
    }
  }

  /**
   * 将图片在初始化前都显示一编，避免闪动
   */
  void _initTabIndex() async{
    await new Future.delayed(new Duration(milliseconds: 300));
    setState(() {
      _tabIndex = 1;
    });
    await new Future.delayed(new Duration(milliseconds: 300));
    setState(() {
      _tabIndex = 0;
    });
  }
}
