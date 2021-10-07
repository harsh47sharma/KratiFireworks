import 'package:flutter/material.dart';
import 'package:kratifireworks/ui/main_page.dart';
import 'package:kratifireworks/util.dart';
import 'package:printing/printing.dart';
import 'package:responsive_framework/responsive_framework.dart';

main() async {
  Util.robotoLight = await PdfGoogleFonts.hindLight();
  Util.robotoRegular = await PdfGoogleFonts.hindRegular();
  Util.robotoMedium = await PdfGoogleFonts.hindMedium();
  Util.robotoBold = await PdfGoogleFonts.hindBold();
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
        builder: (context, widget) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, widget!),
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                ResponsiveBreakpoint.autoScale(450,
                    name: MOBILE, scaleFactor: 0.7),
                ResponsiveBreakpoint.resize(700, name: TABLET),
                ResponsiveBreakpoint.resize(1000, name: TABLET),
                ResponsiveBreakpoint.resize(2460, name: "4K"),
              ],
            ),
        theme: ThemeData(
            primaryColor: Util.primaryColor,
            textTheme: Util.appTextTheme(context),
            appBarTheme: AppBarTheme(
              toolbarTextStyle: Util.appTextTheme(context).bodyText2,
              titleTextStyle: Util.appTextTheme(context).headline6,
            ),
            iconTheme: IconThemeData(color: Util.primaryColor),
            tabBarTheme: TabBarTheme(
              labelColor: Colors.black,
              unselectedLabelColor: Color.fromRGBO(124, 139, 154, 1),
              labelStyle: TextStyle(fontSize: 20, fontFamily: 'RobotoMedium'),
              unselectedLabelStyle:
                  TextStyle(fontSize: 20, fontFamily: 'RobotoRegular'),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData()),
        home: MainPage());
//        home: app.MyApp());
  }
}
