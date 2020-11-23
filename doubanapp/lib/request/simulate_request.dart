import 'dart:async';
import 'package:doubanapp/request/API.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' as Convert;

/// 模拟请求， 使用的是本地json 文件
class SimulateRequest {
  // GET请求
  Future<dynamic> get(String action, {Map params}) async {
    return SimulateRequest.request(action: getJsonName(action), params: params);
  }

  // POST请求
  Future<dynamic> post({String action, Map parmas}) async {
    return SimulateRequest.request(action: action, params: parmas);
  }

  static Future<dynamic> request({String action, Map params}) async {

    /// 模拟请求， 这里加载的本地json, 需要在pubspec.yaml中配置路径
    var resposeStr = await rootBundle.loadString('simulate/$action.json');
    /// json转字典
    var resposeJson = Convert.jsonDecode(resposeStr);

    return resposeJson;
  }

  Map<String, String> map = {
    API.IN_THEATERS: 'in_theaters',
    API.COMING_SOON: 'coming_soon',
    API.TOP_250: 'top250',
    API.WEEKLY: 'weekly',
    API.REIVIEWS: 'reviews',
  };

  getJsonName(String action) {
    return map[action];
  }
}
