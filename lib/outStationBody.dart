import 'dart:async';
import 'dart:math' as math;

import 'package:arden/alertDialog.dart';
import 'package:arden/fixPage.dart';
import 'package:arden/http.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';

class Camera extends StatefulWidget {
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
  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = 1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
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
    if (options == "下一張") {
      return Container(
          margin: const EdgeInsets.only(right: 40),
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
          width: 150.0,
          height: 70.0,
          child: ElevatedButton.icon(
            onPressed: () async {
              final checkRes = await dartHttpUtils.doCheckBeforeAction(
                  workOrderInfo.info_order_id,
                  '出站',
                  navigator,
                  workOrderInfo,
                  loginInfo);
              if (checkRes == 'success') {
                if (workOrderInfo.status_com_qty > 0) {
                  if (workOrderInfo.status_com_qty <
                      workOrderInfo.info_batch_qty) {
                    showAlertDialog(navigator,
                        setPop1AlertDialog(navigator, '完工數量小於批量，\n不能出站！'));
                  } else {
                    String res = await dartHttpUtils.outAction(
                        navigator, workOrderInfo, loginInfo);
                    if (res == 'success') {
                      for (int i = 0; i < workOrderInfo.routing.length; i++) {
                        if (workOrderInfo.routing[i]['step'] ==
                            workOrderInfo.status_routing_step) {
                          showAlertDialog(
                              navigator,
                              setDoAgainAlertDialog(
                                  navigator,
                                  '出站成功，請前往${workOrderInfo.routing[i + 1]['flow_line_id']}-${workOrderInfo.routing[i + 1]['flow_line_name']}',
                                  _scan));
                          break;
                        }
                      }
                    } else if (res == '在製入庫') {
                      showAlertDialog(
                          navigator,
                          setDoAgainAlertDialog(
                              navigator, '出站成功，工單需在製入庫', _scan));
                    } else {
                      showAlertDialog(
                          navigator, setPop1AlertDialog(navigator, res));
                    }
                  }
                } else {
                  showAlertDialog(navigator,
                      setPop1AlertDialog(navigator, '警告!\n完工數量不能為0！'));
                }
              } else {
                showAlertDialog(
                    navigator, setPop2AlertDialog(navigator, checkRes));
              }
            },
            onLongPress: () async {
              final checkRes = await dartHttpUtils.doCheckBeforeAction(
                  workOrderInfo.info_order_id,
                  '出站',
                  navigator,
                  workOrderInfo,
                  loginInfo);
              if (checkRes == 'success') {
                if (workOrderInfo.status_com_qty > 0) {
                  if (workOrderInfo.status_com_qty <
                      workOrderInfo.info_batch_qty) {
                    showAlertDialog(navigator,
                        setPop1AlertDialog(navigator, '完工數量小於批量，\n不能出站！'));
                  } else {
                    String res = await dartHttpUtils.outAction(
                        navigator, workOrderInfo, loginInfo);
                    if (res == 'success') {
                      for (int i = 0; i < workOrderInfo.routing.length; i++) {
                        if (workOrderInfo.routing[i]['step'] ==
                            workOrderInfo.status_routing_step) {
                          showAlertDialog(
                              navigator,
                              reInputOrderIDAlertDialog(
                                  '出站成功，請前往${workOrderInfo.routing[i + 1]['flow_line_id']}-${workOrderInfo.routing[i + 1]['flow_line_name']}',
                                  navigator,
                                  workOrderInfo,
                                  loginInfo,
                                  '出站'));
                          break;
                        }
                      }
                    } else if (res == '在製入庫') {
                      for (int i = 0; i < workOrderInfo.routing.length; i++) {
                        showAlertDialog(
                            navigator,
                            reInputOrderIDAlertDialog('出站成功，工單需在製入庫', navigator,
                                workOrderInfo, loginInfo, '出站'));
                      }
                    } else {
                      showAlertDialog(
                          navigator, setPop1AlertDialog(navigator, res));
                    }
                  }
                } else {
                  showAlertDialog(navigator,
                      setPop1AlertDialog(navigator, '警告!\n完工數量不能為0！'));
                }
              } else {
                showAlertDialog(
                    navigator, setPop2AlertDialog(navigator, checkRes));
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006CBA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0))),
            icon: const Icon(
              Icons.arrow_forward_outlined,
              size: 35,
            ),
            //icon data for elevated button
            label: const Text(
              "下一張",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ), //label text
          ));
    } else {
      return ElevatedButton(
        child: const Text(
          "確認",
          style: TextStyle(
            fontSize: 40,
            letterSpacing: 5,
          ),
        ),
        // onPressed: () {
        //   Navigator.pop(context);
        //   _scan();
        // }
        onPressed: () {
          _scan();
        },
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
      if (mounted) {
        setState(() => scanResult = result);
      }
      //scanResult?.rawContent != "": 進到相機按下cancel還是有回傳值""
      if (scanResult != null && scanResult?.rawContent != "") {
        if (result.format.toString() == 'qr') {
          showAlertDialog(navigator, setPop1AlertDialog(navigator, '請掃描製令條碼'));
        } else {
          final res = await dartHttpUtils.reDoCheck(scanResult?.rawContent,
              '出站', navigator, workOrderInfo, loginInfo);
          // final res = 'test';
          if (res != 'success') {
            showAlertDialog(navigator, setPop2AlertDialog(navigator, res));
          }
        }
      }
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

class Outstation extends StatelessWidget {
  const Outstation({super.key});

  @override
  Widget build(BuildContext context) {
    var txt = TextEditingController();
    final dartHttpUtils = DartHttpUtils();
    final navigator = Navigator.of(context);
    final loginInfo = Provider.of<LoginInfo>(context);
    final workOrderInfo = Provider.of<WorkOrderInfo>(context);
    final fixANdOutStationState =
        Provider.of<FixAndOutStationChangeNotifier>(context);
    fixANdOutStationState.clearState();
    final buttonIcon = Transform.rotate(
        angle: 1 / 2 * math.pi,
        child: Container(
          padding: const EdgeInsets.only(bottom: 100),
          child: const IconButton(
            icon: Icon(
              size: 40,
              Icons.call_split_outlined,
              color: Colors.white,
            ),
            onPressed: null,
          ),
        ));
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 420,
                  // padding: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: const Color(0XFF424E52),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 4,
                        offset: Offset(1, 8), // Shadow position
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: <Widget>[
                            Container(
                              // text middle
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "製令 M",
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              // text middle
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 20),
                              // padding: const EdgeInsets.only(left: 10,),
                              child: Text(
                                workOrderInfo.info_order_id,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 10),

                              // text middle
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "客戶 C",
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              ///text middle
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 20),
                              // padding: const EdgeInsets.only(left: 10,),
                              child: Text(
                                workOrderInfo.info_customer_id,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),

                              // text middle
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "品號  I",
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              // text middle
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 35),
                              // padding: const EdgeInsets.only(left: 10,),
                              width: 543,
                              child: Text(
                                workOrderInfo.info_item_id,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: <Widget>[
                            Container(
                              ///text middle
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "總量 Q",
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              // text middle
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 30),
                              // padding: const EdgeInsets.only(left: 10,),
                              child: Text(
                                "${workOrderInfo.info_order_qty}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: <Widget>[
                            Container(
                              // text middle
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "批量 B",
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              ///text middle
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 30),
                              // padding: const EdgeInsets.only(left: 10,),
                              width: 198,
                              child: Text(
                                "${workOrderInfo.info_batch_qty}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              // text middle
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "完工 N",
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              // text middle
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 30),
                              // padding: const EdgeInsets.only(left: 10,),
                              child: Text(
                                "${workOrderInfo.status_com_qty}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0XFF424E52),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 4,
                        offset: Offset(1, 8), // Shadow position
                      ),
                    ],
                  ),
                  height: 420,
                  width: 375,
                  padding: const EdgeInsets.only(left: 30),
                  margin: const EdgeInsets.only(top: 15, right: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 320,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: const EdgeInsets.only(top: 5, right: 40),
                                    constraints: const BoxConstraints(
                                      minWidth: 200.0, // 最小寬度
                                      minHeight: 130.0, // 最小高度
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0)),
                                      border: Border.all(
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      '現處線別\n${workOrderInfo.status_flow_line_id}\n${workOrderInfo.status_flow_line_name}',
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center, // 將文本置中
                                    )),
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(left: 2),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 55,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFBA6400),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black38,
                                                    blurRadius: 4,
                                                    offset: Offset(1,
                                                        8), // Shadow position
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 18, bottom: 15),
                                              child: IconButton(
                                                onPressed: () async {
                                                  int thisComQty = 0;
                                                  if (txt.text != "") {
                                                    thisComQty =
                                                        int.parse(txt.text);
                                                  }
                                                  await workOrderInfo
                                                      .setTempQTY(thisComQty);
                                                  navigator.push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const FixPage()));
                                                },
                                                icon: const Icon(
                                                  Icons.construction_outlined,
                                                  size: 50,
                                                  color: Colors.white,
                                                ), //icon data for elevated button//label text
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // text middle
                                        alignment: const Alignment(0, 0),
                                        margin: const EdgeInsets.only(left: 10),
                                        height: 70,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF878787),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16.0)),
                                          border: Border.all(
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          "${fixANdOutStationState.sum}",
                                          style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // for (int i = 0;
                                // i < fixANdOutStationState.fixRecord.length;
                                // ++i)
                                //   Container(
                                //     // text middle
                                //     alignment: const Alignment(0, 0),
                                //     margin: const EdgeInsets.only(
                                //         right: 35, top   : 15),
                                //     height: 70,
                                //     width: 150,
                                //     decoration: BoxDecoration(
                                //       color: const Color(0xFF878787),
                                //       borderRadius: const BorderRadius.all(
                                //           Radius.circular(16.0)),
                                //       border: Border.all(
                                //         width: 1,
                                //       ),
                                //     ),
                                //     child: Text(
                                //       fixANdOutStationState.fixRecord[i].toString(),
                                //       style: const TextStyle(
                                //         fontSize: 40,
                                //         fontWeight: FontWeight.w500,
                                //       ),
                                //     ),
                                //   ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.check_box_outlined,
                                        color: Colors.white,
                                        size: 70,
                                      ),
                                      Container(
                                        // text middle
                                        alignment: const Alignment(0, 0),
                                        margin: const EdgeInsets.only(left: 10),
                                        height: 70,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16.0)),
                                          border: Border.all(
                                            width: 1,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: txt
                                            ..text =
                                                "${workOrderInfo.status_com_qty}",
                                          style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(left: 10.0),
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 40,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            hintText: "0",
                                          ),
                                          // cursorHeight: 40,
                                          strutStyle: const StrutStyle(
                                            fontSize: 40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Camera("下一張"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        //bottom Bar
        Container(
          // margin: const EdgeInsets.only(top: 31),
          height: 93.4,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 1.5,
                color: Color(0XFF333D40),
              ),
            ),
            color: Color(0XFF333D40),
          ),
          // margin: const EdgeInsets.only(top: 60),
          // padding: const EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 200,
                height: 50,
                // margin: const EdgeInsets.only(left: 30),
                child: ElevatedButton.icon(
                  onPressed: () {
                    navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9A9A9A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  icon: const Icon(
                    Icons.close_outlined,
                    size: 50,
                  ), //icon data for elevated button
                  label: const Text(
                    "取消",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ), //label text
                ),
              ),
              // Camera(userInfo.moId, userInfo.userId, userInfo.pLineId),
              Container(
                //20221108新增與隱藏
                width: 200,
                height: 50,
                // margin: const EdgeInsets.only(left: 30),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final checkRes = await dartHttpUtils.doCheckBeforeAction(
                        workOrderInfo.info_order_id,
                        '出站',
                        navigator,
                        workOrderInfo,
                        loginInfo);
                    if (checkRes == 'success') {
                      if (workOrderInfo.status_com_qty > 0) {
                        int thisBatchQty = 0;
                        if (txt.text != "") {
                          thisBatchQty = int.parse(txt.text);
                        }
                        if (thisBatchQty > 0) {
                          if (thisBatchQty > workOrderInfo.status_com_qty) {
                            showAlertDialog(navigator,
                                setPop1AlertDialog(navigator, '警告!\n完工數量不足！'));
                          } else if (thisBatchQty >=
                              workOrderInfo.info_batch_qty) {
                            showAlertDialog(
                                navigator,
                                setPop1AlertDialog(
                                    navigator, '警告!\n分批數量不得大於等於批量！'));
                          } else {
                            workOrderInfo.updateComQty(thisBatchQty);
                            workOrderInfo.updateBatchQty(thisBatchQty);
                            final res =
                                await dartHttpUtils.batchOrReworkOutAction(
                                    navigator,
                                    workOrderInfo,
                                    loginInfo,
                                    thisBatchQty,
                                    "分批",
                                    0,
                                    null);

                            if (res['res_status'] == 'success') {
                              showAlertDialog(navigator,
                                  setPop3AlertDialog(navigator, '分批成功'));
                            } else {
                              workOrderInfo.reUpdateComQty(thisBatchQty);
                              workOrderInfo.reUpdateBatchQty(thisBatchQty);
                              showAlertDialog(
                                  navigator,
                                  setPop1AlertDialog(
                                      navigator, res['res_status']));
                            }
                          }
                        } else {
                          showAlertDialog(navigator,
                              setPop1AlertDialog(navigator, '警告!\n分批數量不能為0！'));
                        }
                      } else {
                        showAlertDialog(navigator,
                            setPop1AlertDialog(navigator, '警告!\n完工數量不能為0！'));
                      }
                    } else {
                      showAlertDialog(
                          navigator, setPop2AlertDialog(navigator, checkRes));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006CBA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  icon: buttonIcon, //icon data for elevated button
                  label: const Text(
                    "分批",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ), //label text
                ),
              ),
              Container(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final checkRes = await dartHttpUtils.doCheckBeforeAction(
                        workOrderInfo.info_order_id,
                        '出站',
                        navigator,
                        workOrderInfo,
                        loginInfo);
                    if (checkRes == 'success') {
                      int thisBatchQty = 0;
                      if (txt.text != "") {
                        thisBatchQty = int.parse(txt.text);
                      }
                      if ((workOrderInfo.status_com_qty ==
                          workOrderInfo.info_batch_qty)) {
                        if ((thisBatchQty == workOrderInfo.info_batch_qty)) {
                          String res = await dartHttpUtils.outAction(
                              navigator, workOrderInfo, loginInfo);
                          if (res == 'success') {
                            for (int i = 0;
                                i < workOrderInfo.routing.length;
                                i++) {
                              if (workOrderInfo.routing[i]['step'] ==
                                  workOrderInfo.status_routing_step) {
                                showAlertDialog(
                                    navigator,
                                    setPop3AlertDialog(navigator,
                                        '出站成功，請前往${workOrderInfo.routing[i + 1]['flow_line_id']}-${workOrderInfo.routing[i + 1]['flow_line_name']}'));
                                break;
                              }
                            }
                          } else if (res == '在製入庫') {
                            showAlertDialog(navigator,
                                setPop3AlertDialog(navigator, '出站成功，工單需在製入庫'));
                          } else {
                            showAlertDialog(
                                navigator, setPop1AlertDialog(navigator, res));
                          }
                        } else {
                          showAlertDialog(
                              navigator,
                              setPop1AlertDialog(
                                  navigator, '輸入數量不等於批量，\n不能出站！'));
                        }
                      } else {
                        showAlertDialog(navigator,
                            setPop1AlertDialog(navigator, '完工數量不等於批量，\n不能出站！'));
                      }
                    } else {
                      showAlertDialog(
                          navigator, setPop2AlertDialog(navigator, checkRes));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3BBA00),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  icon: const Icon(
                    Icons.logout_outlined,
                    size: 50,
                  ), //icon data for elevated button
                  label: const Text(
                    "出站",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ), //label text
                ),
              ),
              // Camera()
            ],
          ),
        ),
      ],
    );
  }
}
