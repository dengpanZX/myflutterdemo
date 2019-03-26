/*
 * Created by 李卓原 on 2018/9/19.
 * email: zhuoyuan93@gmail.com
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SwiperPage extends StatefulWidget {
  @override
  SwiperPageState createState() {
    return SwiperPageState();
  }
}

class SwiperPageState extends State<SwiperPage> {
  List<Widget> mImages = new List();

  @override
  void initState() {
    super.initState();
    mImages..add(Image.asset('assets/images/banner_first.jpg'))
    ..add(Image.asset('assets/images/banner_second.jpg'))
    ..add(Image.asset('assets/images/banner_third.jpg'))
    ..add(Image.asset('assets/images/banner_fourth.png'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 140.0,
      child: Swiper(
        itemBuilder: _swiperBuilder,
        itemCount: 4,
        viewportFraction: 0.8,
        scale: 0.9,
        pagination: new SwiperPagination(
          margin: EdgeInsets.only(bottom: 15),
            builder: DotSwiperPaginationBuilder(
                color: Colors.white70,
                activeColor: Colors.white,
                size: 5,
                activeSize: 5)),
        scrollDirection: Axis.horizontal,
        autoplay: true,
      ),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (mImages[index]);
  }
}
