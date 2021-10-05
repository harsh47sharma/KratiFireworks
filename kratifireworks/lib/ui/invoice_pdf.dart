/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:kratifireworks/models/product_details_model.dart';
import 'package:kratifireworks/util.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<Uint8List> generateInvoice(PdfPageFormat pageFormat) async {
  final lorem = pw.LoremText();

  final invoice = Invoice(
    invoiceNumber: '982347',
    customerName: 'Abraham Swearegin',
    customerAddress: '54 rue de Rivoli\n75001 Paris, France',
    paymentInfo:
        '4509 Wiseman Street\nKnoxville, Tennessee(TN), 37929\n865-372-0425',
    tax: .15,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );

  return await invoice.buildPdf(pageFormat);
}

class Invoice {
  Invoice({
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.tax,
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
  });

  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

//  String? _logo;
//
//  String? _bgShape;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
//          pw.SizedBox(height: 20),
//          _contentHeader(context),
//          getTable(1220),
          _contentTable(context),
          getTotalTableRow(),
//          _contentFooter(context),
//          pw.SizedBox(height: 20),
//          _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Container(
      margin: pw.EdgeInsets.only(bottom: 15),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              children: [
                pw.Text(
                  "KRATI FIRE WORKS",
                  style: pw.TextStyle(
                      fontSize: 35,
                      font: Util.robotoMedium,
                      color: PdfColor.fromHex("#FF0000")),
                ),
                pw.Container(
                  margin: pw.EdgeInsets.only(top: 10, bottom: 30),
                  child: pw.Text(
                    "158, Palhar Nagar Airport Road Indore(M.P.), Mob : 9827386820, 99273600012",
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColor.fromHex("#000000"),
                      font: Util.robotoLight,
                    ),
                  ),
                ),
                pw.Text(
                  "Estimate",
                  style: pw.TextStyle(
                      fontSize: 25,
                      font: Util.robotoMedium,
                      color: PdfColor.fromHex("#FF0000")),
                ),
                getCustomerInfo()
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Container(
            margin:
                pw.EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
            child: pw.Text(
              "Krati Fire Works",
              style: pw.TextStyle(
                font: Util.robotoMedium,
                fontSize: 24,
              ),
            ),
          ),
        ),
        pw.Container(
          alignment: pw.Alignment.centerLeft,
          margin: pw.EdgeInsets.symmetric(horizontal: 10),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  getRichText("Yes Bank A/C No.: ", "047863300003016"),
                  pw.Container(
                    margin: pw.EdgeInsets.symmetric(vertical: 5),
                    child: getRichText("IFC Code : ", "YESB0000478"),
                  ),
                ],
              ),
              pw.Text("Composition Dealer : GSTIN - 23AJDPPO300L1ZO",
                  style: pw.TextStyle(
                      fontSize: 14,
                      font: Util.robotoMedium,
                      color: PdfColor.fromHex("#000000")))
            ],
          ),
        )
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.SizedBox(), //pw.SvgImage(svg: _bgShape!),
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 20),
            height: 70,
            child: pw.FittedBox(
              child: pw.Text(
                'Total: ${_formatCurrency(100)}',
                style: pw.TextStyle(
                  color: baseColor,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 10, right: 10),
                height: 70,
                child: pw.Text(
                  'Invoice to:',
                  style: pw.TextStyle(
                    color: _darkColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 70,
                  child: pw.RichText(
                      text: pw.TextSpan(
                          text: '$customerName\n',
                          style: pw.TextStyle(
                            color: _darkColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                        const pw.TextSpan(
                          text: '\n',
                          style: pw.TextStyle(
                            fontSize: 5,
                          ),
                        ),
                        pw.TextSpan(
                          text: customerAddress,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                          ),
                        ),
                      ])),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Thank you for your business',
                style: pw.TextStyle(
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                child: pw.Text(
                  'Payment Info:',
                  style: pw.TextStyle(
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                paymentInfo,
                style: const pw.TextStyle(
                  fontSize: 8,
                  lineSpacing: 5,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text(_formatCurrency(100)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tax:'),
                    pw.Text('${(tax * 100).toStringAsFixed(1)}%'),
                  ],
                ),
                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(_formatCurrency(100)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(color: accentColor)),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                pw.LoremText().paragraph(40),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'S.No',
      'Code',
      'Particulars',
      'Quantity',
      'Rate',
      'Amount'
    ];

    return pw.Table.fromTextArray(
      border: pw.TableBorder.all(color: PdfColors.blueGrey, width: 0.5),
      cellAlignment: pw.Alignment.centerLeft,
      cellPadding: pw.EdgeInsets.all(10),
      headerPadding: pw.EdgeInsets.all(10),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerLeft,
      },
      headerStyle: pw.TextStyle(
        fontSize: 14,
        font: Util.robotoBold,
      ),
      cellStyle: pw.TextStyle(
        fontSize: 14,
        font: Util.robotoRegular,
      ),
      rowDecoration: pw.BoxDecoration(
          border: pw.TableBorder.all(color: PdfColors.blueGrey, width: 0.5)),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      columnWidths: {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(9),
        3: pw.FlexColumnWidth(2),
        4: pw.FlexColumnWidth(2),
        5: pw.FlexColumnWidth(3),
      },
      data: List<List<String>>.generate(
        ProductDetailsModel.orderDetails.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => getIndex(row, col),
        ),
      ),
    );
  }

  getCustomerInfo() {
    return pw.Container(
      margin: pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              getRichText("Customer Name: ", ProductDetailsModel.customerName),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(vertical: 5),
                child: getRichText("Contact: ", ProductDetailsModel.contactNo),
              ),
              getRichText("GST No.: ", ProductDetailsModel.gstNumber),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              getRichText(
                  "Estimate #: ", ProductDetailsModel.billNo.toString()),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(vertical: 5),
                child: getRichText(
                    "Date: ",
                    ProductDetailsModel.billingDate
                        .toString()
                        .substring(0, 19)),
              )
            ],
          )
        ],
      ),
    );
  }
}

