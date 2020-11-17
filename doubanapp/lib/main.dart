import 'package:doubanapp/pages/splash/splash_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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

    /// 这里初始化一次：：： 设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 此处假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    // ScreenUtil.init(context,designSize: Size(750, 1334), allowFontScaling: false);

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

