import 'dart:async';
import 'dart:convert';

import 'package:arden/actionPausePage.dart';
import 'package:arden/alertDialog.dart';
import 'package:arden/http.dart';
import 'package:arden/inStationPage.dart';
import 'package:arden/resumeWorkPage.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'controlChartPage.dart';
import 'messageBoardPage.dart';
import 'mult_provider.dart';
import 'productionOrderPage.dart';
import 'testRecordPage.dart';

class Camera extends StatefulWidget {
  //the variable options controll the build method return 出站 button or 進站 button when the camera have get the Qrcode
  final String options;

  const Camera(this.options, {super.key});

  @override
  _CameraState createState() => _CameraState(options);
}

class _CameraState extends State<Camera> {
  final String options;

  _CameraState(this.options);

  ScanResult? scanResult;

  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  // the five variables is scan options, can refer documentation
  // https://pub.dev/packages/barcode_scan2
  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = 1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  // static final _possibleFormats is fixed method, typically shouldn't change it.
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedCode128Formats = [
    BarcodeFormat.qr,
    BarcodeFormat.code128
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final workOrderInfo = Provider.of<WorkOrderInfo>(context);
    final loginInfo = Provider.of<LoginInfo>(context, listen: false);
    final dartHttpUtils = DartHttpUtils();
    final scanResult = this.scanResult;
    if (options == "出站") {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(1, 8), // Shadow position
              ),
            ],
          ),
          width: 250.0,
          height: 125.0,
          child: ElevatedButton.icon(
            onPressed: () {
              _scan();
            },
            onLongPress: () async {
              showAlertDialog(
                  navigator,
                  inputOrderIDAlertDialog(
                      navigator, workOrderInfo, loginInfo, options));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF1976D2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            icon: const Icon(
              Icons.logout_outlined,
              size: 50,
              color: Colors.white,
            ),
            //icon data for elevated button
            label: const Text(
              "出站",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.w700,
              ),
            ), //label text
          ));
    } else if (options == "退站") {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(1, 8), // Shadow position
              ),
            ],
          ),
          width: 250.0,
          height: 125.0,
          child: ElevatedButton.icon(
            onPressed: () {
              _scan();
            },
            onLongPress: () async {
              showAlertDialog(
                  navigator,
                  inputOrderIDAlertDialog(
                      navigator, workOrderInfo, loginInfo, options));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00796B),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            icon: const Icon(
              Icons.backspace_outlined,
              size: 50,
            ),
            //icon data for elevated button
            label: const Text(
              "退站",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
              ),
            ), //label text
          ));
    } else if (options == "換站") {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(1, 8), // Shadow position
              ),
            ],
          ),
          width: 250.0,
          height: 125.0,
          child: ElevatedButton.icon(
            onPressed: () {
              _scan();
            },
            onLongPress: () async {
              showAlertDialog(
                  navigator,
                  inputOrderIDAlertDialog(
                      navigator, workOrderInfo, loginInfo, options));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA726),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            icon: const Icon(
              Icons.swap_horiz_outlined,
              size: 50,
            ),
            //icon data for elevated button
            label: const Text(
              "換站",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
              ),
            ), //label text
          ));
    } else if (options == "入庫") {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(1, 8), // Shadow position
              ),
            ],
          ),
          width: 250.0,
          height: 125.0,
          child: ElevatedButton.icon(
            onPressed: () {
              _scan();
            },
            onLongPress: () async {
              showAlertDialog(
                  navigator,
                  inputOrderIDAlertDialog(
                      navigator, workOrderInfo, loginInfo, options));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF57C00),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            icon: const Icon(
              Icons.warehouse_outlined,
              size: 50,
            ),
            //icon data for elevated button
            label: const Text(
              "入庫",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
              ),
            ), //label text
          ));
    } else if (options == "報工") {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(1, 8), // Shadow position
              ),
            ],
          ),
          width: 250.0,
          height: 125.0,
          child: ElevatedButton.icon(
            onPressed: () {
              _scan();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26A69A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            icon: const Icon(
              Icons.file_download_done_outlined,
              size: 50,
            ),
            onLongPress: () async {
              showAlertDialog(
                  navigator,
                  inputOrderIDAlertDialog(
                      navigator, workOrderInfo, loginInfo, options));
            },
            //icon data for elevated button
            label: const Text(
              "報工",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
              ),
            ), //label text
          ));
    } else if (options == "暫停") {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(1, 8), // Shadow position
              ),
            ],
          ),
          width: 250.0,
          height: 125.0,
          child: ElevatedButton.icon(
            onPressed: () async {
              final res = await dartHttpUtils.doPause(
                  '暫停', navigator, workOrderInfo, loginInfo);
              if (res == 'success') {
                navigator.push(MaterialPageRoute(
                    builder: (context) => const ActionPausePage()));
              } else {
                showAlertDialog(
                    navigator, setPop1AlertDialog(navigator, res));
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            icon: const Icon(
              Icons.pause_outlined,
              size: 50,
            ), //icon data for elevated button
            label: const Text(
              "暫停",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
              ),
            ), //label text
          ));
    } else if (options == "復工") {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(1, 8), // Shadow position
              ),
            ],
          ),
          width: 250.0,
          height: 125.0,
          child: ElevatedButton.icon(
            onPressed: () async {
              final res = await dartHttpUtils.doPause(
                  '復工', navigator, workOrderInfo, loginInfo);
              if (res == 'success') {
                navigator.push(MaterialPageRoute(
                    builder: (context) => const ResumeWorkPage()));
              } else {
                showAlertDialog(
                    navigator, setPop1AlertDialog(navigator, res));
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27AE60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            icon: const Icon(
              Icons.play_arrow_outlined,
              size: 50,
            ), //icon data for elevated button
            label: const Text(
              "復工",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
              ),
            ), //label text
          ));
    }

    else if (options == "進站"){
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(1, 8), // Shadow position
              ),
            ],
          ),
          width: 250.0,
          height: 125.0,
          child: ElevatedButton.icon(
            onPressed: () {
              _scan();
            },
            onLongPress: () async {
              showAlertDialog(
                  navigator,
                  inputOrderIDAlertDialog(
                      navigator, workOrderInfo, loginInfo, options));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3498DB),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            icon: const Icon(
              Icons.login_outlined,
              size: 50,
            ),
            //icon data for elevated button
            label: const Text(
              "進站",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
              ),
            ), //label text
          ));
    }
    else if(options == "命令單"){
      return Container(
        // padding: const EdgeInsets.only(bottom: 10, top: 10),
        // height: 80,
        // width: 150,
        margin: const EdgeInsets.only(left: 30, top: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0XFFe8b419),
            width: 3.5,
          ), // 外框顏色
          borderRadius: BorderRadius.circular(10.0), // 可選的，添加圓角
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            _scan();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductionPage(),
              ),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent, // 背景顏色設置為透明
          ),
          icon: const Icon(
            Icons.add,
            size: 60,
          ),
          label: Text(
            "製造命令單",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),// 文本顏色，可以根據需要調整
          ),
        ),
      );
    }
    else if(options == "紀錄表"){
      return Container(
        // padding: const EdgeInsets.only(bottom: 10, top: 10),
        // height: 80,
        // width: 150,
        margin: const EdgeInsets.only(left: 30, top: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0XFFe8b419),
            width: 3.5,
          ), // 外框顏色
          borderRadius: BorderRadius.circular(10.0), // 可選的，添加圓角
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            _scan();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TestRecordPage(),
              ),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent, // 背景顏色設置為透明
          ),
          icon: const Icon(
            Icons.add,
            size: 60,
          ),
          label: Text(
            "檢驗紀錄表",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),// 文本顏色，可以根據需要調整
          ),
        ),
      );
    }
    //options == "品管表"
    else {
      return Container(
        // padding: const EdgeInsets.only(bottom: 10, top: 10),
        // height: 80,
        // width: 150,
        margin: const EdgeInsets.only(left: 30, top: 5),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0XFFe8b419),
            width: 3.5,
          ), // 外框顏色
          borderRadius: BorderRadius.circular(10.0), // 可選的，添加圓角
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            _scan();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ControlChartPage(),
              ),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent, // 背景顏色設置為透明
          ),
          icon: const Icon(
            Icons.add,
            size: 60,
          ),
          label: Text(
            "生產流程\n品質管制表",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),// 文本顏色，可以根據需要調整
          ),
        ),
      );
    }
  }

  Future<void> _scan() async {
    final navigator = Navigator.of(context);
    final workOrderInfo = Provider.of<WorkOrderInfo>(context, listen: false);
    final loginInfo = Provider.of<LoginInfo>(context, listen: false);
    final dartHttpUtils = DartHttpUtils();
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          restrictFormat: selectedCode128Formats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() => scanResult = result);
      //scanResult?.rawContent != "": Pressing the cancer button the still return "" to scanResult ,when enter the camera page.
      // this if expression is the key to detect the QRcode have scan.
      if (scanResult != null && scanResult?.rawContent != "") {
          //creat a http client object instance to send http request
          final res = await dartHttpUtils.doCheck(scanResult?.rawContent,
              options, navigator, workOrderInfo, loginInfo);
          // print('status_process_id');
          // print(workOrderInfo.status_process_id);

          if (res == 'rework') {
            var reason = workOrderInfo.info_rework_reason;
            if (reason != null) {
              final jsonBody = json.decode(reason);
              if (jsonBody['reason'] != null) {
                print(jsonBody);
                // Init
                AlertDialog dialog = AlertDialog(
                  title: Text(
                    '此工單為整修單，原因如下：\n${jsonBody['reason']}',
                    style: const TextStyle(
                      height: 2,
                      fontSize: 52,
                      letterSpacing: 5,
                    ),
                  ),
                  titlePadding: const EdgeInsets.fromLTRB(70, 20, 70, 10),
                  buttonPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  backgroundColor: Colors.white,
                  // 背景色
                  elevation: 10,
                  // 阴影高度
                  actions: [
                    ElevatedButton(
                        child: const Text(
                          "確認",
                          style: TextStyle(
                            fontSize: 40,
                            letterSpacing: 5,
                          ),
                        ),
                        onPressed: () {
                          navigator.pop();
                          navigator.push(MaterialPageRoute(
                              builder: (context) => const InStationPage()));
                        }),
                  ],
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                );
                showAlertDialog(navigator, dialog);
              } else {
                navigator.push(MaterialPageRoute(
                    builder: (context) => const InStationPage()));
              }
            }
          } else if (res != 'success') {
            showAlertDialog(navigator, setPop1AlertDialog(navigator, res));
          }
      }
      // camera's exception handling
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }
}
// class Indicator extends StatefulWidget {
//   @override
//   _IndicatorState createState() => _IndicatorState();
// }
//
//
// class _IndicatorState extends State<Indicator> {
//   final _totalDots = 2;
//
//   @override
//   Widget build(BuildContext context) {
//     final decorator = DotsDecorator(
//       activeColor: Colors.red,
//       size: Size.square(15.0),
//       activeSize: Size.square(35.0),
//       activeShape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(25.0),
//       ),
//     );
//     return Container(
//       child: Consumer<indicatorState>(builder: (context, scrollState, _) {
//         return Row(
//           children: <Widget>[
//             TextButton(
//               child: Text("test"),
//               onPressed: () {
//                 // setState(() =>
//                 // _currentPosition = scrollState.index >= 50 ? 1 : 0);
//                 print(scrollState.index);
//                 print(scrollState.currentPosition);
//               },
//             ),
//             DotsIndicator(
//               dotsCount: _totalDots,
//               position: scrollState.currentPosition,
//               reversed: false,
//               decorator: decorator,
//             ),
//           ],
//         );
//       })
//     );
//   }
// }

