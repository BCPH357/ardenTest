import 'package:arden/appBar.dart';
import 'package:arden/inStationBody.dart';
import 'package:flutter/material.dart';

class InStationPage extends StatelessWidget {
  ///目前ok and next 的onpress被註解掉了
  const InStationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // var jsonData = jsonDecode(data);
    final appBar = PreferredSize(
      preferredSize: const Size.fromHeight(70.0),
      child: AppBar(
        // this argument(automaticallyImplyLeading) can cancel built-in back button.
        automaticallyImplyLeading: false,
        //sending user name to appbar to change the staff name
        //the user name is from login page

        title: const Appbar(),
        backgroundColor: const Color(0XFF333D40),
        // backgroundColor: const Color(0XFFF1F1F1),
      ),
    );

    final page = Scaffold(
      appBar: appBar,
      body: const InStation(),
      backgroundColor: const Color(0XFF4F5E63),
    );

    return page;
  }
}
