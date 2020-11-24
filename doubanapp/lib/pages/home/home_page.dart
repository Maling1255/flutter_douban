
import 'package:doubanapp/bean/subject_entity.dart';
import 'package:doubanapp/constant/constant.dart';
import 'package:doubanapp/request/API.dart';
import 'package:doubanapp/request/http_request.dart';
import 'package:doubanapp/request/simulate_request.dart';
import 'package:doubanapp/widgets/image/radius_img.dart';
import 'package:doubanapp/widgets/part/search_text_field_widget.dart';
import 'package:doubanapp/widgets/part/video_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:doubanapp/pages/home/home_app_bar.dart' as myApp;

import 'package:logger/logger.dart';

/// 首页 TAB页面 显示动态和推荐TAB
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return getHomePageWidget();
  }
}


var _tabsSegmentTitles = ['动态', '推荐'];
DefaultTabController getHomePageWidget() {
  return DefaultTabController(
    initialIndex: 1,  // 默认选中推荐
    length: _tabsSegmentTitles.length,
    /// 可以在其内部嵌套其他滚动视图的滚动视图，其滚动位置是固有链接的
    /// 就是 SliverAppBar/TabBarView 可以上滑滑动走， 下拉固定到在顶部效果
    child: NestedScrollView(

      /// 头部的跟着滚走的builder, 返回数组
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            /// 这里使用的重写自定义的SliverAppBar
            sliver: myApp.SliverAppBar(

              /// pinned设置为true时，当SliverAppBar内容滑出屏幕时，将始终渲染一个固定在顶部的收起状态
              pinned: true,
              expandedHeight: 140,
              primary: true,
              titleSpacing: 0.0,
              backgroundColor: Colors.white,
              /// AppBar的一部分，它可以扩展，折叠，延伸，最常用于SliverAppBar.flexibleSpace字段。即：展开和收紧区域
              flexibleSpace: FlexibleSpaceBar(
                /// FlexibleSpaceBar中有一个非常重要的属性就是stretchModes，此参数控制拉伸区域的滚动特性：
                /// StretchMode.zoomBackground- >背景小部件将展开以填充额外的空间。
                /// StretchMode.blurBackground- >使用[ImageFilter.blur]效果，背景将模糊。
                /// StretchMode.fadeTitle- >随着用户过度滚动，标题将消失。
                stretchModes: [StretchMode.blurBackground],
                collapseMode: CollapseMode.pin,
                background: Container(
                  color: Colors.green,
                  alignment: Alignment(0, -0.15),
                  // 自定义搜索框
                  child: SearchTextFieldWidget(
                    hintText: '影视作品中你难忘的离别',
                    margin: EdgeInsets.only(left: 15, right: 15),
                    onTap: () {
                      debugPrint('点击搜索🔍');
                    },
                  ),
                ),
              ),
              bottomTextString: _tabsSegmentTitles,
              /// TabBar 类似segment
              /// TabBar 是一排水平的标签，可以来回切换
              /// 这里自定义了 重写了，，在HomeTabBar中重写了
              bottom: TabBar(

                /// 指示器的长度, tab：和tab一样长，label：和标签label 一样长
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                indicatorPadding: EdgeInsets.only(bottom: 5),
                labelPadding: EdgeInsets.only(bottom: 8),
                tabs: _tabsSegmentTitles.map((String title) => Container(
                  child: Text(title, style: TextStyle(fontSize: 17)),
                  padding: EdgeInsets.only(bottom: 5.0),
                )).toList(),
              ),
            ),
          ),

          // SliverFixedExtentList(
          //   itemExtent: 120.0,
          //   delegate: SliverChildListDelegate(
          //      <Widget>[
          //        Text('1111111111111'),
          //        Text('2222222222222'),
          //        Text('3333333333333'),
          //      ],
          //     ),
          //   ),
        ];
      },

      /// 下面的列表
      body: TabBarView(
        children: _tabsSegmentTitles.map((String title) {
          // 包装成SliverContainer
          return SliverContainer(title: title);
        }).toList(),
      ),
    ),
  );
}



class SliverContainer extends StatefulWidget {
  final String title;
  SliverContainer({Key key, @required this.title}) : super(key: key);

  @override
  _SliverContainerState createState() => _SliverContainerState();
}

class _SliverContainerState extends State<SliverContainer> {

  List<Subject> list;

  @override
  void initState() {
    super.initState();
    if (list == null || list.isEmpty) {
        if (_tabsSegmentTitles[0] == widget.title) {
          // 请求动态数据
            requestAPI();
        } else {
          // 请求推荐数据
          requestAPI();
        }
    }
  }

