
import 'package:doubanapp/constant/color_constant.dart';
import 'package:doubanapp/util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:logger/logger.dart';
import 'dart:ui';

///提供链接到一个唯一webview的单例实例，以便您可以从应用程序的任何位置控制webview
final _webviewReference = FlutterWebviewPlugin();

String url1 = 'https://flutterchina.club/';
String url2 = 'https://www.baidu.com';
bool _closed = false;
bool _isShow = true;

/// 市集 市集使用两个webView代替，因为豆瓣中 这个就是WebView
class ShopPage extends StatelessWidget {

  /// 外面选中 如果不是webview 页面 就要隐藏webview
  void setShowState(bool isShow) {
    _isShow = isShow;
    if(!isShow){
      _closed = true;
      _webviewReference.hide();
      _webviewReference.close();
    }
  }


  @override
  Widget build(BuildContext context) {
    return WebviewPageWidget();
  }
}


class WebviewPageWidget extends StatefulWidget {
  @override
  _WebviewPageWidgetState createState() => _WebviewPageWidgetState();
}

class _WebviewPageWidgetState extends State<WebviewPageWidget> with SingleTickerProviderStateMixin {

  final list = ['豆芽豆品', '豆芽时间'];
  int selectIndex = 0;
  Color selectColor, unSelectColor;
  TextStyle selectStyle, unSelectStyle;
  TabController tabController;

  @override
  void initState() {
    super.initState();

    // 先关闭web监听
    _webviewReference.close();

    tabController = new TabController(length: list.length, vsync: this);
    selectColor = Colors.green;
    unSelectColor = Color.fromARGB(255, 117, 117, 117);
    selectStyle = TextStyle(fontSize: 18);
    unSelectStyle = TextStyle(fontSize: 18);

    // 打开监听
    _webviewReference.onUrlChanged.listen((String url) {
      if (url != url1 || url != url2) {
          Logger().i('新的url: $url');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    // 释放监听
    _webviewReference.close();
    _webviewReference.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShow) {
      return Container();
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // 顶部的tabbar
            Row(
              children: <Widget>[
                Expanded(flex: 1, child: Container()),
                Expanded(flex: 3, child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: TabBar(
                    tabs: list.map((title) => Text(title)).toList(),
                    isScrollable: false,
                    controller: tabController,
                    indicatorColor: selectColor,
                    labelColor: selectColor,
                    labelStyle: selectStyle,
                    unselectedLabelColor: unSelectColor,
                    unselectedLabelStyle: unSelectStyle,
                    indicatorSize: TabBarIndicatorSize.label,
                    onTap: (index) {
                      this.selectIndex = index;
                      /// 更换URL
                      _webviewReference.reloadUrl(index == 0 ? url1 : url2);
                    },
                  ),
                )),
                Expanded(flex: 1, child: Container()),
              ],
            ),

            /// 底部的webview
            Expanded(
              child: WebviewWidget(selectIndex == 0 ? url1 : url2),
            ),
          ],
        ),
      ),

    );
  }
}


// -------------------------------------------------------------------------------------  webview

class WebviewWidget extends StatefulWidget {

  final String url;
  WebviewWidget(this.url, {Key key}) : super(key: key);

  @override
  _WebviewWidgetState createState() => _WebviewWidgetState();
}

class _WebviewWidgetState extends State<WebviewWidget> {

  Rect _rect;
  bool needFullScreen = false;

  @override
  void initState() {
    super.initState();

    _webviewReference.close();
  }

  @override
  void dispose() {
    super.dispose();
    _webviewReference.close();
    _webviewReference.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return _WebviewPlaceholder(onRectChanged: (Rect valueRect) {
      if (_rect == null || _closed) {
          if (_rect != valueRect) {
            _rect = valueRect;
          }
          print('_webviewReference.launch');

          /// 加载webview 的 url
          _webviewReference.launch(
            widget.url,
            withJavascript: true,
            withLocalStorage: true,
            scrollBar: true,
            rect: getRect(),
          );
        } else {
        print('_webviewReference.launch else');
        if (_rect != valueRect) {
          _rect = valueRect;
        }
        _webviewReference.reloadUrl(widget.url);
      }

      /// 圆环加载进度， ⭕️
    }, child: Center(child: CircularProgressIndicator()));
  }

  getRect() {
    if(needFullScreen){
      return null;
    } else {

      MediaQueryData mediaData = MediaQueryData.fromWindow(window);

      return Rect.fromLTRB(
          0.0,
          mediaData.padding.top + 60,
          mediaData.size.width,
          mediaData.size.height - mediaData.padding.top - mediaData.padding.bottom - 10
      );
    }
  }

}



// -------------------------------------------------------------------------------------  占位

 class _WebviewPlaceholder extends SingleChildRenderObjectWidget {

  final ValueChanged<Rect> onRectChanged;

  _WebviewPlaceholder({Key key, @required this.onRectChanged, Widget child}) : super(key: key, child: child);


  @override
  RenderObject createRenderObject(BuildContext context) {
    return _WebviewPlaceholderRender(
      onRectChanged: onRectChanged,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _WebviewPlaceholderRender renderObject) {

    /// 级联写法
    renderObject..onRectChanged = onRectChanged;
  }
}


// -------------------------------------------------------------------------------------  渲染

class _WebviewPlaceholderRender extends RenderProxyBox {

  ValueChanged<Rect> _callBack;
  Rect _rect;

  /// 这里使用了初始化列表   : _callBack = onRectChanged
  /// 另外直接调用父类的child
  _WebviewPlaceholderRender({RenderBox child, ValueChanged<Rect> onRectChanged}) : _callBack = onRectChanged, super(child);


  /// get方法
  Rect get rect => _rect;

  /// set方法
  set onRectChanged(ValueChanged<Rect> callBack) {

    if (_callBack != callBack) {
      _callBack = callBack;
      // 回调
      notifyRect();

    }
  }

  /// 重绘
@override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final rect = offset & size;
    if (_rect != rect) {
        _rect = rect;
        notifyRect();
    }
  }

  void notifyRect() {
    if (_callBack != null && _rect != null) {
      _callBack(_rect);
    }
  }
}