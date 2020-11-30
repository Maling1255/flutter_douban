import 'package:doubanapp/constant/cache_key.dart';
import 'package:doubanapp/constant/constant.dart';
import 'package:doubanapp/main.dart';
import 'package:doubanapp/widgets/image/heart_img_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 个人中心

class PersonCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),

            /// 是否根据子widget的总长度来设置ListView的长度,
            /// shrinkWrap: true 则是只满足自身大小
            /// shrinkWrap: false  填充满 parent 组件给的空间大小
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                flexibleSpace: HeartImgWidget(Image.asset(Constant.ASSETS_IMG + 'bg_person_center_default.webp')),
                expandedHeight: 200,
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    // 分割线
                    Divider(color: Colors.black12, height: 1, indent: 60),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 15, bottom: 20, right: 10),

                          /// Image 图片数据
                          child: Image.asset(Constant.ASSETS_IMG + 'ic_notify.png', width: 30, height: 30),
                        ),
                        Expanded(child: Text('提醒', style: TextStyle(fontSize: 17))),

                        /// Icon 图
                        Icon(Icons.chevron_right, color: Color.fromARGB(255, 204, 204, 204)),
                      ],
                    ),
                    // 水平分割线
                    Divider(color: Colors.black12, height: 1, indent: 60),
                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Text('暂无新提醒', style: TextStyle(color: Colors.grey)),
                ),
              ),

              /// 自定义分割线
              _dividerLine(),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, bottom: 20),
                  child: Text('我的书影音', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  child: _VideoBookMusicBookWidget(),
                ),
              ),

              /// 自定义分割线
              _dividerLine(),

              _dataSelect(),
              _personItem('ic_me_journal.png', '我的发布'),
              _personItem('ic_me_follows.png', '我的关注'),
              _personItem('ic_me_photo_album.png', '相册'),
              _personItem('ic_me_doulist.png', '豆列 / 收藏'),

              _dividerLine(),
              _personItem('ic_me_wallet.png', '钱包'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dividerLine() {
    return SliverToBoxAdapter(
      child: Container(
        height: 10,
        color: Color.fromARGB(255, 247, 247, 247),
      ),
    );
  }

  SliverToBoxAdapter _personItem(String imgAsset, String title, {VoidCallback onTap}) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(Constant.ASSETS_IMG + imgAsset, width: 25, height: 25),
                ),
                Expanded(
                  child: Text(title, style: TextStyle(fontSize: 15)),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.chevron_right, color: Color.fromARGB(255, 204, 204, 204)),
                ),
              ],
            ),
            Divider(color: Colors.black12, height: 1, indent: 50),
          ],
        ),
        onTap: () {
          /// toast弹框
          Fluttertoast.showToast(
            msg: title,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Color(0xFF333333),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
      ),
    );
  }

  /// 网络数据 & 本地数据切换
  _dataSelect() {
    return UseNetDataWidget();
  }
}

class UseNetDataWidget extends StatefulWidget {
  @override
  _UseNetDataWidgetState createState() => _UseNetDataWidgetState();
}

class _UseNetDataWidgetState extends State<UseNetDataWidget> {
  // 记录
  bool isSelectNetData = false;

  @override
  void initState() {
    super.initState();

    _getData();
  }

  /// 异步获取
  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSelectNetData = prefs.getBool(CacheKey.USE_NET_DATA) ?? true;
    });
  }

  _setData(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(CacheKey.USE_NET_DATA, value);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Container(
              height: 60,
              child: Align(
                alignment: Alignment.center,
                child: Text('书影音数据是否来自网络', style: TextStyle(fontSize: 17, color: Colors.redAccent)),
              ),
            ),
            Expanded(child: Container()),

            /// 开关按钮， Cupertino是iOS风格样式的一系列组件
            CupertinoSwitch(
              value: isSelectNetData,
              onChanged: (bool value) {
                isSelectNetData = value;
                _setData(value);

                var tempText;
                if (value) {
                  tempText = '书影音数据 使用网络数据，重启APP后生效';
                } else {
                  tempText = '书影音数据 使用本地数据，重启APP后生效';
                }

                // 显示对话框
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('提示'),
                        content: Text(tempText),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('稍候我自己重启'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),

                          /// iOS风格的按钮
                          CupertinoButton(
                            color: Colors.blue,
                            child: Text('立即重启'),
                            onPressed: () {
                              RestartWidget.restartApp(context);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}

TabController _tabController;
final List<String> tabs = ['影视', '图书', '音乐'];

/// 影视， 图书， 音乐， TAB
class _VideoBookMusicBookWidget extends StatefulWidget {
  @override
  __VideoBookMusicBookWidgetState createState() => __VideoBookMusicBookWidgetState();
}

class __VideoBookMusicBookWidgetState extends State<_VideoBookMusicBookWidget> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 150,
      child: DefaultTabController(
        length: tabs.length,
        child: Column(
          children: <Widget>[
            Align(alignment: Alignment.centerLeft, child: _Tabbar()),
            _tabbarView(),
          ],
        ),
      ),
    );
  }

  Widget _tabbarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _tabbarItem('bg_videos_stack_default.png'),
          _tabbarItem('bg_books_stack_default.png'),
          _tabbarItem('bg_music_stack_default.png'),
        ],
      ),
    );
  }

  Widget _tabbarItem(String img) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        getTabViewItem(img, '想看'),
        getTabViewItem(img, '在看'),
        getTabViewItem(img, '看过'),
      ],
    );
  }

  Widget getTabViewItem(String img, String txt) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 7.0),
            child: Image.asset(Constant.ASSETS_IMG + img, fit: BoxFit.contain),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(txt),
        ),
      ],
    );
  }
}

class _Tabbar extends StatefulWidget {
  @override
  __TabbarState createState() => __TabbarState();
}

class __TabbarState extends State<_Tabbar> {
  Color selectColor, unselectedColor;
  TextStyle selectStyle, unselectedStyle;
  List<Widget> tabWidgets;

  @override
  void initState() {
    super.initState();
    selectColor = Colors.black;
    unselectedColor = Color.fromARGB(255, 117, 117, 117);
    selectStyle = TextStyle(fontSize: 18, color: selectColor);
    unselectedStyle = TextStyle(fontSize: 18, color: selectColor);
    tabWidgets = tabs.map((title) => Text(title, style: TextStyle(fontSize: 15))).toList();
  }

  @override
  void dispose() {
    super.dispose();
    if (_tabController != null) {
      _tabController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabWidgets,
      isScrollable: true,
      indicatorColor: selectColor,
      labelColor: selectColor,
      labelStyle: selectStyle,
      unselectedLabelColor: unselectedColor,
      unselectedLabelStyle: unselectedStyle,
      indicatorSize: TabBarIndicatorSize.label,
      controller: _tabController,
    );
  }
}
