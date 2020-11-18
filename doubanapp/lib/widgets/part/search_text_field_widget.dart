import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 文本搜索框
class SearchTextFieldWidget extends StatelessWidget {

  // 占位文本
  final String placeholder;
  // 搜索点击
  final VoidCallback onTap;
  // 文本改变回调
  final ValueChanged<String> onSubmitted;
  // EdgeInsetsGeometry是EdgeInsets以及EdgeInsetsDirectional的基类， 抽象类
  // 内间距
  // 要将不确定类型的[EdgeInsetsGeometry]对象转换为[EdgeInsets]对象，请调用[resolve]方法。
  final EdgeInsetsGeometry margin;

  SearchTextFieldWidget({
    Key key,
    this.placeholder,
    this.onTap,
    this.onSubmitted,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin == null ? EdgeInsets.all(0.0) : margin,
      width: MediaQuery.of(context).size.width,

      /// 带方向的， 以中间位置开始布局； AlignmentDirectional.bottomEnd 以右下角开始布局
      alignment: AlignmentDirectional.center,
      height: 37.0,
      // 圆角
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,  /// 默认这个？？
          color: Color.fromARGB(255, 237, 236, 237),
          borderRadius: BorderRadius.circular(24.0)
      ),
      child: TextField(
        onSubmitted: onSubmitted,
        /// 光标颜色
        cursorColor: Color.fromARGB(255, 0, 189, 96),
        /// InputDecoration 并不是一个控件，而是一个装饰类，用于装饰Material 风格的TextField组件的边框，标签，图标和样式。
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 8.0, bottom: 10),
          /// 关闭底部输入指示线
          border: InputBorder.none,
          /// 占位暗文字
          hintText: placeholder,
          hintStyle: TextStyle(fontSize: 17, color: Color.fromARGB(255, 192, 191, 191)),
          // 前缀图标，搜索🔍
          prefixIcon: Icon(Icons.search, size: 25, color: Color.fromARGB(255, 128, 128, 128)),
        ),
        style: TextStyle(fontSize: 17),
      ),
    );
  }
}
