
import 'package:doubanapp/bean/movie_top_item_bean.dart';
import 'package:doubanapp/bean/subject_entity.dart';
import 'package:doubanapp/constant/color_constant.dart';
import 'package:doubanapp/constant/constant.dart';
import 'package:doubanapp/pages/movie/movie_hotsoon_tabbar.dart';
import 'package:doubanapp/pages/movie/movie_rating_bar.dart';
import 'package:doubanapp/pages/movie/movie_title_wiget.dart';
import 'package:doubanapp/pages/movie/subject_mark_image_widget.dart';
import 'package:doubanapp/pages/movie/today_play_movie_widget.dart';
import 'package:doubanapp/pages/movie/top_item_widget.dart';
import 'package:doubanapp/repository/movie_repository.dary.dart';
import 'package:doubanapp/widgets/image/cache_img_radius.dart';
import 'package:doubanapp/widgets/part/item_count_title.dart';
import 'package:doubanapp/widgets/part/loading_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:logger/logger.dart';

typedef OnTap = void Function();

class MoviePage extends StatefulWidget {

  MoviePage({Key key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

///  AutomaticKeepAliveClientMixin 保存状态
///  在切换页面时，经常会刷新页面，为了避免initState方法重复调用使用AutomaticKeepAliveClientMixin； 1. with  2. 重写wantKeepAlive 3. super.build(context);
///
/// 四种方式实现页面切换后保持原页面状态  https://blog.csdn.net/jielundewode/article/details/94545743?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.control&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.control
/// ① ：使用IndexedStack实现；； IndexedStack继承自Stack，它的作用是显示第index个child，其它child在页面上是不可见的，但所有child的状态都被保持
/// ② ：使用Offstage实现， 通过一个参数来控制child是否显示，所以我们同样可以组合使用Offstage来实现该需求，其实现原理与IndexedStack类似：
/// ③ ：AutomaticKeepAliveClientMixin 官方推荐  保存页面状态， 在第一次加载的时候才会调用
/// ④ ：使用存储状态的key  PageStorageKey  https://blog.csdn.net/vitaviva/article/details/105313672   ;;
/// ① 和 ② 一开始就要把所有的页面都加在出来， 性能上没有③好
/// ③ 和 ④ 的比较：：：： https://blog.csdn.net/zhumj_zhumj/article/details/102700305?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1.control
class _MoviePageState extends State<MoviePage> with AutomaticKeepAliveClientMixin {

  // 标题
  Widget titleWidget, hotSoonTabBarPadding;
  // 热映&即将上映的bar
  HotSoonTabbar hotSoonTabbar;
  // 影院热映
  List<Subject> hotShowBeans = List();
  // 即将上映
  List<Subject> comingSoonBeans = List();
  // 豆瓣热映
  List<Subject> hotBeans;
  // 一周口碑电影榜
  List<SubjectEntity> weeklyBeans;
  // Top25
  List<Subject> top250Beans;

  var hotChildAspectRatio;
  var comingSoonChildAspectRatio;
  int selectIndex = 0;  // 默认选中的热映， 即将上映
  var itemWidth;  // item宽度
  var imgSize;

  // 今日播放的url
  List<String> todayUrls = [];
  // 今日播放的背景颜色
  Color todayPlayBackgroundColor = Color.fromARGB(255, 47, 22, 74);

  // 一周排行   一周热门  一周前250
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

    // 热榜 & 即将上映 tabbar
    hotSoonTabbar = HotSoonTabbar(
      onTapCallBack: (index) {
        setState(() {
          selectIndex = index;
        });
      },
    );

    hotSoonTabBarPadding = Padding(
      padding: EdgeInsets.only(top: 35.0, bottom: 15.0),
      child: hotSoonTabbar,
    );

    requestAPI();
  }

  MovieRepository repository = MovieRepository();
  bool isLoading = true;  // 正在加载

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
        isLoading = false;   // 加载完成
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
      // 比例
      hotChildAspectRatio = (377.0 / 674.0);
      comingSoonChildAspectRatio = (377.0 / 742.0);
    }
    return Stack(
      children: <Widget>[
        _containerBody(),
        Offstage(  /// 记载lodding  Offstage 控制显示 & 隐藏
          child: LoadingWidget.getLoading(backgroundColor: Colors.transparent, loadingBackgroundColor: Colors.white),
          offstage: !isLoading,
        ),
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
        /// shrinkWrap: true 则是只满足自身大小
        /// shrinkWrap: false  填充满父组件给的空间大小
        shrinkWrap: true,
        slivers: <Widget>[
          // 包装sliver, 找电影， 豆瓣榜单， 豆瓣菜， 豆瓣片单
          SliverToBoxAdapter(child: titleWidget),
          // 今日播放
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 22.0),
              child: TodayPlayMovieWidget(todayUrls, backgroundColor: todayPlayBackgroundColor),
            ),),
          // 热映 即将上映 tabbar
          SliverToBoxAdapter(
            child: hotSoonTabBarPadding,
          ),

          /// grid 网格的item
          SliverGrid(
            /// 这里是网格UI部分
            delegate: SliverChildBuilderDelegate((BuildContext context, int index){
              var hotMovieBean;
              var comingSoonBean;
              if (hotShowBeans.length > 0) {
                hotMovieBean = hotShowBeans[index];
              }
              if (comingSoonBeans.length > 0) {
                comingSoonBean = comingSoonBeans[index];
              }
              return Stack(
                children: <Widget>[
                  // 热映
                  Offstage(
                    offstage: selectIndex == 1 && comingSoonBeans != null,
                    child: _getHotShowItem(hotMovieBean, itemWidth),
                  ),
                  // 即将上映
                  Offstage(
                    offstage: selectIndex == 0 && hotShowBeans != null,
                    child: _getCommingSoonItem(comingSoonBean, itemWidth),
                  ),
                ],
              );

            }, childCount: math.min(selectIndex == 0 ? hotShowBeans.length : comingSoonBeans.length, 6)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              /// 配置交叉轴方向数据配置
              // 3列
              crossAxisCount: 3,
              // 纵向间距
              crossAxisSpacing: 10.0,
              // 横向间距
              mainAxisSpacing: 5.0,
              // 宽高比例，主轴方向 ：交叉轴方向
              childAspectRatio: selectIndex == 0 ? hotChildAspectRatio : comingSoonChildAspectRatio,  // 宽高比例
            ),
          ),

          // 圆角横屏的图片 banner
          getSliverCommonImg(Constant.IMG_TMP1, () {
            Logger().i('横屏banner图片点击');
          }),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15.0),
              child: ItemCountTitle('豆瓣热门', count: hotBeans == null ? 0 : hotBeans.length, fontSize: 13, onTap: () {
                Logger().i('豆瓣热门点击全部');
              },),
            ),
          ),
          /// 热映grid
          getCommonSliverGrid(hotBeans),

          /// 2018 banner
          getSliverCommonImg(Constant.IMG_TMP2, () {
            Logger().i('2018横屏banner图片点击');
          }),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15.0),
              child: ItemCountTitle('豆瓣榜单', count: hotBeans == null ? 0 : hotBeans.length, onTap: () {
                Logger().i('豆瓣榜单点击全部');
              },),
            ),
          ),

          // 底部的横向滚动
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                height: imgSize,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    TopItemWidget(
                      title: '一周口碑电影榜',
                      bean: weeklyTopBean,
                      partColor: weeklyTopColor,
                    ),
                    TopItemWidget(
                      title: '一周热门排行榜',
                      bean: weeklyHotBean,
                      partColor: weeklyHotColor,
                    ),
                    TopItemWidget(
                      title: '豆瓣电影 Top250',
                      bean: weeklyTop250Bean,
                      partColor: weeklyTop250Color,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 影院热映
  Widget _getHotShowItem(Subject hotBean, var width) {
    if (hotBean == null) {
        return Text('hotBean_空的', style: TextStyle(fontSize: 14, color: Colors.red));
    }
    return GestureDetector(
      child: Column(
        children: <Widget>[
          SubjectMarkImageWidget(hotBean.images.large, width:width),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Container(
              width: double.infinity,
              child: Text(
                hotBean.title,
                /// 文本只显示一行
                softWrap: false,
                /// 多行文本渐隐方式
                overflow: TextOverflow.fade,
                style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          /// 评分 星星✨
          MovieRatingBar(hotBean.rating.average, size: 12.0,),
        ],
      ),
      onTap: (){
        Logger().i('点击跳转。。。');
      },
    );
  }

  // 即将上映
  Widget _getCommingSoonItem(Subject soonBean, var width) {
    if (soonBean == null) {
      return Text('soonBean_空的', style: TextStyle(fontSize: 14, color: Colors.red));
    }

    /// 时间转换  将2019-02-14转成02月04日
    String mainland_pubdate = soonBean.mainland_pubdate;
    // 02-14
    mainland_pubdate = mainland_pubdate.substring(5, mainland_pubdate.length);  // 截取字符串到末尾的位置index
    // 02月04日
    mainland_pubdate = mainland_pubdate.replaceFirst(RegExp(r'-'), '月') + '日';

    return   GestureDetector(
      child: Column(
        /// 交叉轴从左侧开始布局
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SubjectMarkImageWidget(soonBean.images.large, width:width),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Container(
              width: double.infinity,
              child: Text(
                soonBean.title,
                /// 文本只显示一行
                softWrap: false,
                /// 多行文本渐隐方式
                overflow: TextOverflow.fade,
                style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // 底部的时间
          Container(
            margin: EdgeInsets.only(top: 7),
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(mainland_pubdate, style: TextStyle(fontSize: 8.0, color: ColorConstant.colorRed277)),
            ),
            /// 设置边框的形状装饰
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                side: BorderSide(color: ColorConstant.colorRed277),
              ),
            ),
          ),
        ],
      ),
      onTap: (){
        Logger().i('点击跳转。。。');
      },
    );
  }

  /// 圆角图片
  getSliverCommonImg(String url, OnTap onTap) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: CacheImgRadius(
          imgUrl: url,
          radius: 5.0,
          ontap: () {
            if (onTap != null) {
              onTap();
            }
          },
        ),
      ),
    );
  }

  ///图片+订阅+名称+星标
  SliverGrid getCommonSliverGrid(List<Subject> hotBeans) {
    return SliverGrid(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          if (hotBeans == null) {
              return Container();
          }
          return _getHotShowItem(hotBeans[index], itemWidth);
        }, childCount: () {
          if (hotBeans?.length != null) {
              return hotBeans.length;
          }
          return 6;
        }()),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 0.0,
            childAspectRatio: hotChildAspectRatio)
    );
  }

}


