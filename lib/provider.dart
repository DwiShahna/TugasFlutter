import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sekolah/guruModel.dart';

// class GuruProvider extends ChangeNotifier {
//   List<DataGuru> _data = [];
//   List<DataGuru> get dataGuru => _data;

//   Future<List<DataGuru>> getGuru() async {
//     final url = "http://127.0.0.1/sekolah/api/guru.php";

//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final result =
//           json.decode(response.body)['data'].cast<Map<String, dynamic>>();
//       _data = result.map<DataGuru>((json) => DataGuru.fromJson(json)).toList();
//       return _data;
//     } else {
//       throw Exception();
//     }
//   }
// }
class GuruProvider {
  static const ROOT = 'http://localhost/EmployeesDB/employee_actions.php';
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';

  // Method to create the table Employees.
  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(ROOT, body: map);
      print('Create Table Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<DataGuru>> getGuru() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      print('getEmployees Response: ${response.body}');
      if (200 == response.statusCode) {
        List<DataGuru> list = parseResponse(response.body);
        return list;
      } else {
        return List<DataGuru>();
      }
    } catch (e) {
      return List<DataGuru>(); // return an empty list on exception/error
    }
  }

  static List<DataGuru> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<DataGuru>((json) => DataGuru.fromJson(json)).toList();
  }
}
