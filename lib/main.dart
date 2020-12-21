import 'package:flutter/material.dart';
import 'package:tcc3/routes/app_routes.dart';
import 'package:tcc3/views/home.dart';
import 'package:tcc3/views/product_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TCC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        AppRoutes.HOME: (_) => Home(),
        AppRoutes.PRODUCT_FORM: (_) => ProductForm(),
      },
    );
  }
}
