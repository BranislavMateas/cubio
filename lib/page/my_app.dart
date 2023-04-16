import 'package:cubio/page/constants.dart';
import 'package:cubio/page/routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubio',
      theme: ThemeData(
        primaryColor: primaryAppColor,
        backgroundColor: primaryAppColor,
        scaffoldBackgroundColor: primaryAppColor,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: appBarTitleColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          color: primaryAppColor,
        ),
      ),
      initialRoute: '/',
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