String _formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

String getIndex(int row, int col) {
  switch (col) {
    case 0:
      return (++row).toString();
    case 1:
      return ProductDetailsModel.orderDetails[row].code;
    case 2:
      return ProductDetailsModel.orderDetails[row].title;
    case 3:
      return ProductDetailsModel.orderDetails[row].quantity.toString();
    case 4:
      return ProductDetailsModel.orderDetails[row].itemPrice.toString();
    case 5:
      return ProductDetailsModel.orderDetails[row].totalPrice.toString();
  }
  return '';
}

getRichText(text1, text2) {
  return pw.RichText(
    text: pw.TextSpan(
      children: [
        pw.TextSpan(
            text: text1,
            style: pw.TextStyle(
                fontSize: 14,
                font: Util.robotoMedium,
                color: PdfColor.fromHex("#000000"))),
        pw.TextSpan(
            text: text2,
            style: pw.TextStyle(
                fontSize: 14,
                font: Util.robotoRegular,
                color: PdfColor.fromHex("#000000")))
      ],
    ),
  );
}
/*
getPdfUi(context, billNumber, date, total) {
  return pw.Container(
      width: (MediaQuery.of(context).size.width / 10) * 9,
      child: pw.Container(
        margin: pw.EdgeInsets.symmetric(vertical: 10),
        child: pw.Column(
          children: [
            pw.Text(
              "KRATI FIRE WORKS",
              style: pw.TextStyle(
                  fontSize: 35,
                  font: Util.robotoMedium,
                  color: PdfColor.fromHex("#FF0000")),
            ),
            pw.Container(
              margin: pw.EdgeInsets.only(top: 10, bottom: 30),
              child: pw.Text(
                "158, Palhar Nagar Airport Road Indore(M.P.), Mob : 9827386820, 99273600012",
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColor.fromHex("#000000"),
                  font: Util.robotoLight,
                ),
              ),
            ),
            pw.Text(
              "Estimate",
              style: pw.TextStyle(
                  fontSize: 25,
                  font: Util.robotoMedium,
                  color: PdfColor.fromHex("#FF0000")),
            ),
            pw.Container(
              margin: pw.EdgeInsets.only(top: 10, bottom: 20),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      getRichText(
                          "Customer Name: ", ProductDetailsModel.customerName),
                      pw.Container(
                        margin: pw.EdgeInsets.symmetric(vertical: 5),
                        child: getRichText(
                            "Contact: ", ProductDetailsModel.contactNo),
                      ),
                      getRichText("GST No.: ", ProductDetailsModel.gstNumber),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      getRichText("Estimate #: ", billNumber.toString()),
                      pw.Container(
                        margin: pw.EdgeInsets.symmetric(vertical: 5),
                        child: getRichText("Date: ", date),
                      )
                    ],
                  )
                ],
              ),
            ),
            getTable(context, total),
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Container(
                margin: pw.EdgeInsets.only(
                    top: 20, bottom: 10, left: 10, right: 10),
                child: pw.Text(
                  "Krati Fire Works",
                  style: pw.TextStyle(
                    font: Util.robotoMedium,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            pw.Container(
              alignment: pw.Alignment.centerLeft,
              margin: pw.EdgeInsets.symmetric(horizontal: 10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  getRichText("Yes Bank A/C No.: ", "047863300003016"),
                  pw.Container(
                    margin: pw.EdgeInsets.symmetric(vertical: 5),
                    child: getRichText("IFC Code : ", "YESB0000478"),
                  ),
                  pw.Text("Composition Dealer : GSTIN - 23AJDPPO300L1ZO",
                      style: pw.TextStyle(
                          fontSize: 14,
                          font: Util.robotoMedium,
                          color: PdfColor.fromHex("#000000")))
                ],
              ),
            )
          ],
        ),
      ));
}

getRichText(text1, text2) {
  return pw.RichText(
    text: pw.TextSpan(
      children: [
        pw.TextSpan(
            text: text1,
            style: pw.TextStyle(
                fontSize: 14,
                font: Util.robotoMedium,
                color: PdfColor.fromHex("#000000"))),
        pw.TextSpan(
            text: text2,
            style: pw.TextStyle(
                fontSize: 14,
                font: Util.robotoRegular,
                color: PdfColor.fromHex("#000000")))
      ],
    ),
  );
}

getTable(context, total) {
  return pw.Column(
    children: [
      pw.Table(
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
        columnWidths: {
          0: pw.FlexColumnWidth(2),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(9),
          3: pw.FlexColumnWidth(2),
          4: pw.FlexColumnWidth(2),
          5: pw.FlexColumnWidth(3),
        },
        border: pw.TableBorder.all(
            color: PdfColor.fromInt(8162202),
            style: pw.BorderStyle.solid,
            width: 0.01),
        children: [
          pw.TableRow(children: [
            getTableCell("S.No", bold: true),
            getTableCell("Code", bold: true),
            getTableCell("Particulars", bold: true),
            getTableCell("Quantity", bold: true),
            getTableCell("Rate", bold: true),
            getTableCell("Amount", bold: true),
          ]),
          for (var item in ProductDetailsModel.orderDetails)
            pw.TableRow(
              children: [
                getTableCell(
                    ProductDetailsModel.orderDetails.indexOf(item).toString(),
                    context),
                getTableCell(item.code),
                getTableCell(item.title),
                getTableCell(item.quantity.toString()),
                getTableCell(item.itemPrice.toString()),
                getTableCell(item.totalPrice.toString()),
              ],
            ),
        ],
      ),
      pw.Table(
        columnWidths: {
          0: pw.FlexColumnWidth(17),
          1: pw.FlexColumnWidth(3),
        },

        border: pw.TableBorder.all(
            color: PdfColor.fromInt(8162202),
            width: 0.01
        ),
        children: [
          pw.TableRow(
            children: [
              pw.Container(
                  padding: pw.EdgeInsets.symmetric(
                      horizontal: (MediaQuery.of(context).size.width > 844) ? 10 : 5,
                      vertical: 10),
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text("Total:",
                      style: pw.TextStyle(
                          fontSize: 16.0, font: Util.robotoMedium))),
              pw.Container(
                  padding: pw.EdgeInsets.symmetric(
                      horizontal: (MediaQuery.of(context).size.width > 844) ? 10 : 5,
                      vertical: 10),
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(total.toString(),
                      style: pw.TextStyle(
                          fontSize: 16.0, font: Util.robotoMedium))),
//              getTableCell("Total:", bold: true, size: 16.0),
//              getTableCell(total.toString(), bold: true, size: 16.0),
            ],
          )
        ],
      )
    ],
  );
}

getTableCell(String title, {bool bold = false, size = 14.0}) {
  return pw.Container(
      padding: pw.EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width > 844) ? 10 : 5,
          vertical: 10),
      alignment: pw.Alignment.centerLeft,
      child: pw.Text(title,
          style: pw.TextStyle(
              fontSize: size, font: bold ? Util.robotoBold : Util.robotoRegular)));
}
*/

