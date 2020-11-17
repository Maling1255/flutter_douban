import 'package:flutter/material.dart';

class RadiusImg {

  /// shape: 设置形状，eg 圆角矩形
  /// shadowColor： 阴影颜色
  /// elevation：阴影的高度， 类似有层次感的效果
  static Widget get(String imgUrl, double imgW, {double imgH, Color shadowColor, double elevation, double radius = 6.0, RoundedRectangleBorder shape}) {
    if (shadowColor == null) {
        shadowColor = Colors.transparent;
    }
    /// Card是material风格的卡片控件，Card有较小的圆角和阴影。Card通常用于展示一组信息，比如相册、位置信息等
    return Card(
      // 影音海报
      /// shape:      http://laomengit.com/blog/20200910/shape_clip.html#cliprect
      /// BeveledRectangleBorder  斜边 斜切的角落的矩形
      /// RoundedRectangleBorder  圆角矩形
      /// ContinuousRectangleBorder  连续的圆角矩形，直线和圆角平滑连续的过渡，和RoundedRectangleBorder相比，圆角效果会小一些。
      /// StadiumBorder 类似于体育场跑道， 2头是圆 中间部分是矩形
      /// OutlineInputBorder 带外边框
      /// UnderlineInputBorder 带下划线的
      shape:  shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(radius))),
      color: shadowColor,
      // 裁剪方式
      clipBehavior: Clip.antiAlias,
      elevation: elevation ?? 5.0,

      ///  BoxFit.cover 填充模式
      child: imgW == null ?
      Image.network(imgUrl, height: imgH, fit: BoxFit.cover) :
      Image.network(imgUrl, width: imgW, height: imgH, fit: imgH == null ? BoxFit.contain : BoxFit.cover),
    );
  }
}