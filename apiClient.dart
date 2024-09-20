import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geri_flutter_dash/chartData.dart';
import 'package:geri_flutter_dash/flagBuilder.dart';
import 'dart:developer' as l;
import 'dart:html' as html;
import 'package:geri_flutter_dash/recordCompiler.dart' as record_machine;
import 'package:geri_flutter_dash/tableGenerator.dart' as table_machine;
import 'package:flutter/services.dart';
import 'package:geri_flutter_dash/analyticsWidgets.dart' as analytics_widget_machine;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'dart:math';
import 'package:syncfusion_flutter_charts/charts.dart';
Future<String> callLogin(String username, String password) async{


  //return true;


  final body =
  {
    'function':'login',
    'username':'$username',
    'password':'$password'
  };

  String apiKey = "[imported from files]";

  final headers = {
    'x-api-key' : '$apiKey'
  };

  final jsonHeaders = json.encode(headers);

  final jsonString = json.encode(body);

  String link = "https://iw70zve0nc.execute-api.us-west-1.amazonaws.com/default/formulaEApi-HelloWorldFunction-V3j5bSk6CNcX";

  final response = await http.post(Uri.parse(link), headers: headers, body: jsonString);

  //l.log(response.body);

  final responseBody = json.decode(response.body);

  if(responseBody["result"] == "true"){
    return username;
  }
  else{
    return "";
  }
}


Future<List<String>> getNicknames(String username) async{

  //return true;


  final body =
  {
    'function':'get_nicknames',
    'username':'$username'
  };

  String apiKey = "[imported from files]";

  final headers = {
    'x-api-key' : '$apiKey'
  };

  final jsonString = json.encode(body);

  String link = "https://iw70zve0nc.execute-api.us-west-1.amazonaws.com/default/formulaEApi-HelloWorldFunction-V3j5bSk6CNcX";

  final response = await http.post(Uri.parse(link), headers: headers, body: jsonString);

  //l.log(response.body);

  final responseBody = json.decode(response.body);

  List<dynamic> nicknames = responseBody["result"];

  List<String> finalResponse = [];

  for (dynamic item in nicknames){
    finalResponse.add(item.toString());
  }

  l.log(finalResponse.toString());

  return finalResponse;
}


Future<String> getData(String username, String nickname) async{

  //return true;


  final body =
  {
    'function':'get_data',
    'username':'$username',
    'nickname' :'$nickname'
  };

  String apiKey = "[imported from files]";

  final headers = {
    'x-api-key' : '$apiKey'
  };

  final jsonString = json.encode(body);

  String link = "https://iw70zve0nc.execute-api.us-west-1.amazonaws.com/default/formulaEApi-HelloWorldFunction-V3j5bSk6CNcX";

  final response = await http.post(Uri.parse(link), headers: headers, body: jsonString);
  final responseBody = json.decode(response.body);




  return responseBody["result"];
}


List<List<String>> convertToCSV(String input){
  input = input.substring(1);
  List<List<String>> response =  [];
  List<String> temp = input.split("~^~");
  for (String s in temp){
    response.add(s.split(","));
  }

  response = response.sublist(0, response.length-1);
  return response;
}


Future<String> uploadDataToWeb(String username, String nickname, String data) async{

  //return true;

  if(username == "" ||  nickname == "" || data == ""){
    return "false";
  }

  data = data.replaceAll("\n", "~^~");

  final body =
  {
    'function':'upload',
    'username':'$username',
    'nickname' :'$nickname',
    'data' : '$data'
  };

  String apiKey = "[imported from files]";

  final headers = {
    'x-api-key' : '$apiKey'
  };

  final jsonString = json.encode(body);

  String link = "https://iw70zve0nc.execute-api.us-west-1.amazonaws.com/default/formulaEApi-HelloWorldFunction-V3j5bSk6CNcX";

  final response = await http.post(Uri.parse(link), headers: headers, body: jsonString);
  final responseBody = json.decode(response.body);

  return responseBody["result"];
}