getTable(total) {
  return pw.Column(
    children: [
      pw.Table(
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
        columnWidths: {
          0: pw.FlexColumnWidth(2),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(9),
          3: pw.FlexColumnWidth(2),
          4: pw.FlexColumnWidth(2),
          5: pw.FlexColumnWidth(3),
        },
        border: pw.TableBorder.all(
            color: PdfColor.fromInt(8162202),
            style: pw.BorderStyle.solid,
            width: 0.01),
        children: [
          pw.TableRow(children: [
            getTableCell("S.No", bold: true),
            getTableCell("Code", bold: true),
            getTableCell("Particulars", bold: true),
            getTableCell("Quantity", bold: true),
            getTableCell("Rate", bold: true),
            getTableCell("Amount", bold: true),
          ]),
          for (var item in ProductDetailsModel.orderDetails)
            pw.TableRow(
              children: [
                getTableCell(
                    ProductDetailsModel.orderDetails.indexOf(item).toString()),
                getTableCell(item.code),
                getTableCell(item.title),
                getTableCell(item.quantity.toString()),
                getTableCell(item.itemPrice.toString()),
                getTableCell(item.totalPrice.toString()),
              ],
            ),
        ],
      ),
      pw.Table(
        columnWidths: {
          0: pw.FlexColumnWidth(17),
          1: pw.FlexColumnWidth(3),
        },
        border:
            pw.TableBorder.all(color: PdfColor.fromInt(8162202), width: 0.01),
        children: [
          pw.TableRow(
            children: [
              pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text("Total:",
                      style: pw.TextStyle(
                          fontSize: 16.0, font: Util.robotoMedium))),
              pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(total.toString(),
                      style: pw.TextStyle(
                          fontSize: 16.0, font: Util.robotoMedium))),
//              getTableCell("Total:", bold: true, size: 16.0),
//              getTableCell(total.toString(), bold: true, size: 16.0),
            ],
          )
        ],
      )
    ],
  );
}

