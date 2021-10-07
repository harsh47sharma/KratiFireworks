import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kratifireworks/models/product_details_model.dart';
import 'package:kratifireworks/restcalls/generate_invoice_response.dart';
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
    final response = await http.post(Uri.parse(URL + "search.php"),
        headers: {"Access-Control-Allow-Origin": "*"}, body: {"query": query});
    return ItemSuggestionResponse.fromJson(json.decode(response.body));
  }

  convert(String query) async {
    final response = await http.get(
      Uri.parse(
          "https://inputtools.google.com/request?text=" + query + "&itc=hi-t-i0-und&num=4&cp=0&cs=1&ie=utf-8&oe=utf-8&app=demopage"),
    );
    String s =
        response.body;
    int count = 0;
    String f = "";
    for (int i = 0; i < s.length; i++) {
      var char = s[i];
      if (char == "[") {
        count++;
      }
      if (count == 4) {
        if(char == "]") {
          break;
        }
        f += char;
      }
    }
    f = f.replaceAll("[", "");
    f = f.replaceAll('"', "");
    return f.split(",").first;
  }

  Future<GenerateInvoiceResponse> generateInvoiceApiCall() async {
    final response = await http.post(Uri.parse(URL + "createInvoice.php"),
        body: {
          'customer_name': ProductDetailsModel.customerName,
          'customer_contact': ProductDetailsModel.contactNo,
          'customer_gst_no': ProductDetailsModel.gstNumber,
          'product_details': json.encode(ProductDetailsModel.orderDetails),
    });
    return GenerateInvoiceResponse.fromJson(json.decode(response.body));
  }
}
