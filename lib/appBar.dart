import 'dart:async';

import 'package:arden/mult_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlutterTime extends StatefulWidget {
  const FlutterTime({super.key});

  @override
  _FlutterTimeState createState() => _FlutterTimeState();
}

class _FlutterTimeState extends State<FlutterTime> {
  late String _timeString;

  @override
  void initState() {
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeString,
      style: const TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _getCurrentTime() {
    if (mounted) {
      setState(() {
        _timeString =
            "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} ";
        _timeString +=
            ((DateTime.now().hour >= 10 && DateTime.now().hour <= 12) ||
                    (DateTime.now().hour >= 22 && DateTime.now().hour <= 24)
                ? ""
                : "0");
        _timeString +=
            "${DateTime.now().hour > 12 ? DateTime.now().hour - 12 : DateTime.now().hour}:";
        _timeString += (DateTime.now().minute < 10 ? "0" : "");
        _timeString += "${DateTime.now().minute}";
        _timeString += (DateTime.now().hour > 12 ? "PM" : "AM");
      });
    }
  }
}

class Appbar extends StatelessWidget {
  const Appbar({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final loginInfo = Provider.of<LoginInfo>(context);
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);
    return Container(
      // color: Colors.green,
      margin: const EdgeInsets.only(
        top: 13,
      ),
      child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
                flex: 1,
                child: Text(
                  "ARDEN",
                  style: TextStyle(
                    fontSize: 50,
                    color: Color(0xFFEFB818),
                    fontWeight: FontWeight.w900,
                  ),
                )),
            Expanded(
                child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                    left: 75,
                  ),
                  child: const Icon(
                    Icons.account_circle_outlined,
                    size: 45,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Text(
                      loginInfo.user_name,
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                      ),
                    ))
              ],
            )),
            Container(
              margin: const EdgeInsets.only(
                right: 20,
              ),
              child: const FlutterTime(),
            ),
            // const Icon(
            //   Icons.format_color_fill_outlined,
            //   size: 50,
            //   color: Colors.white,
            // ),
            // Text(
            //   userInfo.pLineId,
            //   style: const TextStyle(
            //     fontSize: 40,
            //     color: Colors.white,
            //   ),
            // ),
            // IconButton(
            //   icon: const Icon(
            //     Icons.settings_outlined,
            //     size: 40,
            //   ),
            //   onPressed: () {},
            // )
          ]),
    );
  }
}
