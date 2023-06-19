import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt_chat/constants/constants.dart';
import 'package:chatgpt_chat/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModel() async {
    try {
      var response = await http.get(Uri.parse("$apiUrl/models"),
          headers: {'Authorization': 'Bearer $openAIkey'});

      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] : ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
      // print("jsonResponse: $jsonResponse");
      List temp = [];
      for (var i in jsonResponse["data"]) {
        temp.add(i);
        // log("i: ${i['id']}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error: $error");
      rethrow;
    }
  }
}
