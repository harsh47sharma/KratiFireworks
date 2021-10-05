// To parse this JSON data, do
//
//     final itemSuggestionResponse = itemSuggestionResponseFromJson(jsonString);

import 'dart:convert';

ItemSuggestionResponse itemSuggestionResponseFromJson(String str) => ItemSuggestionResponse.fromJson(json.decode(str));

String itemSuggestionResponseToJson(ItemSuggestionResponse data) => json.encode(data.toJson());

class ItemSuggestionResponse {
  ItemSuggestionResponse({
    required this.data,
  });

  List<Datum> data;

  factory ItemSuggestionResponse.fromJson(Map<String, dynamic> json) => ItemSuggestionResponse(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.code,
    required this.title,
    required this.titleHi,
    required this.price,
    required this.description,
    required this.quantity,
  });

  String id;
  String code;
  String title;
  String titleHi;
  String price;
  dynamic description;
  String quantity;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    code: json["code"],
    title: json["title"],
    titleHi: json["title_hi"],
    price: json["price"],
    description: json["description"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "title": title,
    "title_hi": titleHi,
    "price": price,
    "description": description,
    "quantity": quantity,
  };
}
