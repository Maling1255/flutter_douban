
import 'package:flutter/material.dart';

class TodayPlayMovieWidget extends StatelessWidget {

  final urls;
  final backgroundColor;
  TodayPlayMovieWidget(this.urls, {Key key, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (urls == null || urls.isEmpty) {
        return Container(
          child: Text('urls 是空的'),
        );
    }

    return Stack(
      /// Alignment(0,0)代表控件的中心
      /// AlignmentDirectional 的坐标系和Alignment比较像，原点在中心，不过AlignmentDirectional的起始位置和书写（TextDirection）方向有关
      /// FractionalOffset  FractionalOffset继承Alignment，他们2个区别就是坐标系不一样，Alignment的原点是中心，而FractionalOffset原点是左上角。
      /// https://blog.csdn.net/mengks1987/article/details/84852235
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        Container(
          height: 120,
          /// 无穷大
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor == null ? Color.fromARGB(255, 47, 22, 74) : backgroundColor,
            /// 形状：矩形 和圆形
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ],
    );
  }
}
