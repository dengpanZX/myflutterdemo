import 'package:flutter/material.dart';
import 'package:flutter_example/view/order/ThemePage.dart';

class Trade extends StatefulWidget {
  
  @override
  _trade createState() {
    return _trade();
  }
}

class _trade extends State<Trade> {

  @override
  Widget build(BuildContext context) {
    return new Container(child: Center(
      child: RaisedButton(onPressed: (){Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new ThemePage()));}, child: Text("changeTheme"), ),
    ),);
  }
}