getTotalTableRow() {
  return pw.Table(
    columnWidths: {
      0: pw.FlexColumnWidth(17),
      1: pw.FlexColumnWidth(3),
    },
    border: pw.TableBorder.all(color: PdfColors.blueGrey, width: 0.5),
    children: [
      pw.TableRow(
        children: [
          pw.Container(
              padding: pw.EdgeInsets.all(10),
              alignment: pw.Alignment.centerLeft,
              child: pw.Text("Total:",
                  style:
                      pw.TextStyle(fontSize: 16.0, font: Util.robotoMedium))),
          pw.Container(
              padding: pw.EdgeInsets.all(10),
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(ProductDetailsModel.billTotal.toString(),
                  style:
                      pw.TextStyle(fontSize: 16.0, font: Util.robotoMedium))),
//              getTableCell("Total:", bold: true, size: 16.0),
//              getTableCell(total.toString(), bold: true, size: 16.0),
        ],
      )
    ],
  );
}

getTableCell(String title, {bool bold = false, size = 10.0}) {
  return pw.Container(
      padding: pw.EdgeInsets.all(10),
      alignment: pw.Alignment.centerLeft,
      child: pw.Text(title,
          style: pw.TextStyle(
              fontSize: size,
              font: bold ? Util.robotoBold : Util.robotoRegular)));
}
