import 'dart:async';

import 'package:doubanapp/constant/constant.dart';
import 'package:doubanapp/pages/container_page.dart';
import 'package:doubanapp/util/screen_util.dart';
import 'package:flutter/material.dart';

/// 打开APP首页
class SplashWidget extends StatefulWidget {
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {

  // 包含4个VC
  var containerPage = ContainerPage();
  // 显示广告
  bool showAd = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        /// Offstage 控制是否显示组件  offstage true隐藏不显示  false 显示
        /// Visibility 也能控制显示或者隐藏
        /// Visibility({
        // Key key,
        // @required this.child,
        // this.replacement = const SizedBox.shrink(), //用于替换的Widget，如果不复写那么就是默认空的SizedBox
        // this.visible = true, //控制child 是否可见，当为false的时候显示replacement
        // this.maintainState = false,  //是否在不可见的情况下维护Widgetstate
        // this.maintainAnimation = false, //是否在widget不可见时保持动画
        // this.maintainSize = false,// 是否预留位置
        // this.maintainSemantics = false,// 可访问性
        // this.maintainInteractivity = false, // 是否在隐藏时维持交互
        // }
        /// Offstage是控制组件隐藏/可见的组件，如果感觉有些单调功能不全，我们可以使用Visibility，
        /// Visibility也是控制子组件隐藏/可见的组件。不同是的Visibility有隐藏状态是否留有空间、隐藏状态下是否可调用等功能。
        Offstage(
          child: containerPage,
          offstage: showAd,
        ),
        Offstage(
          offstage: !showAd,
          child: Container(
            width: ScreenUtils.screenW(context),
            height: ScreenUtils.screenH(context),
            child: Stack(
              children: <Widget>[
                /// Align和Center控件都是控制子控件位置的控件。 默认居中对齐
                Align(
                  alignment: Alignment(0.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /// CircleAvatar代表用户的圆圈的控件
                      CircleAvatar(
                        radius: ScreenUtils.screenW(context) / 3,
                        backgroundColor: Colors.white,
                        // AssetImage设置图片
                        backgroundImage: AssetImage(Constant.ASSETS_IMG + 'home.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text('落花有意随流水，流水无心恋落花'),
                      ),
                    ],
                  ),
                ),
                SafeArea(  /// 安全局域， 不会被底部bottomBar StatusBar 遮挡
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment(1.0, 0),
                        child: Container(
                          // color: Colors.red,
                          margin: const EdgeInsets.only(right: 30, top: 20.0),
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                          /// 自定义定时器
                          child: CountDownWidget(
                            /// 子widget 逆向传值，回调出来
                            onCountDownFinishCallBack: (bool value) {
                              if (value) {
                                setState(() {
                                  showAd = false;
                                });
                              }
                            },
                          ),
                          /// 可以设置子控件的背景颜色、形状,圆角，边框， 图片
                          decoration: BoxDecoration(
                            color: Color(0xffEDEDED),
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(Constant.ASSETS_IMG + 'ic_launcher.png', width: 50.0, height: 50.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Hi, 豆芽',
                                style: TextStyle(color: Colors.green, fontSize: 30.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 倒计时widget
class CountDownWidget extends StatefulWidget {

  // 定义一个回调
  final onCountDownFinishCallBack;

  CountDownWidget({Key key, @required this.onCountDownFinishCallBack}) : super(key: key);

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {

  var _seconds = 1;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  _startTimer() {
    /// 创建定时器 & 启动
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds <= 1) {
          widget.onCountDownFinishCallBack(true);
          _cancelTimer();
        }
      });
      _seconds--;
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_seconds', style: TextStyle(fontSize: 17.0));
  }
}


