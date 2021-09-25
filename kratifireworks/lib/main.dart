import 'package:flutter/material.dart';
import 'package:kratifireworks/entrypage.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp((MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My app',
        debugShowCheckedModeBanner: false,
        //home: MyHistoryListPage(),
        home: EntryPage()
      /*initialRoute: '/',
      routes: {
        '/': (context) => FrontPage(),
        '/internetPage': (context) => NoInternetPage(),
      },*/
    );
  }
}
