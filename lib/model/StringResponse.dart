import 'package:flutter/material.dart';

class StringResponse {
  bool response;

  StringResponse({this.response});

  Map<String, dynamic> toJson() => {'response': response};

  factory StringResponse.fromJson(Map<String, dynamic> json) =>
      StringResponse(response: json['response']);
}
