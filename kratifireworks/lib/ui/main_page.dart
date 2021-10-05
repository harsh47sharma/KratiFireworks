import 'package:flutter/material.dart';
import 'package:kratifireworks/entrypage.dart';
import 'package:kratifireworks/ui/generate_invoice.dart';
import 'package:kratifireworks/util.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(239, 237, 231, 0),
        appBar: AppBar(
          elevation: 1.0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          centerTitle: true,
          title: Text("Krati Fireworks",
              style: TextStyle(fontSize: 30, fontFamily: 'RobotoMedium')),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 50,
              child: TabBar(
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 10)),
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Add Cracker"
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Generate Invoice"
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: TabBarView(
          children: [
            EntryPage(),
            GenerateInvoice(),
          ],
        ),
      ),
    );
  }
}
