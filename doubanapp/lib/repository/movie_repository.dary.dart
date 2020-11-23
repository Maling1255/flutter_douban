

import 'package:doubanapp/bean/movie_top_item_bean.dart';
import 'package:doubanapp/bean/subject_entity.dart';
import 'package:doubanapp/constant/cache_key.dart';
import 'package:doubanapp/request/API.dart';
import 'package:doubanapp/request/http_request.dart';
import 'package:doubanapp/request/simulate_request.dart';
import 'package:doubanapp/util/palette_generator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

/// movie请求返回的响应, 包装起来
class MovieRepository {

  // 影院热映
  List<Subject> hotShowBeans;
  // 即将上映
  List<Subject> comingSoonBeans;
  // 豆瓣榜单
  List<Subject> hotBeans;
  // 一周口碑电影榜
  List<SubjectEntity> weeklyBeans;
  // Top250
  List<Subject> top250Beans;
  // 今日播放电影urls
  List<String> todayUrls;

    // 周排行   周热门  周前250
  MovieTopItemBean weeklyTopBean, weeklyHotBean, weeklyTop250Bean;
  Color weeklyTopColor, weeklyHotColor, weeklyTop250Color, todayPlayBgColor;

  MovieRepository({
    this.hotShowBeans,
    this.comingSoonBeans,
    this.hotBeans,
    this.weeklyBeans,
    this.top250Beans,
    this.todayUrls,
    this.weeklyTopBean,
    this.weeklyHotBean,
    this.weeklyTop250Bean,
    this.weeklyTopColor,
    this.weeklyHotColor,
    this.weeklyTop250Color,
    this.todayPlayBgColor,
  });


  var _request;
  Future<MovieRepository> requestAPI() async {
    /// 这里使用偏好设置存储， 是flutte 轻量级的存储，类似于iOS中的NSUserDefault
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool useNetData = prefs.getBool(CacheKey.USE_NET_DATA) ?? false;
    if (useNetData) {
      // 真实请求
        _request = HttpRequest(API.BASE_URL);
    } else {
      // 模拟请求
      _request = SimulateRequest();
    }

    // 影院热映
    var result = await _request.get(API.IN_THEATERS);
    var resultList = result['subjects'];
    // 转模型数组
    hotShowBeans = resultList.map<Subject>((info) => Subject.fromMap(info)).toList();

    // 即将上映
    result = await _request.get(API.COMING_SOON);
    resultList = result['subjects'];
    comingSoonBeans  = resultList.map<Subject>((info) => Subject.fromMap(info)).toList();
    // 取出随机数
    int start = math.Random().nextInt(220);

    //  豆瓣榜单
    if (useNetData) {
      result = await _request.get(API.TOP_250 + '?start=$start&count=7&apikey=0b2bdeda43b5688921839c8ecb20399b');
    } else {
      result = await _request.get(API.TOP_250);
    }
    resultList = result['subjects'];
    hotBeans = resultList.map<Subject>((info) => Subject.fromMap(info)).toList();

    // 一周热门电影榜
    weeklyHotBean = MovieTopItemBean.convertHotBeans(hotBeans);
    /// PaletteGenerator 从图片提取色的库
    var paletteGenertor = await PaletteGenerator.fromImageProvider(NetworkImage(hotBeans[0].images.medium));
    if (paletteGenertor != null && paletteGenertor.colors.isNotEmpty) {
        weeklyTopColor = paletteGenertor.colors.toList()[0];
    }

    // 一周口碑电影榜
    result = await _request.get(API.WEEKLY);
    resultList = result['subjects'];
    weeklyBeans = resultList.map<SubjectEntity>((item) => SubjectEntity.fromMap(item)).toList();
    weeklyTopBean = MovieTopItemBean.convertWeeklyBeans(weeklyBeans);
    paletteGenertor = await PaletteGenerator.fromImageProvider(
        NetworkImage(weeklyBeans[0].subject.images.medium));
    if (paletteGenertor != null && paletteGenertor.colors.isNotEmpty) {
      weeklyTopColor = (paletteGenertor.colors.toList()[0]);
    }

    // 今日可播放电影
    start = math.Random().nextInt(220);
    if (useNetData) {
      result = await _request.get(API.TOP_250 + '?start=$start&count=7&apikey=0b2bdeda43b5688921839c8ecb20399b');
    } else {
      result = await _request.get(API.TOP_250);
    }
    resultList = result['subjects'];
    List<Subject> beans =
    resultList.map<Subject>((item) => Subject.fromMap(item)).toList();
    todayUrls = [];
    todayUrls.add(beans[0].images.medium);
    todayUrls.add(beans[1].images.medium);
    todayUrls.add(beans[2].images.medium);
    paletteGenertor =
    await PaletteGenerator.fromImageProvider(NetworkImage(todayUrls[0]));
    if (paletteGenertor != null && paletteGenertor.colors.isNotEmpty) {
      todayPlayBgColor = (paletteGenertor.colors.toList()[0]);
    }

    // 豆瓣TOP250
    if (useNetData) {
      result = await _request.get(API.TOP_250 + '?start=0&count=5&apikey=0b2bdeda43b5688921839c8ecb20399b');
    } else {
      result = await _request.get(API.TOP_250);
    }
    resultList = result['subjects'];
    top250Beans =
        resultList.map<Subject>((item) => Subject.fromMap(item)).toList();
    weeklyTop250Bean = MovieTopItemBean.convertTopBeans(top250Beans);
    paletteGenertor = await PaletteGenerator.fromImageProvider(
        NetworkImage(top250Beans[0].images.medium));
    if (paletteGenertor != null && paletteGenertor.colors.isNotEmpty) {
      weeklyTop250Color = (paletteGenertor.colors.toList()[0]);
    }

    return MovieRepository(
        hotShowBeans: hotShowBeans,
        comingSoonBeans: comingSoonBeans,
        hotBeans: hotBeans,
        weeklyBeans: weeklyBeans,
        top250Beans: top250Beans,
        todayUrls: todayUrls,
        weeklyTopBean: weeklyTopBean,
        weeklyHotBean: weeklyHotBean,
        weeklyTop250Bean: weeklyTop250Bean,
        weeklyTopColor: weeklyTopColor,
        weeklyHotColor: weeklyHotColor,
        weeklyTop250Color: weeklyTop250Color,
        todayPlayBgColor: todayPlayBgColor);
  }
}