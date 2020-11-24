import 'package:doubanapp/bean/subject_entity.dart';
import 'package:doubanapp/constant/color_constant.dart';
import 'package:doubanapp/constant/constant.dart';
import 'package:doubanapp/constant/text_size_constant.dart';
import 'package:flutter/material.dart';


typedef TapCallBack = void Function(int index);

class HotSoonTabbar extends StatefulWidget {
  final state = _HotSoonTabbarState();

  /// 初始化构造方法
  HotSoonTabbar({Key key, TapCallBack onTapCallBack}) : super(key: key) {
    state.setTapCallBack(onTapCallBack);
  }

  @override
  State<StatefulWidget> createState() {
    return state;
  }

  void setCount(List<Subject> hotShowBeans) {
    state.setCount(hotShowBeans.length);
  }

  void setComingSoon(List<Subject> comingSoonBeans) {
    state.setComingSoonCount(comingSoonBeans.length);
  }
}

/// 用于使用到了一点点的动画效果，因此加入了SingleTickerProviderStateMixin
class _HotSoonTabbarState extends State<HotSoonTabbar> with SingleTickerProviderStateMixin {

  int movieCount = 0;    // 当前电影数量（是 hotCount 或者 soonCount 赋值得到的）
  Color selectColor, unselectColor;
  TextStyle selectTextStyle, unselectTextStyle;
  Widget tabbar;
  TapCallBack onTapCallBack;
  TabController tabController;
  var hotCount, commingSoonCount;   // 热映数量  即将上映数量
  int selectIndex = 0;  // 默认选中0

  @override
  void initState() {
    super.initState();
    selectColor = ColorConstant.colorDefaultTitle;
    unselectColor = Color.fromARGB(255, 135, 135, 135);
    selectTextStyle = TextStyle(fontSize: TextSizeConstant.BookAudioPartTabBar, color: selectColor, fontWeight: FontWeight.bold);
    unselectTextStyle = TextStyle(fontSize: TextSizeConstant.BookAudioPartTabBar, color: unselectColor);

    ///初始化时创建控制器
    ///通过 with SingleTickerProviderStateMixin 实现动画效果。
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(listener);

    tabbar = TabBar(
      indicatorColor: selectColor,
      labelColor: selectColor,
      labelStyle: selectTextStyle,
      unselectedLabelColor: unselectColor,
      unselectedLabelStyle: unselectTextStyle,
      /// 底部只是线条和文字长度相同
      indicatorSize: TabBarIndicatorSize.label,
      controller: tabController,
      isScrollable: true,
      tabs: [
        Padding(
          padding: EdgeInsets.only(bottom: Constant.TAB_BOTTOM),
          child: Text('影院热映'),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: Constant.TAB_BOTTOM),
          child: Text('即将上映'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    tabController.removeListener(listener);
    tabController.dispose();
    super.dispose();
  }

  // 监听这里
  void listener() {
    // 判断index是否改变
    if (tabController.indexIsChanging) {
        var index = tabController.index;
        selectIndex = index;
        setState(() {
          if (index == 0) {
            movieCount = hotCount;
          } else {
            movieCount = commingSoonCount;
          }
          if (onTapCallBack != null) {
            onTapCallBack(index);
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(flex: 1, child: tabbar),
        Text('全部 ${movieCount ?? 666} >>', style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // 影院热映数量
  void setCount(int count) {
    setState(() {
      this.hotCount = count;
      if (selectIndex == 0) {
          setState(() {
            movieCount = hotCount;
          });
      }
    });
  }

  // 即将上映数量
  void setComingSoonCount(int length) {
    setState(() {
      this.commingSoonCount = length;
      if (selectIndex == 1) {
        setState(() {
          movieCount = commingSoonCount;
        });
      }
    });
  }


  void setTapCallBack(TapCallBack onTapCallBack) {
    this.onTapCallBack = onTapCallBack;
  }
}
