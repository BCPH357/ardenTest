import 'dart:async';

import 'package:arden/alertDialog.dart';
import 'package:arden/http.dart';
import 'package:arden/supervisorHomePage.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
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

  // List<BarcodeFormat> selectedFormats = [BarcodeFormat.qr,BarcodeFormat.code128];
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
    return SizedBox(
      height: 150,
      width: 150,
      child: IconButton(
        icon: const Icon(
          Icons.local_see_outlined,
          color: Colors.white,
          size: 150,
        ),
        tooltip: 'Scan',
        onPressed: _scan,
      ),
    );
  }

  //the method is fixed, typically didn't change,
  //ScanOptions arguments is define on above position
  Future<void> _scan() async {
    final navigator = Navigator.of(context);
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
        //Creating a http client object instance to send http request
        // navigator.push(
        //     MaterialPageRoute(builder: (context) => const SupervisorHomePage()));
        print('測試掃描結果:');
        print(scanResult?.rawContent);
        print(result.type); // The result type (barcode, cancelled, failed)
        print(result.rawContent); // The barcode content
        print(result.format); // The barcode format (as enum)
        print(result
            .formatNote); // If a unknown format was scanned this field contains a note
        if (result.format.toString() != 'qr') {
          showAlertDialog(
              navigator, setPop1AlertDialog(navigator, '請使用QR員工證掃描'));
        } else {
          final logRes = await dartHttpUtils.doLogin(
              scanResult?.rawContent, navigator, loginInfo);
          if (logRes != 'success') {
            showAlertDialog(navigator, setPop1AlertDialog(navigator, logRes));
          }
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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var loginCamera = const Camera();
    final userInfo = Provider.of<UserInfo>(context);
    return Scaffold(
      backgroundColor: const Color(0XFF2E4040),
      body: Column(
        children: <Widget>[
          Column(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 20,
              ),
              // color: Colors.green,
              child: const Text(
                "ARDEN",
                style: TextStyle(
                  fontSize: 100,
                  color: Color(0xFFEFB818),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Row(children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 250,
                  ),
                  // color: Colors.cyan,
                  //alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.badge_outlined,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(
                    right: 20,
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
            ])
          ]),
          Container(
            margin: const EdgeInsets.only(
              top: 100,
            ),
            child: loginCamera,
          )
        ],
      ),
    );
  }
}
