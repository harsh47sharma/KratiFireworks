import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kratifireworks/restcalls/apis.dart';
import 'package:kratifireworks/restcalls/postapiresponse.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EntryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EntryPageState();
  }
}

class _EntryPageState extends State<EntryPage> {
  var cardViewHeight = 0.0;
  var cardRoundBorder = 30.0;
  TextEditingController _codeController = TextEditingController();
  TextEditingController _hindiTextController = TextEditingController();
  TextEditingController _englishTextController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  Apis apis = Apis();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                children: [
                  Text("Krati Fireworks",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      )),
                  SizedBox(height: 30),
                  Text("Add Crackers to database",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      )),
                  SizedBox(height: 10),
                  textFieldWithText("Item code*", _codeController, "Enter item code here"),
                  SizedBox(height: 10),
                  textFieldWithText(
                      "Name in Hindi*", _hindiTextController, "Enter item name in hindi here"),
                  SizedBox(height: 10),
                  textFieldWithText(
                      "Name in English*", _englishTextController, "Enter item name in english here"),
                  SizedBox(height: 10),
                  textFieldWithNumber("Price per unit*", _priceController, "Enter item price per unit here"),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 34.0),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.0)),
                      color: Colors.greenAccent,
                      child: Text("Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                          )),
                      onPressed: () {
                        validateFields();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  validateFields() {
    (_codeController.text.length != 0 &&
            _englishTextController.text.length != 0 &&
            _hindiTextController.text.length != 0 &&
            _priceController.text.length != 0)
        ? onPressAdd()
        : showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Text(
                "No Field should be empty",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                ),
              ],
            ),
          );
  }

  onPressAdd() {
    progressDialog(context).show();
    Future<OnlyResultResponse> map = apis.getPendingBills(
        _codeController.text,
        _englishTextController.text,
        _hindiTextController.text,
        _priceController.text);

    map.then((value) {
      progressDialog(context).hide();
      if (value.status == 1) {
        _codeController.clear();
        _englishTextController.clear();
        _hindiTextController.clear();
        _priceController.clear();
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(
              "Item Added Successfully",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          ),
        );
      }
      else if(value.status == 2){
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(
              "Item code already exists",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          ),
        );
      }
      else if(value.status == 0){
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(
              "Some fields are empty!",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          ),
        );
      }
      else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(
              "Something went wrong! Please try again later",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12)),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          ),
        );
      }
    });
  }

  textFieldWithText(String label, controller, String hint) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600
          ), textAlign: TextAlign.start),
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

  textFieldWithNumber(String label, controller, String hint) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600
          ), textAlign: TextAlign.start),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
                hintText: hint,
                isDense: true,
            ),
            keyboardType: TextInputType.number,
            controller: controller,
          )
        ],
      ),
    );
  }

  ProgressDialog progressDialog(BuildContext context){
    return ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
  }
}
