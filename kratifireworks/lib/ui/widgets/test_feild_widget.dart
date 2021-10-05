import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool decimal;
  final TextInputType type;

  TextFieldWidget(
      {required this.label,
      required this.hint,
      required this.controller,
      this.decimal = false,
      required this.type});

  @override
  State<StatefulWidget> createState() {
    return _TextFieldWidgetState();
  }
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            style: TextStyle(fontFamily: 'RobotoRegular'),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: widget.hint,
                isDense: true,
                labelStyle: TextStyle(fontFamily: 'RobotoRegular'),
                hintStyle: TextStyle(
                    fontFamily: 'RobotoRegular',
                    color: Color.fromRGBO(124, 139, 154, 1)),
                label: Text(
                  widget.label,
                )),
            controller: widget.controller,
            keyboardType: widget.type,
            inputFormatters: (widget.type == TextInputType.number)
                ? (!widget.decimal)
                    ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]{1,6}'))]
                    : [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*"))
                      ]
                : null,
          )
        ],
      ),
    );
  }
}
