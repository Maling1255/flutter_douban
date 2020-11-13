import 'package:doubanapp/pages/splash/splash_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';


void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    /// 设置andriod头部的导航栏透明
    SystemUiOverlayStyle stysemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(stysemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: MaterialApp(
        /// 关闭 DEBUG 标签🏷
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.white,
          /// 去掉选中navigationItem高亮背景水波效果
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SplashWidget(),
        ),
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({Key key, @required this.child}) : assert(child != null), super(key: key);

  // 类方法
  static restartApp(BuildContext context) {
    /// 读取到状态
    final _RestartWidgetState state = context.findAncestorStateOfType<_RestartWidgetState>();
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {

  // 唯一的key
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();  // 重新获取唯一的key
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}

