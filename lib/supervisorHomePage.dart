import 'package:arden/appBar.dart';
import 'package:arden/mult_provider.dart';
import 'package:arden/supervisorHomeBody.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupervisorHomePage extends StatelessWidget {
  //The data is from http request passed by login page.
  const SupervisorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = PreferredSize(
      preferredSize: const Size.fromHeight(70.0),
      child: AppBar(
        // this argument(automaticallyImplyLeading) can cancel built-in back button.
        automaticallyImplyLeading: false,
        //sending user name to appbar to change the staff name
        //the user name is from login page
        backgroundColor: const Color(0XFF333D40),

        title: Consumer<UserInfo>(
          builder: (context, userInfo, _) {
            return const Appbar();
          },
          // backgroundColor: const Color(0XFFF1F1F1),
        ),
      ),
    );

    final page = Scaffold(
      appBar: appBar,
      body: const SupervisorHome(),
      backgroundColor: const Color(0XFF4F5E63),
    );

    return page;
  }
}
