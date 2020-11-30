import 'package:doubanapp/pages/splash/splash_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';


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



///这个组件用来重新加载整个child Widget的。当我们需要重启APP的时候，可以使用这个方案
///https://stackoverflow.com/questions/50115311/flutter-how-to-force-an-application-restart-in-production-mode
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

  /// key 唯一的key
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();  // 重新获取唯一的key
    });
  }

  /// 另外还有 GlobalKey， 能够跨 Widget 访问状态
  /// PageStorageKey 能够保存页面存储状态的key
  /// UniqueKey 唯一的key
  ///
  // 1. Key
  // Key 默认是使用 ValueKey
  // Key 有两个子类 LocalKey 和 GlobalKey
  //
  // 2. LocalKey
  //
  // LocalKey 的用途是同一个父 Widget 下的所有子 Widget 进行比较。比如上文提到的例子。
  // Localkey 有三个子类
  //
  // ValueKey：以一个值作为 Key
  // ObjectKey：以一个对象作为 Key。当多个值才能唯一标识的时候，将这多个值组合成一个对象。比如【学校 + 学号】才能唯一标识一个学生。
  // UniqueKey：生成唯一随机数（对象的 Hash 值）作为 Key。注意：如果直接在控件构建的时候生成，那么每次构建都会生成不同的 Key。
  // Valuekey 有个子类：PageStorageKey，专门用于存储页面滚动位置。



  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}

