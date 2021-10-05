// To parse this JSON data, do
//
//     final onlyResultResponse = onlyResultResponseFromJson(jsonString);

import 'dart:convert';

OnlyResultResponse onlyResultResponseFromJson(String str) => OnlyResultResponse.fromJson(json.decode(str));

String onlyResultResponseToJson(OnlyResultResponse data) => json.encode(data.toJson());

class OnlyResultResponse {
  OnlyResultResponse({
    required this.status,
    required this.message,
  });

  int status;
  String message;

  factory OnlyResultResponse.fromJson(Map<String, dynamic> json) => OnlyResultResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
