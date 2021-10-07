// To parse this JSON data, do
//
//     final generateInvoiceResponse = generateInvoiceResponseFromJson(jsonString);

import 'dart:convert';

GenerateInvoiceResponse generateInvoiceResponseFromJson(String str) => GenerateInvoiceResponse.fromJson(json.decode(str));

String generateInvoiceResponseToJson(GenerateInvoiceResponse data) => json.encode(data.toJson());

class GenerateInvoiceResponse {
  GenerateInvoiceResponse({
    required this.billNo,
    required this.status,
    required this.message,
    required this.productIssue,
    required this.productMsg,
    required this.statusTab,
  });

  int billNo;
  int status;
  String message;
  List<dynamic> productIssue;
  String productMsg;
  String statusTab;

  factory GenerateInvoiceResponse.fromJson(Map<String, dynamic> json) => GenerateInvoiceResponse(
    billNo: json["billNo"],
    status: json["status"],
    message: json["message"],
    productIssue: List<dynamic>.from(json["product_issue"].map((x) => x)),
    productMsg: json["product_msg"],
    statusTab: json["status_tab"],
  );

  Map<String, dynamic> toJson() => {
    "billNo": billNo,
    "status": status,
    "message": message,
    "product_issue": List<dynamic>.from(productIssue.map((x) => x)),
    "product_msg": productMsg,
    "status_tab": statusTab,
  };
}
