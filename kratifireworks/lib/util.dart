import 'package:flutter/material.dart';

class Util {
  static var primaryColor = Colors.deepPurpleAccent;
  static var robotoLight;
  static var robotoRegular;
  static var robotoMedium;
  static var robotoBold;

  static TextTheme appTextTheme(context) {
    return Theme.of(context).textTheme.apply(
          bodyColor: Color.fromRGBO(29, 38, 46, 1),
          displayColor: Colors.blue,
        );
  }

  static dialog(context, content, button,
      {title, var method, dismissible = true, popPage = false}) {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (_) => AlertDialog(
        title: (title != null)
            ? Text(
                title,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'RobotoMedium',
                    color: Colors.black),
              )
            : null,
        content: Text(
          content,
          style: TextStyle(
              fontSize: 12,
              fontFamily: 'RobotoRegular',
              color: Color.fromRGBO(124, 139, 154, 1)),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(button,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'RobotoRegular',
                  color: Colors.blueAccent,
                )),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              if (popPage) {
                Navigator.pop(context);
              }
              if (method != null) {
                method();
              }
            },
          ),
        ],
      ),
    );
  }
}
