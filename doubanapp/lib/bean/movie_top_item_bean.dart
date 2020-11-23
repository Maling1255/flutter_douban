
import 'package:doubanapp/bean/subject_entity.dart';
import 'dart:math' as math;

class MovieTopItemBean {

  // 共多少部
  var count;
  // 图片url
  var imgUrl;
  // 多少电影数组
  List<MovieItem> items;

  MovieTopItemBean(this.count, this.imgUrl, this.items);

  // 将 周口碑数据转换成榜单item 对应的数据类型
  static MovieTopItemBean convertWeeklyBeans(List<SubjectEntity> weeklyBeans) {
    var count = '每周五更新 · 共${math.min(weeklyBeans.length, 10)}部';
    var imgUrl = weeklyBeans[0].subject.images.large;
    int itemCount = math.min(4, weeklyBeans.length);
    /// 数组读取数据， 取出子数组
    weeklyBeans = weeklyBeans.sublist(0, itemCount);
    List<MovieItem> items = [];
    for (SubjectEntity bean in weeklyBeans) {
       items.add(MovieItem(bean.subject.title, bean.subject.rating.average, bean.delta > 0));
    }
    return  MovieTopItemBean(count, imgUrl, items);
  }

  // 将 一周热门数据转换成榜单item对应的数据类型
  static MovieTopItemBean convertHotBeans(List<Subject> hotBeans) {
    var count = '每周五更新 · 共${math.min(10, hotBeans.length)}部';
    var imgUrl = hotBeans[0].images.large;
    int itemCount = math.min(4, hotBeans.length);
    hotBeans = hotBeans.sublist(0, itemCount);
    List<MovieItem> items = [];
    for(Subject bean in hotBeans){
      items.add(MovieItem(bean.title, bean.rating.average, true));
    }
    return MovieTopItemBean(count, imgUrl, items);
  }
  // 将 Top250数据转换成榜单item对应的数据类型
  static MovieTopItemBean convertTopBeans(List<Subject> hotBeans) {
    var count = '豆瓣榜单 · 共250部';
    var imgUrl = hotBeans[0].images.large;
    int itemCount = math.min(4, hotBeans.length);
    hotBeans = hotBeans.sublist(0, itemCount);
    List<MovieItem> items = [];
    for(Subject bean in hotBeans){
      items.add(MovieItem(bean.title, bean.rating.average, true));
    }
    return MovieTopItemBean(count, imgUrl, items);
  }

}


class MovieItem {
  // 电影名称
  var title;
  // 评分
  var average;
  // 热度上升还是下降
  bool upOrDown;
  MovieItem(this.title, this.average, this.upOrDown);
}