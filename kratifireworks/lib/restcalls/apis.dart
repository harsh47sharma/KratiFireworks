import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kratifireworks/restcalls/postapiresponse.dart';

class Apis{
  static final URL = "http://silicon-technologies.co.in/billing/api/additem.php";

  Future<OnlyResultResponse> getPendingBills(code, title, titleHindi, price) async {
    final response = await http.post(URL,
        body: {"code":code,
          "title":title,
          "title_hi":titleHindi,
          "price":price});
    print(response.body);
    return OnlyResultResponse.fromJson(json.decode(response.body));
  }
}