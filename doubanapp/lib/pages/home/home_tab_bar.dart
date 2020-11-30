// import 'dart:html';

import 'package:doubanapp/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 42.0;

/// 自定义的tabbar

///   PreferredSizeWidget提供指定高度的方法
///   如果没有约束其高度，则会使用PreferredSizeWidget指定的高度
class HomeTabBar extends StatefulWidget implements PreferredSizeWidget {

  final TabBar tabBar;
  /// 是一个过度值， 跟随者滚动变化的值
  final double translate;

  HomeTabBar({Key key, this.tabBar, this.translate}) : super(key: key);

  @override
  _HomeTabBarState createState() => _HomeTabBarState();

  @override
  Size get preferredSize {
    for (Widget item in tabBar.tabs) {
      /// 如果是Tab 类型的判断
      if (item is Tab) {
        final Tab tab = item;
        if (tab.text != null && tab.icon != null) {
          return Size.fromHeight(_kTextAndIconTabHeight + tabBar.indicatorWeight);
        }
      }
      return Size.fromHeight(_kTabHeight + tabBar.indicatorWeight);
    }
  }
}

class _HomeTabBarState extends State<HomeTabBar> {

  double get allHeight => widget.preferredSize.height;

  @override
  Widget build(BuildContext context) {
    var value = ScreenUtils.screenW(context) * 0.75 - 10.0;
    return Stack(
      children: <Widget>[
        Positioned(
          // alignment: Alignment(-0.88, -0.1),
          ///搜索框
          left: 15.0,
          right: value,
          top: getTop(widget.translate),   // 动画指定top
          /// 包装渐隐动画
          child: getOpacityWidget(Container(
            width: 80,
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0, right: 10.0, left: 5.0),
            decoration: BoxDecoration(color: const Color.fromARGB(245, 236, 236, 236), borderRadius: BorderRadius.all(Radius.circular(17.0))),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: const Color.fromARGB(255, 128, 128, 129),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Align(
                      alignment: Alignment(1.0, 0.0),
                      child: Text(
                        '搜索',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: const Color.fromARGB(255, 192, 192, 192)),
                      ),
                    ),
                    onTap: () {
                      // DBRouter.push(context, DBRouter.searchPage, '搜索流浪地球试一试');
                      Logger().i('点击了搜索🔍');
                    },
                  ),
                )
              ],
            ),
          )),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Row(
            children: <Widget>[
              /// flex 权重， 占比
              Expanded(flex: 1, child: Container()),
              Expanded(flex: 3, child: widget.tabBar),
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ),
      ],
    );
  }

  double getTop(double translate) {
    /// 在什么... 之间
    /// 在 Flutter 中，有一种动画类型叫 Tween ，它主要是弥补 AnimationController 动画值只能为 double 类型的不足,，所以需要不同类型的变化值，那么就可以使用 Tween 。。结合上篇的 AnimationController 来使用
    return Tween<double>(begin: allHeight, end: 0.0).transform(widget.translate);
  }

  // 渐隐过度
  Widget getOpacityWidget(Widget child) {
    if (widget.translate == 1) {
      return child;
    }
      return Opacity(
        /// begin 参数 代表 延迟多长时间开始 动画
        /// end 参数 代表 超过多少 直接就是 100% 即直接到动画终点
        /// Interval(0.5, 1.0)
        /// 表示opacity动画从0.5（一半）开始到结束，如果动画时长为6秒，opacity则从第3秒开始。
        opacity: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn).transform(widget.translate),
        child: child,
      );
    }
}
