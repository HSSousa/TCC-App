import 'dart:io';
import 'dart:convert' as convert;
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc3/model/BoolResponse.dart';
import 'package:tcc3/model/StringResponse.dart';
import 'package:tcc3/model/product.dart';
import 'package:http/http.dart' as http;

class ProductsRepository extends StatefulWidget {
  @override
  _ProductsRepositoryState createState() => _ProductsRepositoryState();
}

class _ProductsRepositoryState extends State<ProductsRepository> {
  Response<dynamic> response;

  List<Product> list;
  List<BoolResponse> list2;
  Future<List<Product>> doSomeAsyncStuff(BuildContext context) async {
    Future<List<Product>> productController;
    try {
      productController = ProductsRepository().createState().findAll();
      list = await productController;
      return productController;
    } on DioError catch (_) {
      showDialog(
          context: (context),
          builder: (_context) => CupertinoAlertDialog(
                title: Text("ALERT"),
                content: Text("Could not connect to the system" + _.message),
              ));
    }
    return null;
  }

  Future<List<Product>> findAll() async {
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    dio.options.connectTimeout = 1000000000000;
    dio.options.baseUrl = "http://192.168.0.210:5000/";
    response = await dio.get("product/getAll");

    var listProducts = (response.data as List).map((item) {
      return Product.fromJson(item);
    }).toList();
    return listProducts;
  }

  Future<List<Product>> getProductByID(Product product) async {
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    dio.options.connectTimeout = 1000000000000;
    dio.options.baseUrl = "http://192.168.0.210:5000/";
    response = await dio.get("/product/${product.id}");
    var listProducts = (response.data as List).map((item) {
      return Product.fromJson(item);
    }).toList();
    return listProducts;
  }

  Future<void> validar(Product product) async {
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    dio.options.connectTimeout = 1000000000000;
    dio.options.baseUrl = "http://192.168.0.210:5000/";
    try {
      await dio.post("product/${product.id}/pegar");
      return;
    } on Exception {
      showDialog(
          context: (context),
          builder: (_context) => CupertinoAlertDialog(
                title: Text("ALERT"),
                content: Text("Could not connect to the system"),
              ));
      return null;
    }
  }

  Future<int> addProduct(Product product, BuildContext context) async {
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    dio.options.connectTimeout = 1000000000000;
    dio.options.baseUrl = "http://192.168.0.210:5000/";
    try {
      var response =
          await dio.post("product/${product.id}/add", data: product.toJson());
      if (response.statusCode == 200) {
        showDialog(
            context: (context),
            builder: (_context) => CupertinoAlertDialog(
                  title: Text("ALERT"),
                  content: Text("Product added"),
                ));
      } else {
        showDialog(
            context: (context),
            builder: (_context) => CupertinoAlertDialog(
                  title: Text("ALERT"),
                  content: Text("Product not added"),
                ));
      }
      return response.statusCode;
    } on Exception {
      showDialog(
          context: (context),
          builder: (_context) => CupertinoAlertDialog(
                title: Text("ALERT"),
                content: Text("Could not connect to the system"),
              ));
      return null;
    }
  }

  Future<void> home() async {
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    dio.options.connectTimeout = 1000000000000;
    dio.options.baseUrl = "http://192.168.0.210:5000/";
    try {
      await dio.post("product/home");
      return;
    } on Exception {
      showDialog(
          context: (context),
          builder: (_context) => CupertinoAlertDialog(
                title: Text("ALERT"),
                content: Text("Could not connect to the system"),
              ));
      return null;
    }
  }

  Future<int> attProduct(Product product, BuildContext context) async {
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    dio.options.connectTimeout = 1000000000000;
    dio.options.baseUrl = "http://192.168.0.210:5000/";
    try {
      /*var productController = ProductsRepository().createState().findAll();
      list = await productController;
      Set<Product> set = Set.from(list);
      set.forEach((element) async {
        if (element.id == product.id) {
          response2 = await dio.put("product/", data: product.toJson());
        }
      });*/
      // ignore: unrelated_type_equality_checks
      var response2 = await dio.put("product/", data: product.toJson());
      if (response2.statusCode == 200) {
        showDialog(
            context: (context),
            builder: (_context) => CupertinoAlertDialog(
                  title: Text("ALERT"),
                  content: Text("Product updated"),
                ));
      } else {
        showDialog(
            context: (context),
            builder: (_context) => CupertinoAlertDialog(
                  title: Text("ALERT"),
                  content: Text("Product not updated"),
                ));
      }
      return response2.statusCode;
    } on Exception {
      showDialog(
          context: (context),
          builder: (_context) => CupertinoAlertDialog(
                title: Text("ALERT"),
                content: Text("Could not connect to the system"),
              ));
      return null;
    }
  }

  Future<List<BoolResponse>> doSomeAsyncStuff2(
      Product product, BuildContext context) async {
    Future<List<BoolResponse>> productController;
    try {
      productController =
          ProductsRepository().createState().removeProduct(product);
      return productController;
    } on DioError catch (_) {
      showDialog(
          context: (context),
          builder: (_context) => CupertinoAlertDialog(
                title: Text("ALERT 2"),
                content: Text("Could not connect to the system" + _.message),
              ));
    }
    return null;
  }

  Future<List<BoolResponse>> removeProduct(Product product) async {
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    dio.options.connectTimeout = 500000000000;
    dio.options.baseUrl = "http://192.168.0.210:5000/";
    response = await dio.delete("product/${product.id}");
    var listProducts = (response.data as List).map((item) {
      return BoolResponse.fromJson(item);
    }).toList();
    return listProducts;
  }

  Future<void> validou(Product product) async {
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    dio.options.connectTimeout = 500000000000;
    dio.options.baseUrl = "http://192.168.0.210:5000/";
    response = await dio.post("product/validou", data: product.toJson());
  }

  Future<void> setaflag() async {
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
    dio.options.connectTimeout = 500000000000;
    dio.options.baseUrl = "http://192.168.0.210:5000/";
    response = await dio.post("product/setaflag");
  }

  @override
  Widget build(BuildContext context) {
    return ProductsRepository();
  }
}
