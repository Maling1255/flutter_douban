
import 'package:doubanapp/bean/subject_entity.dart';
import 'package:doubanapp/constant/constant.dart';
import 'package:doubanapp/request/API.dart';
import 'package:doubanapp/request/http_request.dart';
import 'package:doubanapp/request/simulate_request.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
    initialIndex: 1,
    length: _tabsSegmentTitles.length,

    /// 嵌套的scrollview
    child: NestedScrollView(

      /// 头部的跟着滚走的builder, 返回数组
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[];
      },
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
          child: Text('暂无数据', style: TextStyle(fontSize: 18, color: Colors.black54)),
        );
    }


    print('.................  ${list.length}');

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
            key: PageStorageKey<String>(widget.title),
            slivers: <Widget>[
              SliverOverlapInjector(
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
                delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => getCommonItem(list, index),
                    childCount: list.length)),
            ],
          );
        },
      ),
    );
  }


  double singleLineImgHeight = 180.0;
  double contentVideoHeight = 350.0;
  /// 列表的普通单个item
  getCommonItem(List<Subject> items, int index) {

    Subject item = items[index];
    bool isShowVideo = index == 1 || index == 3;

    return Container(
      height: isShowVideo ? contentVideoHeight : singleLineImgHeight,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.only(left: Constant.MARGIN_LEFT, right: Constant.MARGIN_RIGHT, top: Constant.MARGIN_RIGHT, bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(radius: 25.0, backgroundColor: Colors.white, backgroundImage: NetworkImage(item.casts[0].avatars.medium)),
              Padding(padding: const EdgeInsets.only(left: 10.0), child: Text(item.title)),
              Expanded(
                child: Text('测试文字'),
              ),
            ],
          ),
        ],
      ),
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
