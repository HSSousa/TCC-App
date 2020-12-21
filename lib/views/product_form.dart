import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc3/model/coordinate.dart';
import 'package:tcc3/model/product.dart';
import 'package:tcc3/provider/products_provider.dart';
import 'package:tcc3/repositories/products_repository.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  bool isLoading = false;
  final _form = GlobalKey<FormState>();
  Product product;
  final Map<String, String> _formData = {};

  void _loadForm(Product product) {
    if (product != null) {
      _formData['id'] = product.id;
      _formData['name'] = product.name;
      _formData['arrivaldate'] = product.arrivalDateYear.toString() +
          "," +
          product.arrivalDateMonth.toString() +
          "," +
          product.arrivalDateDay.toString();
      _formData['deliverydate'] = product.deliveryDateYear.toString() +
          "," +
          product.deliveryDateMonth.toString() +
          "," +
          product.deliveryDateDay.toString();
      _formData['color'] = product.color;
      _formData['position'] = product.position.toString();
    }
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    product = ModalRoute.of(context).settings.arguments;
    _loadForm(product);
  }

  Coordinate retornaCoordinate(int position) {
    if (position == 1)
      return Coordinate(x: 450, y: 170, z: 110);
    else if (position == 2)
      return Coordinate(x: 250, y: 170, z: 110);
    else if (position == 3)
      return Coordinate(x: 450, y: 0, z: 110);
    else if (position == 4)
      return Coordinate(x: 250, y: 0, z: 110);
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    var products = Products();
    //var control = doSomeAsyncStuff(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
              color: Colors.green,
              iconSize: 40,
              icon: Icon(Icons.save),
              onPressed: () async {
                final isValid = _form.currentState.validate();
                if (isValid) {
                  _form.currentState.save();
                  String data = _formData['arrivaldate'];
                  String data2 = _formData['deliverydate'];
                  var split = data.split(',');
                  var split2 = data2.split(',');
                  var prd = Product(
                      id: _formData['id'],
                      name: _formData['name'],
                      color: _formData['color'],
                      coordinate:
                          retornaCoordinate(int.parse(_formData['position'])),
                      position: int.parse(_formData['position']),
                      validated:
                          _formData['validated'] == 'true' ? true : false,
                      arrivalDateDay: int.parse(split.elementAt(2)),
                      arrivalDateMonth: int.parse(split.elementAt(1)),
                      arrivalDateYear: int.parse(split.elementAt(0)),
                      deliveryDateDay: int.parse(split2.elementAt(2)),
                      deliveryDateMonth: int.parse(split2.elementAt(1)),
                      deliveryDateYear: int.parse(split2.elementAt(0)));
                  var list = await doSomeAsyncStuff(context);
                  bool existsProduct = false;
                  Set<Product> set = Set.from(list);
                  set.forEach((element) {
                    if (element.id == prd.id) existsProduct = true;
                  });

                  if (!existsProduct) {
                    bool colorexists = false;
                    Set<Product> set = Set.from(list);
                    set.forEach((element) {
                      if (element.color == prd.color) colorexists = true;
                    });
                    if (colorexists) {
                      showDialog(
                          context: (context),
                          builder: (_context) => CupertinoAlertDialog(
                                title: Text("ALERT"),
                                content: Text(
                                    "There is already a product with that color"),
                              ));
                    } else {
                      bool positionexists = false;
                      Set<Product> set = Set.from(list);
                      set.forEach((element) {
                        if (element.position == prd.position)
                          positionexists = true;
                      });
                      if (positionexists) {
                        showDialog(
                            context: (context),
                            builder: (_context) => CupertinoAlertDialog(
                                  title: Text("ALERT"),
                                  content: Text(
                                      "There is already a product with that position"),
                                ));
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        int resp = await ProductsRepository()
                            .createState()
                            .addProduct(prd, context);

                        setState(() {
                          isLoading = false;
                        });
                      }
                      //if (resp == 200) Navigator.of(context).pop();
                    }
                  } else {
                    setState(() {
                      isLoading = true;
                    });

                    var response = await ProductsRepository()
                        .createState()
                        .attProduct(prd, context);
                    setState(() {
                      isLoading = false;
                    });
                    //if (response == 200) Navigator.of(context).pop();
                  }
                } else {
                  showDialog(
                      context: (context),
                      builder: (_context) => CupertinoAlertDialog(
                            title: Text("ALERT"),
                            content: Text("Invalid information"),
                          ));
                }
              }),
        ],
        title: Center(
          child: Text(
            "Product Form",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: _formData['id'],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Invalid ID";
                              }
                              return null;
                            },
                            onSaved: (value) => _formData['id'] = value,
                            decoration: InputDecoration(
                              labelText: "ID: ",
                              labelStyle: TextStyle(fontSize: 40),
                            ),
                          ),
                          TextFormField(
                            initialValue: _formData['name'],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Invalid name";
                              }
                              if (value.trim().length < 3) {
                                return "Very short name";
                              }
                              return null;
                            },
                            onSaved: (value) => _formData['name'] = value,
                            decoration: InputDecoration(
                              labelText: "Name: ",
                              labelStyle: TextStyle(fontSize: 40),
                            ),
                          ),
                          TextFormField(
                            initialValue: _formData['arrivaldate'],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Invalid Date";
                              }
                              if (value.length < 8) {
                                return "Very short value";
                              }
                              return null;
                            },
                            onSaved: (value) =>
                                _formData['arrivaldate'] = value,
                            decoration: InputDecoration(
                              labelText: "Arrival Date (YYYY,MM,DD): ",
                              labelStyle: TextStyle(fontSize: 40),
                            ),
                          ),
                          TextFormField(
                            initialValue: _formData['deliverydate'],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Invalid Date";
                              }
                              if (value.length < 7) {
                                return "Very short value";
                              }
                              return null;
                            },
                            onSaved: (value) =>
                                _formData['deliverydate'] = value,
                            decoration: InputDecoration(
                              labelText: "Delivery Date (YYYY,MM,DD): ",
                              labelStyle: TextStyle(fontSize: 40),
                            ),
                          ),
                          TextFormField(
                            initialValue: _formData['color'],
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  (value != "Vermelho" &&
                                      value != "Azul" &&
                                      value != "Amarelo" &&
                                      value != "Verde")) {
                                return "Invalid Color";
                              }
                              return null;
                            },
                            onSaved: (value) => _formData['color'] = value,
                            decoration: InputDecoration(
                              labelText: "Color: ",
                              labelStyle: TextStyle(fontSize: 40),
                            ),
                          ),
                          TextFormField(
                            initialValue: _formData['position'],
                            validator: (value) {
                              if (value == null || int.parse(value) > 4)
                                return "Invalid Position";
                              return null;
                            },
                            onSaved: (value) => _formData['position'] = value,
                            decoration: InputDecoration(
                              labelText: "Position: ",
                              labelStyle: TextStyle(fontSize: 40),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
