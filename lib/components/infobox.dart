import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tcc3/model/product.dart';

import 'package:tcc3/repositories/products_repository.dart';
import 'package:tcc3/routes/app_routes.dart';

class InfoBox extends StatefulWidget {
  final Product p;

  const InfoBox(this.p);

  @override
  _InfoBoxState createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  Color corDoProduto(String cor) {
    if (cor == "Vermelho")
      return Colors.red[100];
    else if (cor == "Verde")
      return Colors.green[100];
    else if (cor == "Amarelo")
      return Colors.yellow[100];
    else if (cor == "Azul")
      return Colors.blue[100];
    else
      return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(7.0),
            width: 500,
            height: 300,
            color: widget.p.validated == true ? Colors.green : Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text(
                      'ID: ',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.p.id,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Nome: ',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.p.name,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Chegada: ',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.p.arrivalDateDay.toString() +
                          "/" +
                          widget.p.arrivalDateMonth.toString() +
                          "/" +
                          widget.p.arrivalDateYear.toString() +
                          " " /*+
                          p.arrival_date.hour.toString() +
                          ":" +
                          p.arrival_date.minute.toString()*/
                      ,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Entrega: ',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.p.deliveryDateDay.toString() +
                          "/" +
                          widget.p.deliveryDateMonth.toString() +
                          "/" +
                          widget.p.deliveryDateYear.toString() +
                          " " /*+
                          p.delivery_date.hour.toString() +
                          ":" +
                          p.delivery_date.minute.toString()*/
                      ,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            color: Colors.grey[300],
            width: 200,
            height: 300,
            child: Center(
              child: Text(
                widget.p.position.toString(),
                style: TextStyle(
                  fontSize: 100,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 100,
          height: 300,
          color: corDoProduto(super.widget.p.color),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                padding: EdgeInsets.all(20),
                tooltip: "Editar",
                icon: Icon(Icons.mode_edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.PRODUCT_FORM, arguments: widget.p);
                },
                color: Colors.orange,
                iconSize: 40,
              ),
              IconButton(
                tooltip: "Deletar",
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                      context: (context),
                      builder: (_) => CupertinoAlertDialog(
                            title: Text("WARNING"),
                            content: Text("Be sure to delete?"),
                            actions: [
                              RaisedButton(
                                color: Colors.redAccent,
                                child: Text("Yes"),
                                onPressed: () async {
                                  var response = ProductsRepository()
                                      .createState()
                                      .doSomeAsyncStuff2(
                                          super.widget.p, context);
                                  var deletado = await response;
                                  Navigator.of(context).pop();
                                  if (deletado[0].response) {
                                    showDialog(
                                        context: (context),
                                        builder: (_context) =>
                                            CupertinoAlertDialog(
                                              title: Text("ALERT"),
                                              content: Text(
                                                  "Product ${super.widget.p.id} was successfully removed"),
                                            ));
                                  } else {
                                    showDialog(
                                        context: (context),
                                        builder: (_context) =>
                                            CupertinoAlertDialog(
                                              title: Text("ALERT"),
                                              content: Text(
                                                  "Product ${super.widget.p.id} has not been removed"),
                                            ));
                                  }
                                  setState(() {});
                                },
                              ),
                              RaisedButton(
                                color: Colors.green,
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                },
                color: Colors.red,
                iconSize: 40,
              ),
              IconButton(
                tooltip: "Procurar",
                icon: Icon(Icons.search),
                onPressed: () async {
                  bool validade2 = false;
                  ProductsRepository().createState().validar(super.widget.p);
                  if (super.widget.p.position == 1) {
                    await Future.delayed(const Duration(seconds: 19));
                    await ProductsRepository().createState().setaflag();
                    await Future.delayed(const Duration(seconds: 4));
                    var procura2 = await ProductsRepository()
                        .createState()
                        .getProductByID(super.widget.p);
                    validade2 = procura2[0].validated;
                  } else if (super.widget.p.position == 2) {
                    await Future.delayed(const Duration(seconds: 14));
                    await ProductsRepository().createState().setaflag();
                    await Future.delayed(const Duration(seconds: 4));
                    var procura2 = await ProductsRepository()
                        .createState()
                        .getProductByID(super.widget.p);
                    validade2 = procura2[0].validated;
                  } else if (super.widget.p.position == 3) {
                    await Future.delayed(const Duration(seconds: 17));
                    await ProductsRepository().createState().setaflag();
                    await Future.delayed(const Duration(seconds: 4));
                    var procura2 = await ProductsRepository()
                        .createState()
                        .getProductByID(super.widget.p);
                    validade2 = procura2[0].validated;
                  } else if (super.widget.p.position == 4) {
                    await Future.delayed(const Duration(seconds: 12));
                    await ProductsRepository().createState().setaflag();
                    await Future.delayed(const Duration(seconds: 4));
                    var procura2 = await ProductsRepository()
                        .createState()
                        .getProductByID(super.widget.p);
                    validade2 = procura2[0].validated;
                  }
                  if (validade2) {
                    //
                    showDialog(
                        context: (context),
                        builder: (_context) => CupertinoAlertDialog(
                              title: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 40,
                              ),
                              content: Text(
                                  "Product ${super.widget.p.id} has been validaded"),
                            ));
                    await ProductsRepository()
                        .createState()
                        .validou(super.widget.p);
                  } else {
                    showDialog(
                        context: (context),
                        builder: (_context) => CupertinoAlertDialog(
                              title: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 40,
                              ),
                              content: Text(
                                  "Product ${super.widget.p.id} has not been validaded"),
                            ));
                  }
                  await ProductsRepository().createState().home();
                  ProductsRepository().createState().setState(() {});
                },
                color: Colors.blue,
                iconSize: 40,
              )
            ],
          ),
        )
      ],
    );
  }
}
