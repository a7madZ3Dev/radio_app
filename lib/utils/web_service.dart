import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/radio.dart';

class WebService {
  Future<BaseModel> getData(String url, BaseModel baseModel) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      baseModel.fromJson(json.decode(response.body));
      return baseModel;
    } else {
      throw Exception('Failed to load data!');
    }
  }
}

class LocalService {
  Future<BaseModel> getData(String filePath, BaseModel baseModel) {
    var fileBody = File(filePath).readAsStringSync();
    try {
      baseModel.fromJson(json.decode(fileBody));
      return Future.value(baseModel);
    } catch (error) {
      throw Exception('Failed to load data!');
    }
  }
}
