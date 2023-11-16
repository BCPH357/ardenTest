import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arden/inStationPage.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'dart:io' show Platform;

class Camera extends StatefulWidget {
  //the variable options controll the build method return 出站 button or 進站 button when the camera have get the Qrcode
  final String options;
  final String userName;
  final String userID;

  const Camera(this.options, this.userName, this.userID, {super.key});

  @override
  _CameraState createState() => _CameraState(options, userName, userID);
}

//the class is for scan work order
class DartHttpUtils {
  final _client = http.Client();

  Future<List> postJsonClient(String production_num, String userName,
      String userID, BuildContext context) async {
    // server url
    var url = Uri.parse("https://644c-118-163-199-186.ngrok.io/checkInProcess");
    //Typically headersMap shouldn't be changed
    Map<String, String> headersMap = {};
    headersMap["content-type"] = ContentType.json.toString();
    //bodyParams is https request argument
    Map<String, String> bodyParams = {};
    bodyParams["production_num"] = production_num;
    bodyParams["process_num"] = "A002";
    //Typically _client shouldn't be changed
    _client
        .post(url,
            headers: headersMap,
            body: jsonEncode(bodyParams),
            encoding: const Utf8Codec())
        .then((http.Response response) {
      if (response.statusCode == 200) {
        print("掃進成功!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        var dataSend = jsonDecode(response.body);
        // to make sure server have send data
        // if sending http request successfully, switch page to InStation page.
        if (dataSend['sql_status'] == 'success') {
          dataSend['user_name'] = userName;
          dataSend['user_id'] = userID;
          var jsonText = jsonEncode(dataSend);
          print("jsonText = " + jsonText);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InStationPage()));
          // return jsonDecode(response.body);

          //To avoid staff operate fail
        } else if (dataSend['sql_status'] == '未出站') {
          showAlertDialog(context, "進站錯誤，目前在：" + dataSend['nowProcess']);
        } else if (dataSend['sql_status'] == '已出站') {
          showAlertDialog(context, "進站錯誤，下一站應該前往：" + dataSend['nextProcess']);
        }
      } else {
        return Future.error("Server Error_1");
      }
    }).catchError((error) {
      return Future.error("Server Error_2");
    });
    return Future.error("Server Error_3");
  }
}

class _CameraState extends State<Camera> {
  final String options;
  final String userName;
  final String userID;

  _CameraState(this.options, this.userName, this.userID);

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

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

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
    final scanResult = this.scanResult;

    if (options == "出站") {
      return SizedBox(
          width: 375.0,
          height: 175.0,
          child: ElevatedButton.icon(
            onPressed: _scan,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D75CA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            icon: const Icon(
              Icons.logout_outlined,
              size: 100,
            ), //icon data for elevated button
            label: const Text(
              "出站",
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.w700,
              ),
            ), //label text
          ));
    }
    //options == "進站"
    else {
      return SizedBox(
          width: 375.0,
          height: 175.0,
          child: ElevatedButton.icon(
            onPressed: _scan,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0DB532),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            icon: const Icon(
              Icons.login_outlined,
              size: 100,
            ), //icon data for elevated button
            label: const Text(
              "進站",
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.w700,
              ),
            ), //label text
          ));
    }
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          restrictFormat: selectedFormats,
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
        var dartHttpUtils = DartHttpUtils();
        String? result = scanResult?.rawContent;

        if (options == "出站") {
          // Navigator.push(context,
          //   MaterialPageRoute(builder: (context) => OutStationPage()));
        } else {
          dartHttpUtils
              .postJsonClient(result!, userName, userID, context)
              .then((value) {
            // print("user_id = $value");
          });
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

class StaffHome extends StatelessWidget {
  final String userName;
  final String userID;
  var jsonData;

  StaffHome(
      {super.key,
      required this.userName,
      this.jsonData = null,
      required this.userID});

  @override
  Widget build(BuildContext context) {
    if (jsonData != null) {}
    return Column(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: SizedBox(
                      width: 150.0,
                      height: 50.0,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // LoginPageState.open();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9A9A9A),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0))),
                        icon: const Icon(
                          Icons.assignment_return_outlined,
                        ), //icon data for elevated button
                        label: const Text(
                          "logout",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ), //label text
                      )),
                ),
                Container(
                    margin: const EdgeInsets.only(
                      top: 40,
                      right: 90,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.place_outlined,
                            size: 90,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.format_color_fill_outlined,
                            size: 90,
                            color: Colors.white,
                          ),
                        ]))
              ],
            )),
        Expanded(
            flex: 4,
            child: Container(
                margin: const EdgeInsets.only(
                  bottom: 60,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Camera("進站", userName, userID),
                    Camera("出站", userName, userID),
                  ],
                )))
      ],
    );
  }
}

showAlertDialog(BuildContext context, String text) {
  // Init
  AlertDialog dialog = AlertDialog(
    title: Text(
      text,
      style: TextStyle(fontSize: 52),
    ),
    actions: [
      ElevatedButton(
          child: Text(
            "ok",
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
    ],
  );

  // Show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      });
}
