import 'package:tcc3/model/coordinate.dart';

class Product {
  String id;
  String name;
  // ignore: non_constant_identifier_names
  int arrivalDateYear;
  int arrivalDateMonth;
  int arrivalDateDay;
  // ignore: non_constant_identifier_names
  int deliveryDateYear;
  int deliveryDateMonth;
  int deliveryDateDay;
  bool validated;
  Coordinate coordinate;
  int position;
  String color;
  Product({
    // ignore: non_constant_identifier_names
    this.id,
    // ignore: non_constant_identifier_names
    this.arrivalDateYear,
    this.arrivalDateMonth,
    this.arrivalDateDay,
    this.name,
    // ignore: non_constant_identifier_names
    this.deliveryDateYear,
    this.deliveryDateMonth,
    this.deliveryDateDay,
    this.validated,
    this.coordinate,
    this.position,
    this.color,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        arrivalDateDay: json["arrivalDateDay"],
        arrivalDateMonth: json["arrivalDateMonth"],
        arrivalDateYear: json["arrivalDateYear"],
        deliveryDateDay: json["deliveryDateDay"],
        deliveryDateMonth: json["deliveryDateMonth"],
        deliveryDateYear: json["deliveryDateYear"],
        validated: json["validated"],
        position: json['position'],
        coordinate: Coordinate.fromJson(json["coordinate"]),
        color: json['color'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "arrivalDateDay": arrivalDateDay,
        "arrivalDateMonth": arrivalDateMonth,
        "arrivalDateYear": arrivalDateYear,
        "deliveryDateDay": deliveryDateDay,
        "deliveryDateMonth": deliveryDateMonth,
        "deliveryDateYear": deliveryDateYear,
        "validated": validated,
        "coordinate": coordinate,
        "position": position,
        "color": color,
      };
}
