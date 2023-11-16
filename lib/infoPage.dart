import 'package:arden/appBar.dart';
import 'package:arden/infoBody.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      // this argument(automaticallyImplyLeading) can cancel built-in back button.
      automaticallyImplyLeading: false,
      title: const Appbar(),
      backgroundColor: const Color(0XFF1F2A2A),
    );

    final page = Scaffold(
      appBar: appBar,
      body: const InfoBody(),
      backgroundColor: const Color(0XFF2E4040),
    );
    return page;
  }
}
