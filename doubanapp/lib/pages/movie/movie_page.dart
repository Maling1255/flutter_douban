
import 'package:doubanapp/bean/movie_top_item_bean.dart';
import 'package:doubanapp/bean/subject_entity.dart';
import 'package:doubanapp/pages/movie/movie_hotsoon_tabbar.dart';
import 'package:doubanapp/pages/movie/movie_title_wiget.dart';
import 'package:doubanapp/pages/movie/today_play_movie_widget.dart';
import 'package:doubanapp/repository/movie_repository.dary.dart';
import 'package:flutter/material.dart';

class MoviePage extends StatefulWidget {

  MoviePage({Key key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

///  AutomaticKeepAliveClientMixin 保存状态
///  在切换页面时，经常会刷新页面，为了避免initState方法重复调用使用AutomaticKeepAliveClientMixin； 1. with  2. 重写wantKeepAlive 3. super.build(context);
///
/// 三种方式实现页面切换后保持原页面状态  https://blog.csdn.net/jielundewode/article/details/94545743?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.control
/// ① ：使用IndexedStack实现；； IndexedStack继承自Stack，它的作用是显示第index个child，其它child在页面上是不可见的，但所有child的状态都被保持
/// ② ：使用Offstage实现， 通过一个参数来控制child是否显示，所以我们同样可以组合使用Offstage来实现该需求，其实现原理与IndexedStack类似：
/// ③ ：AutomaticKeepAliveClientMixin 官方推荐  保存页面状态， 在第一次加载的时候才会调用
/// ① 和 ② 一开始就要把所有的页面都加在出来， 性能上没有③好
class _MoviePageState extends State<MoviePage> with AutomaticKeepAliveClientMixin {

  // 标题
  Widget titleWidget, hotSoonTabBarPadding;
  // 热映&即将上映的bar
  HotSoonTabbar hotSoonTabbar;
  // 影院热映
  List<Subject> hotShowBeans = List();
  // 即将上映
  List<Subject> comingSoonBeans = List();
  // 豆瓣榜单
  List<Subject> hotBeans;
  // 一周口碑电影榜
  List<SubjectEntity> weeklyBeans;
  // Top25
  List<Subject> top250Beans;

  var hotChildAspectRatio;
  var comingSoonChildAspectRatio;
  int selectIndex = 0;  // 默认选中的热映， 即将上映
  var itemWidth;
  var imgSize;

  // 今日播放的url
  List<String> todayUrls = [];
  // 今日播放的背景颜色
  Color todayPlayBackgroundColor = Color.fromARGB(255, 47, 22, 74);

  // 周排行   周热门  周前250
  MovieTopItemBean weeklyTopBean, weeklyHotBean, weeklyTop250Bean;
  Color weeklyTopColor, weeklyHotColor, weeklyTop250Color, todayPlayBgColor;


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    titleWidget = Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TitleWidget(),
    );

    // TODO: 这里开始🔥这里开始🔥这里开始🔥这里开始🔥这里开始🔥
    hotSoonTabbar = HotSoonTabbar(

    );

    hotSoonTabBarPadding = Padding(
      padding: EdgeInsets.only(top: 35.0, bottom: 15.0),
      child: hotSoonTabbar,
    );

    requestAPI();
  }

  MovieRepository repository = MovieRepository();
  bool loading = true;

  void requestAPI() async {
    Future(() => repository.requestAPI()).then((value) {
      hotShowBeans = value.hotShowBeans;
      comingSoonBeans = value.comingSoonBeans;
      hotBeans = value.hotBeans;
      weeklyBeans = value.weeklyBeans;
      top250Beans = value.top250Beans;
      todayUrls = value.todayUrls;
      weeklyTopBean = value.weeklyTopBean;
      weeklyHotBean = value.weeklyHotBean;
      weeklyTop250Bean = value.weeklyTop250Bean;
      weeklyTopColor = value.weeklyTopColor;
      weeklyHotColor = value.weeklyHotColor;
      weeklyTop250Color = value.weeklyTop250Color;
      todayPlayBgColor = value.todayPlayBgColor;

      hotSoonTabbar.setCount(hotShowBeans);
      hotSoonTabbar.setComingSoon(comingSoonBeans);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
