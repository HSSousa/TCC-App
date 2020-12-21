import 'package:flutter/material.dart';

class BoolResponse {
  bool response;

  BoolResponse({this.response});

  Map<String, dynamic> toJson() => {'response': response};

  factory BoolResponse.fromJson(Map<String, dynamic> json) =>
      BoolResponse(response: json['response']);
}
