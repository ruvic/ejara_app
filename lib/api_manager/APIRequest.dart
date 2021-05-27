
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIRequest{

  static final APIRequest _instance = APIRequest._internal();

  static getInstance() => _instance;

  static const TIMEOUT = 30;

  APIRequest._internal();

  APIRequest();

  Future<http.Response> get({ @required String url, Map<String, dynamic> params, String token}) async{
    if(params != null){
      url += "?";
      params.forEach((key, value){
        url+="$key=$value&";
      });
    }
    Map<String, String> headers = {
      "Accept" : "application/json",
    };
    return await http.get(url, headers: headers);
  }

  Future<http.Response> post({ @required String url, Map<String, dynamic> params, String token}) async{
    String body;
    if(params != null){
      body = jsonEncode(params);
    }
    Map<String, String> headers = {
      "Accept" : "application/json",
    };
    if(params!=null){
      headers["content-type"] = "application/json";
    }
    return await http.post(url, headers: headers, body: body);
  }

}
