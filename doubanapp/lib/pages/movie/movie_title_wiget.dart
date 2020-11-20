
import 'package:flutter/material.dart';

typedef TapCallback = void Function();

///《书影业》顶部四个TAB
class TitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _TextImgWidget(text: '找电影', imgAsset: 'assets/images/find_movie.png', tabCallBack: (){

        }),
        _TextImgWidget(text: '豆瓣榜单', imgAsset: 'assets/images/douban_top.png', tabCallBack: (){

        }),
        _TextImgWidget(text: '豆瓣菜', imgAsset: 'assets/images/douban_guess.png', tabCallBack: (){

        }),
        _TextImgWidget(text: '豆瓣片单', imgAsset: 'assets/images/douban_film_list.png', tabCallBack: (){

        }),
      ],
    );
  }
}

class _TextImgWidget extends StatelessWidget {

  final String text;
  final String imgAsset;
  final TapCallback tabCallBack;

  _TextImgWidget({Key key, @required this.text, @required this.imgAsset, this.tabCallBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Image.asset(imgAsset, width: 45, height: 45),
          /// 设置间隙 间距
          SizedBox(height: 5),
          Text(text, style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 128, 128, 128))),
        ],
      ),
    );
  }
}

