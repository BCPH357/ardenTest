import 'dart:convert';

import 'package:arden/appBar.dart';
import 'package:arden/staffHomeBody.dart';
import 'package:flutter/material.dart';

class StaffHomePage extends StatelessWidget {
  //The data is from http request passed by login page.
  final String data;

  const StaffHomePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var stringData = jsonDecode(data);
    final appBar = AppBar(
      // this argument(automaticallyImplyLeading) can cancel built-in back button.
      automaticallyImplyLeading: false,
      //sending user name to appbar to change the staff name
      //the user name is from login page
      title: const Appbar(),
      backgroundColor: const Color(0XFF1F2A2A),
    );

    final page = Scaffold(
      appBar: appBar,
      body: StaffHome(
          userName: stringData['user_name'], userID: stringData['user_id']),
      backgroundColor: const Color(0XFF2E4040),
    );

    return page;
  }
}
