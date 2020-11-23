
/// 类型转换库
import 'dart:convert' as Convert;
import 'package:http/http.dart' as http;
import 'dart:io';

typedef RequestCallBack = void Function(Map data);
class HttpRequest {

  static requestGET(String authority, String unencodePath, RequestCallBack callBack, [Map<String, String> queryOarameters]) async {
    try {
          var httpClient = HttpClient();
          var url = Uri.http(authority, unencodePath, queryOarameters);
          var request = await httpClient.getUrl(url);
          var respose = await request.close();
          var resposeBody = await respose.transform(Convert.utf8.decoder).join();

          /// json转到字典
          Map data = Convert.jsonDecode(resposeBody);
          callBack(data);
    } on Exception catch(e) {
      print(e.toString());
    }
  }

  final baseUrl;
  HttpRequest(this.baseUrl);

  Future<dynamic> get(String url, {Map<String, String> headers}) async {
    try {
     http.Response response = await http.get(baseUrl + url, headers: headers);
     final statusCode = response.statusCode;
     String body = response.body;

     print('[uri=$baseUrl' + '$url]  [statusCode=$statusCode]  [response=$body]');

     /// json转字典/数组
     var result = Convert.jsonDecode(body);
     return result;
    } on Exception catch(e) {
      print('[uri=$url]exception e=${e.toString()}');
      return '';
    }
  }

  Future<dynamic> getResposeBody(String url, {Map<String, String> headers}) async {
    try {
      http.Response response = await http.get(baseUrl + url, headers: headers);
      final statusCode = response.statusCode;
      String body = response.body;

      print('[url=$url][statusCode=$statusCode][response=$body]');
      return body;
    } on Exception catch (e) {
      print('[url=$url]exception e=${e.toString()}');
      return null;
    }
  }

  Future<dynamic> post(String url, dynamic body, {Map<String, String> headers}) async {
    try {
     http.Response response = await http.post(baseUrl + url, body: body,headers: headers);
     final statusCode = response.statusCode;
     String responseBody = response.body;

     print('[url=$url][statusCode=$statusCode][response=$responseBody]');
     /// json转字典/数组
     var result = Convert.jsonDecode(responseBody);
     return result;
    } on Exception catch(e) {
      print('[url=$url]exception e=${e.toString()}');
      return '';
    }
  }

}