  /// 网络数据请求
  void requestAPI () async {
    // var _request = HttpRequest(API.BASE_URL);
    // int start = math.Random().nextInt(220);
    // final Map result = await _request.get(API.TOP_250 + '?start=$start&count=30');
    // var resultList = result['subjects'];

    var _request = SimulateRequest();
    var result = await _request.get(API.TOP_250);
    var resultList = result['subjects'];

    list = resultList.map<Subject>((item) => Subject.fromMap(item)).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getContentSliver(context, list),
    );
  }

  getContentSliver(BuildContext context, List<Subject> list) {

    // 如果是第一个segment
    if (widget.title == _tabsSegmentTitles[0]) {
        return _loginContainer(context);
    }
    if (list == null || list.length ==0) {
        return Center(
          child: Text('正在加载...', style: TextStyle(fontSize: 18, color: Colors.black54)),
        );
    }

    /// 安全区域
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          /// CustomScrollView是使用Sliver组件创建自定义滚动效果的滚动组件
          /// CustomScrollView就像一个粘合剂，将多个组件粘合在一起，具统一的滚动效果
          /// Sliver系列组件有很多，比如SliverList、SliverGrid、SliverFixedExtentList、SliverPadding、SliverAppBar等
          return CustomScrollView(
            /// 内容超过一屏 上拉有回弹效果，
            physics: const BouncingScrollPhysics(),
            /// “controller”和“primary主要”成员应该保持未设置，以便NestedScrollView可以控制这个内部滚动视图。
            /// 如果“controller”属性被设置，那么这个滚动视图将不会与NestedScrollView关联。
            /// PageStorageKey应该是这个ScrollView唯一的;
            /// 当选项卡视图不在屏幕上时，它允许列表记住它的滚动位置。
            ///
            /// https://cloud.tencent.com/developer/article/1461395
            ///
            /// 记录每个 tabbarpageView 滚动的偏移量, 【🔥保存页面的状态】
            ///
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
            key: PageStorageKey<String>(widget.title),
            slivers: <Widget>[
              /// TODO: 这里为什么不能写
              SliverOverlapInjector(
                 /// 这是上面的SliverOverlapAbsorber的另一面。
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                /// SliverList，它只有一个delegate属性，可以用SliverChildListDelegate 或 SliverChildBuilderDelegate这两个类实现。
                /// 前者将会一次性全部渲染子组件，后者将会根据视窗渲染当前出现的元素，其效果可以和ListView和ListView.build这两个构造函数类比。
                ///     SliverList(
                ///       delegate: SliverChildListDelegate(
                ///         <Widget>[
                ///           renderA(),
                ///           renderB(),
                ///           renderC(),
                ///         ]
                ///       )
                ///     )
                ///
                ///     SliverList(
                ///       delegate: SliverChildBuilderDelegate(
                ///         (context, index) => renderItem(context, index),
                ///         childCount: 10,
                ///       )
                ///     )
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return _getCommonItem(list, index);
              }, childCount: list.length)),
            ],
          );
        },
      ),
    );
  }


  double singleLineImgHeight = 200.0;
  double contentVideoHeight = 350.0;
  /// 列表的普通单个item
  _getCommonItem(List<Subject> items, int index) {

    Subject item = items[index];
    bool isShowVideo = index == 1 || index == 3;

    return Container(
      height: isShowVideo ? contentVideoHeight : singleLineImgHeight,
      color: Colors.white,
      // 行间距
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.only(left: Constant.MARGIN_LEFT, right: Constant.MARGIN_RIGHT, top: Constant.MARGIN_RIGHT, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // 圆角
              CircleAvatar(radius: 25.0, backgroundColor: Colors.white, backgroundImage: NetworkImage(item.casts[0].avatars.medium)),
              Padding(padding: const EdgeInsets.only(left: 10.0), child: Text(item.title)),
              Expanded(
                child: GestureDetector(
                  child: Align(
                    child: Icon( Icons.more_horiz, color: Colors.grey, size: 18.0),
                    alignment: Alignment.topRight,
                  ),
                  onTap: () {
                    Logger().i('点击了首页列表的...');
                  },
                ),
              ),
            ],
          ),
          // 中间位置
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Container(child: isShowVideo ? _getContentVideo(index) : _getContentItemCenterImage(item)),
            ),
          ),
          // 底部功能键

        Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Logger().i('点击了首页列表的👍 $index');
                    },
                    child: Image.asset(Constant.ASSETS_IMG + 'ic_vote.png', width: 25.0, height: 25.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Logger().i('点击了首页列表的评论🏃 $index');
                    },
                    child: Image.asset(Constant.ASSETS_IMG + 'ic_notification_tv_calendar_comments.png', width: 20.0, height: 20.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Logger().i('点击了首页列表的转发👌 $index');
                    },
                    child: Image.asset(Constant.ASSETS_IMG + 'ic_status_detail_reshare_icon.png', width: 25.0, height: 25.0),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  _getContentVideo(int index) {
    /// mounted 是 bool 类型，表示当前 State 是否加载到树⾥。
    /// 常用于判断页面是否释放。
    if (!mounted) {
      return Container();
    }
    return Container(
      child: VideoWidget(
        index == 1 ? Constant.URL_MP4_DEMO_0 : Constant.URL_MP4_DEMO_1,
        isShowProgressBar: false,
      ),
    );
  }

  _getContentItemCenterImage(Subject item) {
    return Row(
      /// 环绕模式
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: RadiusImg.get(item.images.large, null, shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
          )),
        ),
        Expanded(
          child: RadiusImg.get(item.casts[1].avatars.medium, null, radius: 0.0),
        ),
        Expanded(
          child: RadiusImg.get(item.casts[2].avatars.medium, null, shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
          )),
        ),
      ],
    );
  }
}


/// 动态TAB
_loginContainer(BuildContext context) {
  return Align(
    alignment: Alignment(0.0, 0.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(Constant.ASSETS_IMG + 'ic_new_empty_view_default.png', width: 120.0),
        Padding(
          padding: const EdgeInsets.only(top: 150.0, bottom: 25.0),
          child: Text('登录后查看关注人的动态', style: TextStyle(fontSize: 16.0, color: Colors.grey)),
        ),
        GestureDetector(
          child: Container(
            child: Text('去登录', style: TextStyle(fontSize: 16.0, color: Colors.green)),
            padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            ),
          ),
          onTap: () {
            // 点击登录
            print('去登录点击00');
          },
        ),
      ],
    ),
  );
}
