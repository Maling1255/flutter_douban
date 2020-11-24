
import 'package:doubanapp/constant/constant.dart';
import 'package:flutter/material.dart';

/// 今日播放，
class TodayPlayMovieWidget extends StatelessWidget {

  final urls;
  final backgroundColor;
  TodayPlayMovieWidget(this.urls, {Key key, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (urls == null || urls.isEmpty) {
        return Container(
          child: Text('urls 是空的, 正在加载数据...'),
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
            /// 形状：矩形 和 圆角
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        Container(
          height: 140,
          margin: EdgeInsets.only(left: 13, bottom: 14),
          child: Row(
            children: <Widget>[
              Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  // 重叠层
                  TodayLaminatedImage(urls: urls, width: 90.0),
                  Positioned(left: 90 / 3, child: Image.asset(Constant.ASSETS_IMG + 'ic_action_playable_video_s.png', width: 30.0, height: 30.0)),
                ],
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.0, left: 15.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('今日可播放电影已更新', style: TextStyle(fontSize: 15, color: Colors.white)),
                          Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: Text(
                              '全部 30 >>',
                              style: TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                     Positioned(
                       bottom: -10,
                       right: -2,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: <Widget>[
                           Padding(
                             padding: EdgeInsets.only(bottom: 10.0),
                             child: Image.asset(
                               'assets/images/sofa.png',
                               width: 15.0,
                               height: 15.0,
                             ),
                           ),
                           Padding(
                             padding: EdgeInsets.only(bottom: 10.0, right: 10.0, left: 5.0),
                             child: Text(
                               '看电影',
                               style: TextStyle(fontSize: 11, color: Colors.white),
                             ),
                           )
                         ],
                       ),
                     ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

  }
}


class TodayLaminatedImage extends StatelessWidget {

  List urls;
  double width;
  TodayLaminatedImage({Key key, @required this.urls, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = width * 1.5;
    double dif = width * 0.14;
    double secondLeftPadding = width * 0.42;
    double thirdLeftPadding = width * 0.78;

    return Container(
      height: height,
      width: width + thirdLeftPadding,
      color: Colors.transparent,
      child: Stack(

        /// 从底部右侧
        alignment: Alignment.bottomRight,
        children: <Widget>[
          /// ClipRect组件使用矩形裁剪子组件
          /// ClipRRect组件可以对子组件进行裁剪
          Positioned(left: width * 0.78, child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image.network(
              urls[2],
              width: width,
              height: height - dif - dif / 2,
              /// 填充方式， 以尽可能小的覆盖整个目标框
              fit: BoxFit.cover,
            ),
          ),),
          Positioned(
            left: secondLeftPadding,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Image.network(
                'https://upload-images.jianshu.io/upload_images/1612683-1058467f8a2d221f.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240',
                width: width,
                height: height - dif,
                fit: BoxFit.cover,
                color: Color.fromARGB(100, 246, 246, 246),
                /// 图像的混合模式  https://www.jianshu.com/p/4fb8f1a08d12
                colorBlendMode: BlendMode.screen,
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Image.network(
                urls[0],
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


