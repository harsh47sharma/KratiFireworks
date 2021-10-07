import 'dart:convert';
import 'models/product_details_model.dart';

class CreateJson {
  Map<String, dynamic> toJson() => {
        'customer_name': ProductDetailsModel.customerName,
        'customer_contact': ProductDetailsModel.contactNo,
        'customer_gst_no': ProductDetailsModel.gstNumber,
        'product_details': json.encode(ProductDetailsModel.orderDetails),
      };
}
