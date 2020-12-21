import 'dart:convert';
import 'package:dio/dio.dart' as dio;

import 'package:http/http.dart' as http;

import 'package:tcc3/model/product.dart';
import 'dart:convert' as convert;

class Products {
  static const _baseUrl = 'https://tcc-data-75bf1.firebaseio.com/';
  Uri url = Uri.parse('https://192.168.0.103:5001/product/call');

  static Map<String, Product> _itens = Map<String, Product>();

  void getResponse() {}

  void atualizar(List<Product> lista) {
    Map<String, Product> list = Map<String, Product>();
    Set<Product> set = Set.from(lista);
    set.forEach((element) {
      list.putIfAbsent(element.id, () => element);
    });
    _itens = list;
  }

  List<Product> get all {
    return [..._itens.values];
  }

  Product getById(int i) {
    return [..._itens.values][i];
  }

  int get count {
    return [..._itens.values].length;
  }

  // ignore: non_constant_identifier_names
  bool ProductExists(String id) {
    bool flag = false;
    _itens.forEach((key, value) {
      if (value.id == id) {
        flag = true;
      }
    });
    if (!flag)
      return false;
    else
      return true;
  }

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  Future<void> put(Product product) async {
    if (product != null) {
      if (_itens.containsKey(product.id) &&
          product.id != null &&
          product.id.trim().isNotEmpty) {
        final updateResponse =
            await http.patch("$_baseUrl/products/${product.id}.json",
                body: json.encode({
                  'id': product.id,
                  'arrivalDateDay': product.arrivalDateDay,
                  'arrivalDateMonth': product.arrivalDateMonth,
                  'arrivalDateYear': product.arrivalDateYear,
                  'deliveryDateDay': product.deliveryDateDay,
                  'deliveryDateMonth': product.deliveryDateMonth,
                  'deliveryDateYear': product.deliveryDateYear,
                  'name': product.name,
                  'validated': product.validated,
                }));
        _itens.update(
            product.id,
            (value) => Product(
                  id: product.id,
                  arrivalDateDay: product.arrivalDateDay,
                  arrivalDateMonth: product.arrivalDateMonth,
                  arrivalDateYear: product.arrivalDateYear,
                  deliveryDateDay: product.deliveryDateDay,
                  deliveryDateMonth: product.deliveryDateMonth,
                  deliveryDateYear: product.deliveryDateYear,
                  name: product.name,
                  validated: product.validated,
                ));
      } else if (all.length < 4 &&
          product.id != null &&
          product.id.trim().isNotEmpty) {
        final response = await http.post("$_baseUrl/products/.json",
            body: json.encode({
              'id': product.id,
              'arrivalDateDay': product.arrivalDateDay,
              'arrivalDateMonth': product.arrivalDateMonth,
              'arrivalDateYear': product.arrivalDateYear,
              'deliveryDateDay': product.deliveryDateDay,
              'deliveryDateMonth': product.deliveryDateMonth,
              'deliveryDateYear': product.deliveryDateYear,
              'name': product.name,
              'validated': product.validated,
            }));
        final id = json.decode(response.body)['name'];
        print(json.decode(response.body));
        _itens.putIfAbsent(
            product.id,
            () => Product(
                  id: product.id,
                  arrivalDateDay: product.arrivalDateDay,
                  arrivalDateMonth: product.arrivalDateMonth,
                  arrivalDateYear: product.arrivalDateYear,
                  deliveryDateDay: product.deliveryDateDay,
                  deliveryDateMonth: product.deliveryDateMonth,
                  deliveryDateYear: product.deliveryDateYear,
                  name: product.name,
                  validated: product.validated,
                ));
      }
    } else
      return;
  }

  void remove(Product p) {
    if (p != null) _itens.remove(p.id);
  }
}
