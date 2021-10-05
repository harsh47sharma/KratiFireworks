import 'dart:convert';

import 'package:kratifireworks/restcalls/apis.dart';
import 'package:kratifireworks/restcalls/item_suggestion_response.dart';
import 'package:http/http.dart' as http;

class ProductDetailsModel {
  static String? customerName;
  static String? contactNo;
  static String? gstNumber;
  static double? billTotal = 0.0;
  static int? billNo = 0;
  static DateTime? billingDate = DateTime.now();
  static List<OrderDetails> orderDetails = [];

  static addItem(String code, String title, double itemPrice, int quantity,
      double totalPrice) {
    OrderDetails oD = OrderDetails(
        code: code,
        title: title,
        itemPrice: itemPrice,
        quantity: quantity,
        totalPrice: totalPrice);
    orderDetails.add(oD);
  }

  static clear() {
    customerName = "";
    contactNo = "";
    gstNumber = "";
    billTotal = 0.0;
    billNo = 0;
    orderDetails.clear();
  }

  static removeItem(item) {
    ProductDetailsModel.orderDetails
        .remove(item);
  }

  static Future<List<Datum>> getSuggestions(String query) async {
    final response = await http.post(
        Uri.parse(Apis.URL + "search.php"),
        body: {
          "query": query
        });
    print(response.body);
    var map = ItemSuggestionResponse.fromJson(json.decode(response.body));
    return map.data;
  }
}

class OrderDetails {
  String code;
  String title;
  double itemPrice;
  int quantity;
  double totalPrice;

  OrderDetails(
      {required this.code,
      required this.title,
      required this.itemPrice,
      required this.quantity,
      required this.totalPrice});

  Map toJson() => {
    'code': code,
    'title': title,
    'item_price': itemPrice.toString(),
    'quantity': quantity.toString(),
    'total_price': totalPrice.toString(),
  };
}
