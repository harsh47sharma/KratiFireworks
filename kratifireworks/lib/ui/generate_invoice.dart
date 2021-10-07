import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kratifireworks/pdf_viewer_page.dart';
import 'package:kratifireworks/create_json.dart';
import 'package:kratifireworks/models/product_details_model.dart';
import 'package:kratifireworks/restcalls/apis.dart';
import 'package:kratifireworks/restcalls/generate_invoice_response.dart';
import 'package:kratifireworks/restcalls/item_suggestion_response.dart';
import 'package:kratifireworks/ui/widgets/progress_indicator_widget.dart';
import 'package:kratifireworks/ui/widgets/test_feild_widget.dart';
import 'package:kratifireworks/util.dart';

class GenerateInvoice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GenerateInvoiceState();
  }
}

class _GenerateInvoiceState extends State<GenerateInvoice> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _gstController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _itemPriceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _totalPriceController = TextEditingController();
  Apis apis = Apis();
  int _totalQuantity = -1;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    ProductDetailsModel.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressIndicatorWidget(
        isLoading: _isLoading,
        child: LayoutBuilder(builder: (context, constraints) {
          return Align(
            alignment: Alignment.topCenter,
            child: Form(
              key: _formKey,
              child: getUi(constraints),
            ),
          );
        }),
      ),
    );
  }

  textFieldWithText(String label, controller, String hint) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
            ),
            keyboardType: TextInputType.text,
            controller: controller,
          )
        ],
      ),
    );
  }

  getTextField(controller, type, {decimal = false, var onChanged}) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        style: TextStyle(fontFamily: 'RobotoRegular'),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
          isDense: true,
          contentPadding: EdgeInsets.all(10),
          labelStyle: TextStyle(fontFamily: 'RobotoRegular'),
          hintStyle: TextStyle(
              fontFamily: 'RobotoRegular',
              color: Color.fromRGBO(124, 139, 154, 1)),
        ),
        controller: controller,
        keyboardType: type,
        onChanged: (e) => onChanged(),
        inputFormatters: (type == TextInputType.number)
            ? (!decimal)
                ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]{1,6}'))]
                : [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                    FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*"))
                  ]
            : null,
      ),
    );
  }

  getTableCell(String title, {bool bold = false}) {
    return Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: TextStyle(
                fontSize: 14,
                fontFamily: bold ? 'RobotoBold' : 'RobotoRegular')));
  }

  validateProductDetails(constraints) {
    String s = "null";
    if (_codeController.text.trim().isEmpty)
      s = "Item Code can't be empty";
    else if (_titleController.text.trim().isEmpty)
      s = "Title can't be empty";
    else if (_itemPriceController.text.trim().isEmpty)
      s = "Item Price can't be empty";
    else if (_quantityController.text.trim().isEmpty)
      s = "Item Quantity can't be empty";
    else if (_totalPriceController.text.trim().isEmpty)
      s = "Total Price can't be empty";

    if (s == "null") {
      if (_formKey.currentState!.validate()) {
        setState(() {
          ProductDetailsModel.addItem(
              _codeController.text.trim(),
              _titleController.text.trim(),
              double.parse(_itemPriceController.text),
              int.parse(_quantityController.text),
              double.parse(_totalPriceController.text));
        });
        _codeController.clear();
        _titleController.clear();
        _itemPriceController.clear();
        _quantityController.clear();
        _totalPriceController.clear();
      } else {
        if(constraints.maxWidth <= 700) {
          Util.dialog(context, _totalQuantity.toString() +
              " Available in stock.", "OK", title: "Alert!");
        }
      }
    } else {
      Util.dialog(context, s, "OK", title: "Alert!");
    }
  }

  onTapGenerateEstimate() {
    String s = "null";
    if (_nameController.text.trim().isEmpty)
      s = "Please Enter Customer's Name";
    else if (_contactController.text.trim().isEmpty)
      s = "Please Enter Customer's Contact Number";
    else if (_gstController.text.trim().isEmpty)
      s = "Please Enter Customer's GST Number";
    else if (ProductDetailsModel.orderDetails.length <= 0)
      s = "No Product Added";
    if (s == "null") {
      setState(() {
        _isLoading = true;
      });
      ProductDetailsModel.orderDetails.forEach((element) {
        ProductDetailsModel.billTotal =
            (ProductDetailsModel.billTotal! + element.totalPrice);
        ProductDetailsModel.customerName = _nameController.text;
        ProductDetailsModel.contactNo = _contactController.text;
        ProductDetailsModel.gstNumber = _gstController.text;
        Future<GenerateInvoiceResponse> map = apis.generateInvoiceApiCall();
        map.then((value) {
          ProductDetailsModel.billNo = value.billNo;
          setState(() {
            _isLoading = false;
          });
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => PdfViewerPage()), //pdfInBytes: pdfInBytes
            )).then((_) => setState(() {
              ProductDetailsModel.clear();
              _nameController.clear();
              _contactController.clear();
              _gstController.clear();
            }));
      });
    } else {
      Util.dialog(context, s, "OK", title: "Alert!");
    }
  }

  calculateTotal() {
    if (_itemPriceController.text.isEmpty || _quantityController.text.isEmpty) {
      _totalPriceController.text = "";
    } else {
      _totalPriceController.text = (double.parse(_itemPriceController.text) *
              int.parse(_quantityController.text))
          .toStringAsFixed(2)
          .toString();
    }
  }

  getSuggestionField(controller, bool code) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TypeAheadField<Datum?>(
        textFieldConfiguration: TextFieldConfiguration(
            onChanged: (s) {
              _totalQuantity = -1;
            },
            style: TextStyle(fontFamily: 'RobotoRegular'),
            controller: controller,
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2)))),
        suggestionsCallback: ProductDetailsModel.getSuggestions,
        itemBuilder: (context, Datum? data) {
          Datum suggestions = data!;
          return Column(
            children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(suggestions.code + ": " + suggestions.titleHi,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'RobotoRegular', fontSize: 14))),
              Divider(thickness: 1, color: Colors.grey, height: 0)
            ],
          );
        },
        onSuggestionSelected: (suggestion) {
          _codeController.text = suggestion!.code.toString();
          _titleController.text = suggestion.titleHi.toString();
          _itemPriceController.text = suggestion.price.toString();
          _totalQuantity = int.parse(suggestion.quantity);
        },
      ),
    );
  }

  getUi(constraints) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Card(
        color: Colors.white,
        child: Container(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (constraints.maxWidth >= 700)
                      ? Row(
                          children: [
                            Expanded(
                              child: TextFieldWidget(
                                  label: "Name",
                                  controller: _nameController,
                                  hint: "Enter Customer's name",
                                  type: TextInputType.text),
                            ),
                            Expanded(
                              child: TextFieldWidget(
                                  label: "Contact Number",
                                  controller: _contactController,
                                  hint: "Enter Customer's Contact Number",
                                  type: TextInputType.number),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            TextFieldWidget(
                                label: "Name",
                                controller: _nameController,
                                hint: "Enter Customer's name",
                                type: TextInputType.text),
                            TextFieldWidget(
                                label: "Contact Number",
                                controller: _contactController,
                                hint: "Enter Customer's Contact Number",
                                type: TextInputType.number),
                          ],
                        ),
                  TextFieldWidget(
                      label: "Customer's GST No.",
                      controller: _gstController,
                      hint: "Enter Customer's GST No.",
                      type: TextInputType.text),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Text(
                        "Product Details",
                        style: TextStyle(
                          fontFamily: 'RobotoBold',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(4),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                        4: FlexColumnWidth(2),
                        5: FlexColumnWidth(1),
                      },
                      border: TableBorder.all(
                          color: Colors.blueGrey,
                          style: BorderStyle.solid,
                          width: 0.2),
                      children: [
                        TableRow(children: [
                          getTableCell("Code", bold: true),
                          getTableCell("Title", bold: true),
                          getTableCell("Price/Item", bold: true),
                          getTableCell("Quantity", bold: true),
                          getTableCell("Total Price", bold: true),
                          getTableCell("Actions", bold: true),
                        ]),
                        for (var item in ProductDetailsModel.orderDetails)
                          TableRow(
                            children: [
                              getTableCell(item.code),
                              getTableCell(item.title),
                              getTableCell(item.itemPrice.toString()),
                              getTableCell(item.quantity.toString()),
                              getTableCell(item.totalPrice.toString()),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    ProductDetailsModel.removeItem(item);
                                  });
                                },
                                child: Icon(Icons.delete, color: Colors.red),
                              )
                            ],
                          ),
                        TableRow(children: [
                          getSuggestionField(_codeController, true),
                          getSuggestionField(_titleController, false),
                          getTextField(
                              _itemPriceController, TextInputType.number,
                              decimal: true, onChanged: () => calculateTotal()),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                                validator: (value) {
                                  if (int.parse(value!) > _totalQuantity && _totalQuantity!=-1) {
                                    return _totalQuantity.toString() +
                                        " Available in stock.";
                                  }
                                  return null;
                                },
                                style: TextStyle(fontFamily: 'RobotoRegular'),
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(fontFamily: 'RobotoRegular'),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  labelStyle:
                                      TextStyle(fontFamily: 'RobotoRegular'),
                                  hintStyle: TextStyle(
                                      fontFamily: 'RobotoRegular',
                                      color: Color.fromRGBO(124, 139, 154, 1)),
                                ),
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                onChanged: (e) => calculateTotal(),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]{1,6}'))
                                ]),
                          ),
                          getTextField(
                              _totalPriceController, TextInputType.number,
                              decimal: true),
                          GestureDetector(
                            onTap: () {
                              validateProductDetails(constraints);
                            },
                            child: Icon(Icons.add, color: Colors.green),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: Util.primaryColor,
                      child: Text("Generate Estimate",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'RobotoMedium',
                            fontSize: 20,
                          )),
                      onPressed: () {
                        onTapGenerateEstimate();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
