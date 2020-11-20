
import 'package:doubanapp/bean/subject_entity.dart';
import 'package:doubanapp/pages/movie/movie_hotsoon_tabbar.dart';
import 'package:doubanapp/pages/movie/movie_title_wiget.dart';
import 'package:doubanapp/pages/movie/today_play_movie_widget.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {

  MoviePage({Key key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {

  Widget titleWidget, hotSoonTabBarPadding;
  HotSoonTabbar hotSoonTabbar;
  // 影院热映
  List<Subject> hotShowBeans = List();
  // 即将上映
  List<Subject> comingSoonBeans = List();
  // 豆瓣榜单
  List<Subject> hotBeans;
  // 一周口碑电影榜
  List<Subject> weeklyBeans;
  // Top25
  List<Subject> top250Beans;

  var hotChildAspectRatio;
  var comingSoonChildAspectRatio;
  int selectIndex = 0;  // 默认选中的热映， 即将上映
  var itemWidth;
  var imgSize;
  List<String> todayUrls = [];
  Color todayPlayBackgroundColor = Color.fromARGB(255, 47, 22, 74);

  @override
  void initState() {
    super.initState();
    titleWidget = Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TitleWidget(),
    );

    // TODO: 这里开始🔥这里开始🔥这里开始🔥这里开始🔥这里开始🔥
    hotSoonTabbar = HotSoonTabbar();

    hotSoonTabBarPadding = Padding(
      padding: EdgeInsets.only(top: 35.0, bottom: 15.0),
      child: hotSoonTabbar,
    );
  }



  @override
  Widget build(BuildContext context) {
    if (itemWidth == null || imgSize == null) {
        var screenWidth = MediaQuery.of(context).size.width;
        imgSize = screenWidth / 5 * 3; // 占屏幕的3/5宽度
        itemWidth = (screenWidth - 30.0 - 20.0) / 3;
        hotChildAspectRatio = (377.0 / 674.0);
        comingSoonChildAspectRatio = (377.0 / 742.0);
    }
    return Stack(
      children: <Widget>[
        _containerBody(),
      ],
    );
  }


  Widget _containerBody() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: CustomScrollView(
        /// physics:
        /// BouncingScrollPhysics 内容超过一屏 上拉有回弹效果
        /// ClampingScrollPhysics 包裹内容 不会有回弹
        /// AlwaysScrollableScrollPhysics 总是可以滑动
        /// NeverScrollableScrollPhysics 禁止滚动
        /// FixedExtentScrollPhysics 滚动条直接落在某一项上，而不是任何位置，类似于老虎机，只能在确定的内容上停止，而不能停在2个内容的中间，用于可滚动组件的FixedExtentScrollController
        /// PageScrollPhysics  用于PageView的滚动特性，停留在页面的边界(分页滚动的), 一页一页的列表滑动，一般用于PageView控件用的滑动效果，滑动到末尾会有比较大的弹起
        physics: BouncingScrollPhysics(),
        /// 是否根据子widget的总长度来设置ListView的长度
        shrinkWrap: true,
        slivers: <Widget>[
          // 包装sliver
          SliverToBoxAdapter(child: titleWidget),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 22.0),
              child: TodayPlayMovieWidget(todayUrls, backgroundColor: todayPlayBackgroundColor),
            ),),
          SliverToBoxAdapter(
            child: hotSoonTabBarPadding,
          ),
        ],
      ),
    );
  }

}
