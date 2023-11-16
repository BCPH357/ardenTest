import 'dart:async';

import 'package:arden/mult_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This is the type used by the popup menu below.
enum Menu {
  A10,
  A11,
  A20,
  A209,
  A30,
  A40,
  A31,
  B10,
  B11,
  B20,
  B209,
  B21,
  C10,
  C12,
  C20,
  C30,
  C40,
  D10,
  E10,
  F10,
  G10,
  H10,
  J10,
  M10,
  M11,
  N10,
  P10,
  Y30,
  K10
}

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
    setState(() {
      _timeString =
          "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} ";
      _timeString +=
          (DateTime.now().hour >= 10 && DateTime.now().hour <= 12 ? "" : "0");
      _timeString +=
          "${DateTime.now().hour > 12 ? DateTime.now().hour - 12 : DateTime.now().hour}:";
      _timeString += (DateTime.now().minute < 10 ? "0" : "");
      _timeString += "${DateTime.now().minute}";
      _timeString += (DateTime.now().hour > 12 ? "PM" : "AM");
    });
  }
}

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
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
                  // margin: const EdgeInsets.only(left: 75,),
                  // margin: const EdgeInsets.only(left: 5,),
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
                      userInfo.userName,
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
            Text(
              userInfo.pLineId,
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),

            if (true)
              PopupMenuButton<Menu>(
                  // Callback that sets the selected popup menu item.
                  onSelected: (Menu item) {
                    userInfo.setPLineId(item.name);
                  },
                  icon: const Icon(
                    Icons.settings_outlined,
                    size: 40,
                  ),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                        const PopupMenuItem<Menu>(
                          value: Menu.A10,
                          child: Text('A10	車床'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.A11,
                          child: Text('A11	車銑複合-高偉'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.A20,
                          child: Text('A20	銑床'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.A209,
                          child: Text('A209	銑床-高偉'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.A30,
                          child: Text('A30	鑽孔、攻牙'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.A31,
                          child: Text('A31	通孔'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.A40,
                          child: Text('A40	刀體拋物線'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.B10,
                          child: Text('B10	刀片備料'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.B11,
                          child: Text('B11	刀片整型'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.B20,
                          child: Text('B20	焊接'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.B21,
                          child: Text('B21	刀體整型'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.B209,
                          child: Text('B209	焊接-高偉'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.C10,
                          child: Text('C10	噴砂'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.C12,
                          child: Text('C12	柄徑細磨'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.C20,
                          child: Text('C20	刀體校正'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.C30,
                          child: Text('C30	5比1'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.C40,
                          child: Text('C40	烤漆'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.D10,
                          child: Text('D10	粗磨'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.E10,
                          child: Text('E10	細磨'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.F10,
                          child: Text('F10	直刀'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.G10,
                          child: Text('G10	CNC'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.H10,
                          child: Text('H10	組立'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.J10,
                          child: Text('J10	品管'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.K10,
                          child: Text('K10	包裝'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.M10,
                          child: Text('M10	CNC細磨'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.M11,
                          child: Text('M11	CNC直刀'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.N10,
                          child: Text('N10	噴漆-噴砂'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.P10,
                          child: Text('P10	印柄'),
                        ),
                        const PopupMenuItem<Menu>(
                          value: Menu.Y30,
                          child: Text('Y30	熱處理-託外'),
                        ),
                      ]),
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
