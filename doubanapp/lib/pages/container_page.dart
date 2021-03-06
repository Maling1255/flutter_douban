import 'package:doubanapp/constant/constant.dart';
import 'package:doubanapp/group/group_page.dart';
import 'package:doubanapp/pages/home/home_page.dart';
import 'package:doubanapp/pages/movie/book_audio_video_page.dart';
import 'package:doubanapp/pages/person/person_center_page.dart';
import 'package:doubanapp/shop/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class _Item {
  String title, activeIcon, normalIcon;
  _Item(this.title, this.activeIcon, this.normalIcon);
}


/// 这个页面作为整个APP的最外层的容器，以Tab为基础控制为每个item的显示与隐藏
class ContainerPage extends StatefulWidget {
  @override
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {

  // 定义4个页面的数组
  List<Widget> pages;
  List<BottomNavigationBarItem> bottomNavigationBarItemList;
  int _bottomBarSelectIndex = 0;  // 默认选中第一个
  final defaultItemColor = Color.fromARGB(255, 125, 125, 125);
  final items =  [
    _Item('首页', 'assets/images/ic_tab_home_active.png', 'assets/images/ic_tab_home_normal.png'),
    _Item('书影音', 'assets/images/ic_tab_subject_active.png', 'assets/images/ic_tab_subject_normal.png'),
    _Item('小组', 'assets/images/ic_tab_group_active.png', 'assets/images/ic_tab_group_normal.png'),
    _Item('市集', 'assets/images/ic_tab_shiji_active.png', 'assets/images/ic_tab_shiji_normal.png'),
    _Item('我的', 'assets/images/ic_tab_profile_active.png', 'assets/images/ic_tab_profile_normal.png')
  ];

  final ShopPage _shopPage  = ShopPage();

  @override
  void initState() {
    super.initState();

     ShopPage();
    if (pages == null) {
        pages = [
          HomePage(),
          BookAudioVideoPage(),
          GroupPage(),
          _shopPage,
          PersonCenterPage()];
    }

    if (bottomNavigationBarItemList == null) {
      bottomNavigationBarItemList = items.map((item){
        return BottomNavigationBarItem(
          icon: Image.asset(item.normalIcon, width: 30.0, height: 30.0),
          label: item.title,
          activeIcon: Image.asset(item.activeIcon, width: 30.0, height: 30.0,),
        );
      }).toList();  /// 转成数组存放的是 BottomNavigationBarItem widget
    }
  }

  // 根据index获取对应的page
  /// Stack（层叠布局）+ Offstage组合,解决状态被重置的问题
  Widget _getPagesWidget(int index) {
    return Offstage(
      offstage: _bottomBarSelectIndex != index,  // false 显示， true 隐藏

      /// TickerMode 可用于禁用子树中的动画
      // 所以作用是控制子控件是否显示动画
      child: TickerMode(
        enabled: _bottomBarSelectIndex == index,
        child: pages[index],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ContainerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    Logger().i('ContainerPage: -> didUpdateWidget');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _getPagesWidget(0),
          _getPagesWidget(1),
          _getPagesWidget(2),
          _getPagesWidget(3),
          _getPagesWidget(4),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      /// 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItemList,
        onTap: (int index) {
          /// 这里根据点击的index来显示，非index的page都要隐藏
          setState(() {
            _bottomBarSelectIndex = index;

            /// 这里隐藏 webview
            _shopPage.setShowState(pages.indexOf(_shopPage) == _bottomBarSelectIndex);

          });
        },
        // 图片大小
        iconSize: 24.0,
        // 当前选中的index
        currentIndex: _bottomBarSelectIndex,
        /// 选中后，底部BottomNavigationBar内容的颜色(选中时，默认为主题色)
        /// （仅当type: BottomNavigationBarType.fixed,时生效）
        fixedColor: Color.fromARGB(255, 0, 188, 96),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
