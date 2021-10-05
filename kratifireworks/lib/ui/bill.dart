//import 'package:flutter/material.dart';
//import 'package:kratifireworks/models/product_details_model.dart';
//import 'package:kratifireworks/ui/bill_print_page.dart';
//import 'package:kratifireworks/util.dart';
//import 'package:pdf/pdf.dart';
//import 'package:pdf/widgets.dart' as pw;
//import 'dart:typed_data';
//import 'package:universal_html/html.dart' as html;
//
//import '../pdf_viewer_page.dart';
//
//class Bill extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _BillState();
//  }
//}
//
//class _BillState extends State<Bill> {
//  String? _date;
//  double _total = 0.0;
//  var pdf = pw.Document();
//  var anchor;
//  Uint8List? pdfInBytes;
//
//  @override
//  void initState() {
//    _date = DateTime.now().toString().substring(0, 19);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    ProductDetailsModel.addItem("code", "title", 12, 12, 24);
//    for (var item in ProductDetailsModel.orderDetails)
//      _total += item.totalPrice;
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.white,
//      body: LayoutBuilder(builder: (context, constraints) {
//        return Stack(
//          children: [
//            Align(alignment: Alignment.topCenter, child: getUi(constraints)),
//            Positioned(
//              right: 10,
//              child: Container(
//                margin: EdgeInsets.only(top: 25),
//                child: RaisedButton(
//                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(5.0)),
//                  color: Util.primaryColor,
//                  child: Text("Print",
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontFamily: 'RobotoMedium',
//                        fontSize: 15,
//                      )),
//                  onPressed: () async {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: ((context) => PdfViewerPage()), //pdfInBytes: pdfInBytes
//                        ));
////                    createPDF(context);
////                    anchor.click();
////                    final pdfFile = await PdfInvoiceApi.generate(
////                        Center(child: Text("Hello World")));
//                  },
//                ),
//              ),
//            ),
//          ],
//        );
//      }),
//    );
//  }
//
//  getUi(BoxConstraints constraints) {
//    return Container(
//        width: (MediaQuery.of(context).size.width / 10) * 9,
//        child: SingleChildScrollView(
//          child: Container(
//            margin: EdgeInsets.symmetric(vertical: 20),
//            child: Column(
//              children: [
//                Text(
//                  "KRATI FIRE WORKS",
//                  style: TextStyle(
//                      fontSize: 35,
//                      fontFamily: 'RobotoMedium',
//                      color: Color.fromRGBO(255, 0, 0, 1)),
//                ),
//                Container(
//                  margin: EdgeInsets.only(top: 10, bottom: 30),
//                  child: Text(
//                    "158, Palhar Nagar Airport Road Indore(M.P.), Mob : 9827386820, 99273600012",
//                    style: TextStyle(
//                      fontSize: 14,
//                      color: Colors.black,
//                      fontFamily: 'RobotoLight',
//                    ),
//                  ),
//                ),
//                Text(
//                  "Estimate",
//                  style: TextStyle(
//                      fontSize: 25,
//                      fontFamily: 'RobotoMedium',
//                      color: Color.fromRGBO(255, 0, 0, 1)),
//                ),
//                Container(
//                  margin: EdgeInsets.only(top: 10, bottom: 20),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: [
//                          getRichText("Customer Name: ",
//                              ProductDetailsModel.customerName),
//                          Container(
//                            margin: EdgeInsets.symmetric(vertical: 5),
//                            child: getRichText(
//                                "Contact: ", ProductDetailsModel.contactNo),
//                          ),
//                          getRichText(
//                              "GST No.: ", ProductDetailsModel.gstNumber),
//                        ],
//                      ),
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.end,
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: [
//                          getRichText("Estimate #: ", "56"),
//                          Container(
//                            margin: EdgeInsets.symmetric(vertical: 5),
//                            child: getRichText("Date: ", _date),
//                          )
//                        ],
//                      )
//                    ],
//                  ),
//                ),
//                getTable(),
//                Align(
//                  alignment: Alignment.centerLeft,
//                  child: Container(
//                    margin: EdgeInsets.only(
//                        top: 20, bottom: 10, left: 10, right: 10),
//                    child: Text(
//                      "Krati Fire Works",
//                      style: TextStyle(
//                        fontFamily: 'RobotoMedium',
//                        fontSize: 24,
//                      ),
//                    ),
//                  ),
//                ),
//                Container(
//                  alignment: Alignment.centerLeft,
//                  margin: EdgeInsets.symmetric(horizontal: 10),
//                  child: (constraints.maxWidth >= 700)
//                      ? Row(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: [
//                            Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: [
//                                getRichText(
//                                    "Yes Bank A/C No.: ", "047863300003016"),
//                                Container(
//                                  margin: EdgeInsets.symmetric(vertical: 5),
//                                  child:
//                                      getRichText("IFC Code : ", "YESB0000478"),
//                                )
//                              ],
//                            ),
//                            Text("Composition Dealer : GSTIN - 23AJDPPO300L1ZO",
//                                style: TextStyle(
//                                    fontSize: 14,
//                                    fontFamily: 'RobotoMedium',
//                                    color: Colors.black))
//                          ],
//                        )
//                      : Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: [
//                            getRichText(
//                                "Yes Bank A/C No.: ", "047863300003016"),
//                            Container(
//                              margin: EdgeInsets.symmetric(vertical: 5),
//                              child: getRichText("IFC Code : ", "YESB0000478"),
//                            ),
//                            Text("Composition Dealer : GSTIN - 23AJDPPO300L1ZO",
//                                style: TextStyle(
//                                    fontSize: 14,
//                                    fontFamily: 'RobotoMedium',
//                                    color: Colors.black))
//                          ],
//                        ),
//                )
//              ],
//            ),
//          ),
//        ));
//  }
//
//  getRichText(text1, text2) {
//    return RichText(
//      text: TextSpan(
//        children: [
//          TextSpan(
//              text: text1,
//              style: TextStyle(
//                  fontSize: 14,
//                  fontFamily: 'RobotoMedium',
//                  color: Colors.black)),
//          TextSpan(
//              text: text2,
//              style: TextStyle(
//                  fontSize: 14,
//                  fontFamily: 'RobotoRegular',
//                  color: Colors.black))
//        ],
//      ),
//    );
//  }
//
//  getTable() {
//    return Column(
//      children: [
//        Table(
//          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//          columnWidths: {
//            0: FlexColumnWidth(1),
//            1: FlexColumnWidth(2),
//            2: FlexColumnWidth(10),
//            3: FlexColumnWidth(2),
//            4: FlexColumnWidth(2),
//            5: FlexColumnWidth(3),
//          },
//          border: TableBorder.all(
//              color: Colors.blueGrey, style: BorderStyle.solid, width: 0.2),
//          children: [
//            TableRow(children: [
//              getTableCell("S.No", bold: true),
//              getTableCell("Code", bold: true),
//              getTableCell("Particulars", bold: true),
//              getTableCell("Quantity", bold: true),
//              getTableCell("Rate", bold: true),
//              getTableCell("Amount", bold: true),
//            ]),
//            for (var item in ProductDetailsModel.orderDetails)
//              TableRow(
//                children: [
//                  getTableCell(ProductDetailsModel.orderDetails
//                      .indexOf(item)
//                      .toString()),
//                  getTableCell(item.code),
//                  getTableCell(item.title),
//                  getTableCell(item.quantity.toString()),
//                  getTableCell(item.itemPrice.toString()),
//                  getTableCell(item.totalPrice.toString()),
//                ],
//              ),
//          ],
//        ),
//        Table(
//          columnWidths: {
//            0: FlexColumnWidth(17),
//            1: FlexColumnWidth(3),
//          },
//          border: TableBorder.all(
//              color: Colors.blueGrey, style: BorderStyle.solid, width: 0.2),
//          children: [
//            TableRow(
//              children: [
//                getTableCell("Total:", bold: true, size: 16.0),
//                getTableCell(_total.toString(), bold: true, size: 16.0),
//              ],
//            )
//          ],
//        )
//      ],
//    );
//  }
//
//  getTableCell(String title, {bool bold = false, size = 14.0}) {
//    return Container(
//        padding: EdgeInsets.symmetric(
//            horizontal: (MediaQuery.of(context).size.width > 844) ? 10 : 5,
//            vertical: 10),
//        alignment: Alignment.centerLeft,
//        child: Text(title,
//            style: TextStyle(
//                fontSize: size,
//                fontFamily: bold ? 'RobotoBold' : 'RobotoRegular')));
//  }
//
//  createPDF(context1) async {
//    pdf = pw.Document();
//    print("KKLL");
//    pdf.addPage(
//      pw.MultiPage(
//          pageFormat: PdfPageFormat.a3,
//          build: (context) => [getPdfUi(context1, 51, _date, _total)]),
//    );
//    savePDF();
//  }
//
//  savePDF() async {
//    pdfInBytes = await pdf.save();
//    final blob = html.Blob([pdfInBytes], 'application/pdf');
//    final url = html.Url.createObjectUrlFromBlob(blob);
//    anchor = html.document.createElement('a') as html.AnchorElement
//      ..href = url
//      ..style.display = 'none'
//      ..download = 'pdf.pdf';
//    html.document.body?.children.add(anchor);
//    // _print(pdfInBytes);
//  }
//
////  Future<void> _print(pdfInBytes) async {
////    var format;
////
////      format = PdfPageFormat(
////        pages.first.page!.width * 72 / dpi,
////        pages.first.page!.height * 72 / dpi,
////        marginAll: 5 * PdfPageFormat.mm,
////    }
////
////    final result = await Printing.layoutPdf(
////      onLayout: widget.build,
////      name: widget.pdfFileName ?? 'Document',
////      format: format,
////      dynamicLayout: widget.dynamicLayout,
////    );
////
////    if (result && widget.onPrinted != null) {
////      widget.onPrinted!(context);
////    }
//}
