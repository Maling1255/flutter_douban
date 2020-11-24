
import 'dart:ui';

import 'package:doubanapp/pages/home/home_page.dart';
import 'package:doubanapp/pages/movie/my_tab_bar_widget.dart';
import 'package:doubanapp/widgets/part/search_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;


var titleList = ['电影', '电视', '综艺', '读书', '音乐', '同城'];
List<Widget> tablist;
TabController _tabController;  // 控制滚动

///书影音
///包含了'电影', '电视', '综艺', '读书', '音乐', '同城' item Widget
///这个Widget是整个项目中，十分复杂的Widget之一
///
class BookAudioVideoPage extends StatefulWidget {
  @override
  State createState() => _BookAudioVideoPageState();
}

/// SingleTickerProviderStateMixin
/// 混入SingleTickerProviderStateMixin，为了传入vsync对象
/// 用于使用到了一点点的动画效果，因此加入了SingleTickerProviderStateMixin
/// 将' vsync: this '传递给动画控制器的构造函数
class _BookAudioVideoPageState extends State<BookAudioVideoPage> with SingleTickerProviderStateMixin{

  // 电影 电视， 综艺 读书
  var tabBar;

  @override
  void initState() {
    super.initState();
    tabBar = MoviePageTabBar();
    tablist = titleList.map((title) => Text('$title', style: TextStyle(fontSize: 15))).toList();

    ///初始化时创建控制器
    ///通过 with SingleTickerProviderStateMixin 实现动画效果。
    _tabController = TabController(vsync: this, length: tablist.length);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: SafeArea(
        /// 横向滚动的tabController
        child: DefaultTabController(
          initialIndex: 0,  // 默认选中第一个-【电影】
          length: titleList.length,
          child: _getNestedScrollView(tabBar),
        ),
      ),
    );
  }
}

// 包装成nested滚动
Widget _getNestedScrollView(Widget tabbar) {
  String hintText = '用一部电影来形容你的2020';
  /// 可以在其内部嵌套其他滚动视图的滚动视图，其滚动位置是固有链接的
  /// http://laomengit.com/flutter/widgets/NestedScrollView.html#与tabbar配合使用
  return NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {

      /// 这里返回的数组 就是上部分的 'title' widget
      return <Widget>[
        /// 将普通widget包装sliver, 搜索🔍
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            child: SearchTextFieldWidget(
              hintText: hintText,
              onTap: () {
                Logger().i('书影音搜索点击');
              },
            ),
          ),
        ),
        /// 可以有吸顶的效果， tabbar
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: _SliverAppBarDelegate(
            maxHeight: 49.0,
            minHeight: 49.0,
            child: Container(
              color: Colors.white,
              child: tabbar,
            )
          ),
        ),
      ];
    },

      /// 底下的FlutterTabBarView 包装下_tabController
    body: FlutterTabBarView(
         tabController: _tabController
  ));
}

// -------------------------------------------------------------------------------  _SliverAppBarDelegate

/// 自定义 重写build() 、 get maxExtent 、 get minExtent 和 shouldRebuild() 这四个方法
/// maxExtent 表示header完全展开时的高度， minExtent 表示header在收起时的最小高度
/// 因此，对于我们上面的那个自定义Delegate，如果将 minHeight 和 maxHeight 的值设置为相同时，header就不会收缩了
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {

  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  @override
  double get maxExtent => math.max(minHeight ?? kToolbarHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    // 如果不一样 就要重新build
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

}


// -------------------------------------------------------------------------------  MoviePageTabBar

class MoviePageTabBar extends StatefulWidget {

  @override
  _MoviePageTabBarState createState() => _MoviePageTabBarState();
}

class _MoviePageTabBarState extends State<MoviePageTabBar> {

  Color selectColor, unSelectColor;
  TextStyle selectTextStyle, unSelectTextStyle;

  @override
  void initState() {
    super.initState();
    selectColor = Colors.black;
    unSelectColor = Color.fromARGB(255, 117, 117, 117);
    selectTextStyle = TextStyle(fontSize: 18, color: selectColor);
    unSelectTextStyle = TextStyle(fontSize: 18, color: unSelectColor);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: TabBar(
        tabs: tablist,
        isScrollable: true,
        controller: _tabController,
        indicatorColor: selectColor,
        // indicatorPadding: EdgeInsets.only(bottom: 5),
        // labelPadding: EdgeInsets.only(bottom: 8),
        labelColor: selectColor,
        labelStyle: selectTextStyle,
        unselectedLabelColor: unSelectColor,
        unselectedLabelStyle: unSelectTextStyle,
        /// 指示器的长度, tab：和tab一样长，label：和标签label 一样长
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }
}
