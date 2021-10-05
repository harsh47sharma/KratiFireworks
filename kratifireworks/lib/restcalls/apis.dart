import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kratifireworks/restcalls/item_suggestion_response.dart';
import 'package:kratifireworks/restcalls/postapiresponse.dart';

class Apis {
  static final URL = "https://silicon-technologies.co.in/billing/api/";

  Future<OnlyResultResponse> getPendingBills(
      code, title, titleHindi, price, quantity) async {
    final response = await http.post(Uri.parse(URL + "additem.php"), body: {
      "code": code,
      "title": title,
      "title_hi": titleHindi,
      "quantity": quantity,
      "price": price
    });
    return OnlyResultResponse.fromJson(json.decode(response.body));
  }

  Future<ItemSuggestionResponse> getSuggestions(query) async {
    final response = await http.post(
        Uri.parse(URL + "search.php"),
        headers: {
          "Access-Control-Allow-Origin": "*"
        },
        body: {
          "query": query
        });
    print(response.body);
    return ItemSuggestionResponse.fromJson(json.decode(response.body));
  }
}
