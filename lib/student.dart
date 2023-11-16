import 'dart:convert';

import 'package:http/http.dart' as http;

///這個頁面跟專案沒有關係只是拿來當作instationBody中的info button的假資料

class Student {
  String baseUrl = "http://localhost:8000/api/v1/students";

  Future<List> getAllStudent() async {
    try {
      var response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
