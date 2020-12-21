class Coordinate {
  double x;
  double y;
  double z;
  Coordinate(
      {
      // ignore: non_constant_identifier_names
      this.x,
      this.y,
      this.z});

  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
        x: double.parse(json["x"].toString()),
        y: double.parse(json["y"].toString()),
        z: double.parse(json["z"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
        "z": z,
      };
}