class SupervisorHome extends StatelessWidget {
  const SupervisorHome({super.key});

  @override
  Widget build(BuildContext context) {
    // final userInfo = Provider.of<UserInfo>(context);
    final navigator = Navigator.of(context);
    final loginInfo = Provider.of<LoginInfo>(context);
    final scrollState = Provider.of<indicatorState>(context);
    var buttonKeyList = sortButtonList(loginInfo.user_access);
    var buttonKeyListSizeF = loadButtonKeyListSizeF(buttonKeyList);
    var buttonKeyListSizeL = loadButtonKeyListSizeL(buttonKeyList);
    scrollState.increment();

    return Column(
      children: <Widget>[
        // Container(
        //   margin: const EdgeInsets.only(top: 115, bottom: 70),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              controller: scrollState.mController,
              scrollDirection: Axis.horizontal,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 15, right: 25),
                  // color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 35,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(4, (index) {
                            // print("size");
                            // print(buttonKeyListSizeF);
                            if (index < buttonKeyListSizeF) {
                              return Container(
                                margin: const EdgeInsets.only(
                                  left: 25,
                                ),
                                child: Camera(buttonKeyList[index]),
                              );
                            } else {
                              return Container(
                                margin: const EdgeInsets.only(
                                  left: 25,
                                ),
                                child: const SizedBox(
                                  width: 250.0,
                                  height: 125.0,
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(buttonKeyListSizeL, (index) {
                          return Container(
                            margin: const EdgeInsets.only(
                              left: 25,
                            ),
                            // child: Camera(buttonKeyList[index + 4 - (4 - buttonKeyListSizeF)]),
                            child: Camera(
                                buttonKeyList[index + buttonKeyListSizeF]),
                          );
                        }),
                      ),
                    ],
                  )),
            ),
          ),
        ),
        // ),
        // Container(
        //   child: indicator,
        // ),
        Container(
            margin: const EdgeInsets.only(top: 41),
            height: 88.6,
            padding: const EdgeInsets.only(
              bottom: 5,
            ),
            decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5.0)],
              color: Color(0XFF333D40),
            ),
            // margin: const EdgeInsets.only(top: 10,),
            // padding: const EdgeInsets.only(top: 30, bottom: 30,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  height: 80,
                  width: 150,
                  margin: const EdgeInsets.only(left: 60, top: 5),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9A9A9A),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    icon: const Icon(
                      Icons.assignment_return_outlined,
                      size: 35,
                    ), //icon data for elevated button
                    label: const Text(
                      "登出",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    ), //label text
                  ),
                ),
                Expanded(child: Container()), // 這個小部件實際上是一個空容器，它將占據剩餘的空間

                Camera("品管表"),
                Camera("紀錄表"),
                Camera("命令單"),
              ],
            )
        ),
      ],
    );
  }

  int loadButtonKeyListSizeF(List<String> button) {
    int ans = 0;

    for (int i = 0; i < button.length; ++i) {
      if ((button[i] == "進站" ||
          button[i] == "報工" ||
          button[i] == "換站" ||
          button[i] == "暫停")) {
        ++ans;
      }
    }
    return ans;
  }

  int loadButtonKeyListSizeL(List<String> button) {
    int ans = 0;

    for (int i = 0; i < button.length; ++i) {
      if ((button[i] == "出站" ||
          button[i] == "退站" ||
          button[i] == "入庫" ||
          button[i] == "復工")) {
        ++ans;
      }
    }
    return ans;
  }

  List<String> sortButtonList(List<String> array) {
    var arrayWeights = <String, int>{
      "進站": 1,
      "報工": 2,
      "換站": 3,
      "暫停": 4,
      "出站": 5,
      "退站": 6,
      "入庫": 7,
      "復工": 8,
    };

    int lengthOfArray = array.length;

    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (arrayWeights[array[j]]! >
            (arrayWeights[array[j + 1]]?.toInt() ?? 0)) {
          // Swapping using temporary variable
          String temp = array[j];
          array[j] = array[j + 1];
          array[j + 1] = temp;
        }
      }
    }
    return array;
  }
}
