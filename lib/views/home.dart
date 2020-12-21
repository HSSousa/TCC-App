import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc3/components/infobox.dart';
import 'package:tcc3/model/product.dart';
import 'package:tcc3/provider/products_provider.dart';
import 'package:tcc3/repositories/products_repository.dart';
import 'package:tcc3/routes/app_routes.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List<Product> list;
Future<List<Product>> doSomeAsyncStuff(BuildContext context) async {
  Future<List<Product>> productController;
  try {
    productController = ProductsRepository().createState().findAll();
    list = await productController;
    Products().atualizar(list);
    return productController;
  } on DioError catch (_) {
    showDialog(
        context: (context),
        builder: (_context) => CupertinoAlertDialog(
              title: Text("ALERT"),
              content: Text("Could not connect to the system" + _.message),
            ));
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Future<List<Product>> control = doSomeAsyncStuff(context);

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            tooltip: "Adicionar um produto",
            color: Colors.green,
            iconSize: 50,
            icon: Icon(Icons.add),
            onPressed: () async {
              try {
                control = doSomeAsyncStuff(context);
              } on DioError catch (_) {
                showDialog(
                    context: (context),
                    builder: (_context) => CupertinoAlertDialog(
                          title: Text("ALERT"),
                          content: Text(
                              "Could not connect to the system" + _.message),
                        ));
              }
              list = await control;
              //Products().atualizar(list);
              if (list.length < 4)
                Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
              else {
                showDialog(
                    context: (context),
                    builder: (_) => CupertinoAlertDialog(
                          title: Text("ALERT"),
                          content: Text("Maximum product limit"),
                        ));
              }
            },
          ),
          IconButton(
            tooltip: "",
            color: Colors.yellow,
            iconSize: 50,
            icon: Icon(Icons.refresh),
            onPressed: () async {
              control = doSomeAsyncStuff(context);
              list = await control;
              Products().atualizar(list);
              if (list.length <= 4) {
                setState(() {});
              } else {
                showDialog(
                    context: (context),
                    builder: (_) => CupertinoAlertDialog(
                          title: Text("ALERT"),
                          content: Text("Maximum product limit"),
                        ));
              }
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          "Painel",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: FutureBuilder<List<Product>>(
          future: control,
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Text('Error: ${snapshot.error}'),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (cxt, i) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InfoBox(snapshot.data[i]),
                      ));
            }
          }),
    );
  }
}
