import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kratifireworks/restcalls/apis.dart';
import 'package:kratifireworks/restcalls/postapiresponse.dart';
import 'package:kratifireworks/ui/widgets/progress_indicator_widget.dart';
import 'package:kratifireworks/ui/widgets/test_feild_widget.dart';
import 'package:kratifireworks/util.dart';

class EntryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EntryPageState();
  }
}

class _EntryPageState extends State<EntryPage> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _hindiTextController = TextEditingController();
  TextEditingController _englishTextController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Apis apis = Apis();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() async {
      if (!_focusNode.hasFocus) {
        _hindiTextController.text =
            await apis.convert(_englishTextController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    return Scaffold(
      body: ProgressIndicatorWidget(
        isLoading: _isLoading,
        child: LayoutBuilder(builder: (context, constraints) {
          return Align(
            alignment: Alignment.topCenter,
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (constraints.maxWidth < 700) ? getMobileUi() : getWebUi(),
                      Container(
                        constraints:
                            BoxConstraints(minWidth: 100, maxWidth: 200),
                        width: MediaQuery.of(context).size.width / 2,
                        margin: EdgeInsets.only(top: 15),
                        child: RaisedButton(
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          color: Util.primaryColor,
                          child: Text("Add",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'RobotoMedium',
                                fontSize: 20,
                              )),
                          onPressed: () {
                            validateFields();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  validateFields() {
    (_codeController.text.length != 0 &&
            _englishTextController.text.length != 0 &&
            _hindiTextController.text.length != 0 &&
            _priceController.text.length != 0 &&
            _quantityController.text.length != 0)
        ? onPressAdd()
        : showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Text(
                "No Field should be empty",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontFamily: 'RobotoRegular',
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
    setState(() {
      _isLoading = true;
    });
    Future<OnlyResultResponse> map = apis.getPendingBills(
        _codeController.text,
        _englishTextController.text,
        _hindiTextController.text,
        _priceController.text,
        _quantityController.text);
    map.then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value.status == 1) {
        _codeController.clear();
        _englishTextController.clear();
        _hindiTextController.clear();
        _priceController.clear();
        _quantityController.clear();
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(
              "Item Added Successfully",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontFamily: 'RobotoRegular',
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
      } else if (value.status == 2) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(
              "Item code already exists",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontFamily: 'RobotoRegular',
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
      } else if (value.status == 0) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(
              "Some fields are empty!",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontFamily: 'RobotoRegular',
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
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(
              "Something went wrong! Please try again later",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontFamily: 'RobotoRegular',
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

  /*ProgressDialog progressDialog(BuildContext context) {
    return ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
  }*/

  getMobileUi() {
    return Column(
      children: [
        TextFieldWidget(
            label: "Item code*",
            controller: _codeController,
            hint: "Enter item code here",
            type: TextInputType.text),
        TextFieldWidget(
            label: "Name in Hindi*",
            controller: _hindiTextController,
            hint: "Enter item name in hindi here",
            type: TextInputType.text,
            readOnly: true),
        getEnglishNameTextField(
            "Name in English*",
            "Enter item name in english here",
            _englishTextController,
            TextInputType.text),
        TextFieldWidget(
            label: "Price per unit*",
            controller: _priceController,
            hint: "Enter item price per unit here",
            type: TextInputType.number),
        TextFieldWidget(
            label: "Quantity*",
            controller: _quantityController,
            hint: "Enter Quantity of item",
            type: TextInputType.number),
      ],
    );
  }

  getWebUi() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minWidth: 100, maxWidth: 700),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextFieldWidget(
                    label: "Item code*",
                    controller: _codeController,
                    hint: "Enter item code here",
                    type: TextInputType.text),
              ),
              Expanded(
                flex: 3,
                child: TextFieldWidget(
                    label: "Name in Hindi*",
                    controller: _hindiTextController,
                    hint: "Enter item name in hindi here",
                    type: TextInputType.text,
                    readOnly: true),
              ),
              Expanded(
                flex: 1,
                child: TextFieldWidget(
                    label: "Quantity*",
                    controller: _quantityController,
                    hint: "Enter Quantity of item",
                    type: TextInputType.number),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: getEnglishNameTextField(
                    "Name in English*",
                    "Enter item name in english here",
                    _englishTextController,
                    TextInputType.text),
              ),
              Expanded(
                flex: 1,
                child: TextFieldWidget(
                    label: "Price per unit*",
                    controller: _priceController,
                    hint: "Enter item price per unit here",
                    type: TextInputType.number,
                    decimal: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getEnglishNameTextField(String label, String hint,
      TextEditingController controller, TextInputType type) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            focusNode: _focusNode,
            style: TextStyle(fontFamily: 'RobotoRegular'),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: hint,
                isDense: true,
                labelStyle: TextStyle(fontFamily: 'RobotoRegular'),
                hintStyle: TextStyle(
                    fontFamily: 'RobotoRegular',
                    color: Color.fromRGBO(124, 139, 154, 1)),
                label: Text(
                  label,
                )),
            controller: controller,
            keyboardType: type,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

//  onChangedHindiTextField() {
//    _hindiTextController.text = someString;
//    controller.selection = TextSelection.fromPosition(
//        TextPosition(offset: controller.text.length));
//  }
}
