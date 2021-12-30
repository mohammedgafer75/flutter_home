import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestResult {
  bool ok;
  dynamic data;
  Uri url;
  RequestResult(this.ok, this.data, this.url);
}

const PROTOCOL = "https";
// https
// http
const DOMAIN = "flutter-over-flow.herokuapp.com";
// faelkhair.herokuapp.com
// 10.0.2.2:7000
var fullUrl = Uri.parse("$PROTOCOL://$DOMAIN/");

// Future<RequestResult> get_login(String route, [dynamic data]) async {
//   var datastr = jsonEncode(data);
//   var url = Uri.parse("$PROTOCOL://$DOMAIN/$route");
//   var result = await http
//       .post(url, body: datastr, headers: {"Content-Type": "application/json"});

//   return RequestResult(true, jsonDecode(result.body));
// }

// ignore: non_constant_identifier_names
Future<RequestResult> http_post(String route, [dynamic data]) async {
  var url = Uri.parse("$PROTOCOL://$DOMAIN/$route");
  var datastr = jsonEncode(data);
  var result = await http
      .post(url, body: datastr, headers: {"Content-Type": "application/json"});
  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

Future<RequestResult> http_get(String route, [dynamic data]) async {
  var url = Uri.parse("$PROTOCOL://$DOMAIN/$route");
  var datastr = jsonEncode(data);
  var result =
      await http.get(url, headers: {"Content-Type": "application/json"});
  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

Future<RequestResult> delete(String route) async {
  var url = Uri.parse("$PROTOCOL://$DOMAIN/$route");
  var result =
      await http.delete(url, headers: {"Content-Type": "application/json"});

  return RequestResult(true, jsonDecode(result.body), fullUrl);
}
