import 'package:arden/appBar.dart';
import 'package:arden/backStationBody.dart';
import 'package:flutter/material.dart';

class BackStationPage extends StatelessWidget {
  const BackStationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      //this argument(ValueNotifier) can avoid bug when we using keyboard.
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: const BackStation(),
      backgroundColor: const Color(0XFF4F5E63),
    );

    return page;
  }
}
