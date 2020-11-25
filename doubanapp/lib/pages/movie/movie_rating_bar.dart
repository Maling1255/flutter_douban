
import 'package:doubanapp/bean/subject_entity.dart';
import 'package:doubanapp/constant/constant.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/rendering/box.dart';

/// 电影评分， 星星评分
class MovieRatingBar extends StatelessWidget {

  double stars;
  final double size;
  final double fontSize;

  // 实心星星的颜色
  final color = Color.fromARGB(255, 255, 170, 71);

  MovieRatingBar(this.stars, {Key key, this.size = 18, this.fontSize = 13}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Widget> starList = [];
    // 1. 实心星星        /// 整除
    var starCount = stars ~/ 2;

    // 2. 半实心, 这里找小数是否大于 0.5 如果大于就算半个星， 如果小于没有半颗星
    var starHalfCount = 0;
    if (stars.toString().contains('.')) {
      int tmp = int.parse((stars.toString().split('.')[1]));
      if (tmp >= 5) {
        starHalfCount = 1;
      }
    }

    // 3. 空心星星
    var starNullCount = 5 - starCount - starHalfCount;

    for (var i = 0; i < starCount; i++) {
      starList.add(Icon(
        Icons.star,
        color: color,
        size: size,
      ));
    }
    if (starHalfCount > 0) {
      starList.add(Icon(
        Icons.star_half,
        color: color,
        size: size,
      ));
    }
    for (var i = 0; i < starNullCount; i++) {
      starList.add(Icon(
        Icons.star_border,
        color: Colors.grey,
        size: size,
      ));
    }

    starList.add(Text(
      '$stars',
      style: TextStyle(color: Colors.grey, fontSize: fontSize),
    ));
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        children: starList,
      ),
    );
  }
}





