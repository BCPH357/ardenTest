import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arden/backStationPage.dart';
import 'package:arden/changeStationPage.dart';
import 'package:arden/comStationPage.dart';
import 'package:arden/inStationPage.dart';
import 'package:arden/inStockPage.dart';
import 'package:arden/outStationPage.dart';
import 'package:arden/supervisorHomePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'alertDialog.dart';
import 'mult_provider.dart';

// const String serverURL = "http://a635-118-163-199-186.ngrok-free.app";
const String serverURL = "http://192.168.0.224:3030";

String replacePlusWithUnderscore(String input) {
  if (input.isEmpty) {
    return ''; // 如果輸入字串為空，則返回空字串
  }

  // 使用replaceAll方法將加號(+)替換為"_rw"
  String result = input.replaceAll('+', '-rw');

  return result;
}

Future<String> httpCall(navigator, client, actionURL, bodyParams) async {
  var url = Uri.parse(actionURL);
  Map<String, String> headersMap = {};
  Map<String, String> returnError = {};
  headersMap["content-type"] = ContentType.json.toString();
  showAlertDialog(navigator, waitHttpConnectionAlertDialog(navigator));
  try {
    final response = await client
        .post(url,
        headers: headersMap,
        body: jsonEncode(bodyParams),
        encoding: const Utf8Codec())
        .timeout(const Duration(seconds: 5)); // Set a timeout duration

    if (response.statusCode == 200) {
      navigator.pop();
      return response.body;
    } else {
      navigator.pop();
      returnError['res_status'] = 'Server Error_1 伺服器回應出錯';
      return jsonEncode(returnError);
    }
  } on TimeoutException {
    navigator.pop();
    returnError['res_status'] = 'Server Error_2 建立連線超時';
    return jsonEncode(returnError);
  } catch (error) {
    navigator.pop();
    returnError['res_status'] = 'Server Error_3 建立連線出錯';
    return jsonEncode(returnError);
  }
}


class HttpAction {
  final _client = http.Client();

  Future<String> login(navigator, bodyParams) async {
    const actionURL = "$serverURL/pad/login";
    final result = await httpCall(navigator, _client, actionURL, bodyParams);
    return result;
  }

  Future<String> actionCheck(navigator, bodyParams) async {
    const actionURL = "$serverURL/pad/check";
    final result = await httpCall(navigator, _client, actionURL, bodyParams);
    return result;
  }

  Future<String> updateStatus(navigator, bodyParams) async {
    const actionURL = "$serverURL/pad/updateStatus";
    final result = await httpCall(navigator, _client, actionURL, bodyParams);
    return result;
  }

  Future<String> createReworkOrBatch(navigator, bodyParams) async {
    const actionURL = "$serverURL/pad/createReworkOrBatch";
    final result = await httpCall(navigator, _client, actionURL, bodyParams);
    return result;
  }

  Future<String> editOrderRouting(navigator, bodyParams) async {
    const actionURL = "$serverURL/pad/editOrderRouting";
    final result = await httpCall(navigator, _client, actionURL, bodyParams);
    return result;
  }

  Future<String> orderPauseOrResume(navigator, bodyParams) async {
    const actionURL = "$serverURL/pad/orderPauseOrResume";
    final result = await httpCall(navigator, _client, actionURL, bodyParams);
    return result;
  }

  Future<String> inStock(navigator, bodyParams) async {
    const actionURL = "$serverURL/pad/inStock";
    final result = await httpCall(navigator, _client, actionURL, bodyParams);
    return result;
  }
}

class DartHttpUtils {
  Future<String> doLogin(userId, navigator, LoginInfo loginInfo) async {
    //Creating a http client object instance to send http request
    var httpAction = HttpAction();
    Map<String, String> bodyParams = {};
    bodyParams["user_id"] = userId!;
    final result = await httpAction.login(navigator, bodyParams);
    var jsonData = jsonDecode(result);
    if (jsonData['res_status'] == 'success') {
      loginInfo.killState();
      loginInfo.setLoginInfo(result);
      // print("userID");
      // print(loginInfo.user_id);
      navigator.push(
          MaterialPageRoute(builder: (context) => const SupervisorHomePage()));
      // 獨立出 final navigator = Navigator.of(context);
      // 異步過程之前保存並在異步過程完成後使用它
    }
    return jsonData['res_status'];
  }

  Future<String> reDoCheck(result, options, navigator,
      WorkOrderInfo workOrderInfo, loginInfo) async {
    String? orderID = replacePlusWithUnderscore(result);
    Map<String, String> bodyParams = {};
    bodyParams["order_id"] = orderID!;
    // bodyParams["order_id"] = '5101-20230216001';
    // bodyParams["order_id"] = '5101-20230216001-rw11';
    bodyParams["action"] = options;
    var httpAction = HttpAction();
    final checkResult = await httpAction.actionCheck(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    workOrderInfo.killState();
    if (jsonData['res_status'] == 'success') {
      final List<String> fLine = loginInfo.user_flow_line;
      if (options == "進站") {
        workOrderInfo.setWorkOrderInfo(checkResult);
        if (workOrderInfo.status_check_pause) {
          return "製令暫停中，無法進站";
        } else if (jsonData["order_info"]["res"]["check_com"]) {
          return "製令已入庫";
        } else if (!workOrderInfo.status_check_ready) {
          return "製令尚未出站，\n目前在${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        } else {
          for (int i = 0; i < fLine.length; i++) {
            if (fLine[i] == workOrderInfo.status_flow_line_id) {
              navigator.pushReplacement(MaterialPageRoute(
                  builder: (context) => const InStationPage()));
              return "success";
              // if (workOrderInfo.info_order_rework_no != null) {
              //   return "rework";
              // } else {
              //   navigator.pushReplacement(MaterialPageRoute(
              //       builder: (context) => const InStationPage()));
              //   return "success";
              // }
            }
          }
          return "人員權限不足，此製令在\n ${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        }
      } else if (options == "出站") {
        workOrderInfo.setWorkOrderInfoWithRouting(checkResult);
        if (workOrderInfo.status_check_pause) {
          return "製令暫停中，無法出站";
        } else if (!workOrderInfo.status_check_wip) {
          return "製令尚未進站，\n目前在${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        } else if (workOrderInfo.status_com_qty == 0) {
          return "製令無法出站，完成數量為0";
        } else {
          for (int i = 0; i < fLine.length; i++) {
            if (fLine[i] == workOrderInfo.status_flow_line_id) {
              navigator.pushReplacement(MaterialPageRoute(
                  builder: (context) => const OutStationPage()));
              return "success";
            }
          }
          return "人員權限不足，此製令在\n ${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        }
      } else if (options == "報工") {
        workOrderInfo.setWorkOrderInfoWithEquipment(checkResult);
        if (workOrderInfo.status_check_pause) {
          return "製令暫停中，無法報工";
        } else if (!workOrderInfo.status_check_wip) {
          return "製令尚未進站，\n目前在${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        } else if (workOrderInfo.status_com_qty >=
            workOrderInfo.info_batch_qty) {
          return "製令無法報工，數量已達目標${workOrderInfo.info_batch_qty}";
        } else {
          for (int i = 0; i < fLine.length; i++) {
            if (fLine[i] == workOrderInfo.status_flow_line_id) {
              navigator.pushReplacement(MaterialPageRoute(
                  builder: (context) => const ComStationPage()));
              return "success";
            }
          }
          return "人員權限不足，此製令在\n ${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        }
      } else {
        // showAlertDialog.showErrorAlertDialog(context, "option error!");
        // showErrorAlertDialog(context, "option error!");
        return "option error!";
      }
    } else {
      // showErrorAlertDialog(context, jsonData['res_status']);
      return jsonData['res_status'];
    }
  }

  Future<String> doCheckBeforeAction(result, options, navigator,
      WorkOrderInfo workOrderInfo, LoginInfo loginInfo) async {
    String? orderID = replacePlusWithUnderscore(result);
    Map<String, String> bodyParams = {};
    bodyParams["order_id"] = orderID!;
    bodyParams["action"] = options;
    var httpAction = HttpAction();
    final checkResult = await httpAction.actionCheck(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    if (jsonData['res_status'] == 'success') {
      final List<String> fLine = loginInfo.user_flow_line;
      if (options == "進站") {
        if (jsonData["order_status"]["res"]["check_pause"]) {
          return "製令暫停中，無法進站";
        } else if (jsonData["order_info"]["res"]["check_com"]) {
          return "製令已入庫";
        } else if (!jsonData["order_status"]["res"]["check_ready"]) {
          return "製令尚未出站，\n目前在${jsonData["order_status"]["res"]["flow_line_id"]} ${jsonData["order_status"]["res"]["flow_line_name"]}";
        } else {
          return "success";
        }
      } else if (options == "出站") {
        if (jsonData["order_status"]["res"]["check_pause"]) {
          return "製令暫停中，無法出站";
        } else if (jsonData["order_status"]["res"]["next_flow_line_id"] == 'STOCK') {
          return "製令無法出站，需要入庫";
        } else if (!jsonData["order_status"]["res"]["check_wip"]) {
          return "製令尚未進站，\n目前在${jsonData["order_status"]["res"]["flow_line_id"]} ${jsonData["order_status"]["res"]["flow_line_name"]}";
        } else if (jsonData["order_status"]["res"]["com_qty"] == 0) {
          return "製令無法出站，完成數量為0";
        } else {
          return "success";
        }
      } else if (options == "報工") {
        workOrderInfo.setWorkOrderInfoWithEquipment(checkResult);
        if (jsonData["order_status"]["res"]["check_pause"]) {
          return "製令暫停中，無法報工";
        } else if (!jsonData["order_status"]["res"]["check_wip"]) {
          return "製令尚未進站，\n目前在${jsonData["order_status"]["res"]["flow_line_id"]} ${jsonData["order_status"]["res"]["flow_line_name"]}";
        } else if (jsonData["order_status"]["res"]["com_qty"] >=
            jsonData["order_info"]["res"]["batch_qty"]) {
          return "製令無法報工，數量已達目標${jsonData["order_info"]["res"]["batch_qty"]}";
        } else {
          return "success";
        }
      } else {
        return "option error!";
      }
    } else {
      return jsonData['res_status'];
    }
  }

  Future<String> doCheck(result, options, navigator,
      WorkOrderInfo workOrderInfo, LoginInfo loginInfo) async {
    String? orderID = replacePlusWithUnderscore(result);
    Map<String, String> bodyParams = {};
    bodyParams["order_id"] = orderID!;
    // bodyParams["order_id"] = '5101-20230216001';
    // bodyParams["order_id"] = '5101-20230216001-rw11';
    bodyParams["action"] = options;
    var httpAction = HttpAction();
    final checkResult = await httpAction.actionCheck(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    workOrderInfo.killState();
    if (jsonData['res_status'] == 'success') {
      final List<String> fLine = loginInfo.user_flow_line;
      if (options == "進站") {
        workOrderInfo.setWorkOrderInfo(checkResult);
        if (workOrderInfo.status_check_pause) {
          return "製令暫停中，無法進站";
        } else if (jsonData["order_info"]["res"]["check_com"]) {
          return "製令已入庫";
        } else if (!workOrderInfo.status_check_ready) {
          return "製令尚未出站，\n目前在${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        } else {
          for (int i = 0; i < fLine.length; i++) {
            if (fLine[i] == workOrderInfo.status_flow_line_id) {
              if (workOrderInfo.info_order_rework_no != null) {
                return "rework";
              } else {
                navigator.push(MaterialPageRoute(
                    builder: (context) => const InStationPage()));
                return "success";
              }
            }
          }
          return "人員權限不足，此製令在\n ${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        }
      } else if (options == "出站") {
        workOrderInfo.setWorkOrderInfoWithRouting(checkResult);
        if (workOrderInfo.status_check_pause) {
          return "製令暫停中，無法出站";
        } else if (!workOrderInfo.status_check_wip) {
          return "製令尚未進站，\n目前在${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        } else if (workOrderInfo.status_com_qty == 0) {
          return "製令無法出站，完成數量為0";
        } else {
          for (int i = 0; i < fLine.length; i++) {
            if (fLine[i] == workOrderInfo.status_flow_line_id) {
              navigator.push(MaterialPageRoute(
                  builder: (context) => const OutStationPage()));
              return "success";
            }
          }
          return "人員權限不足，此製令在\n ${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        }
      } else if (options == "退站") {
        workOrderInfo.setWorkOrderInfo(checkResult);
        if (workOrderInfo.status_check_pause) {
          return "製令暫停中，無法退站";
        } else if (!workOrderInfo.status_check_wip) {
          return "製令尚未進站，\n目前在${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        } else if (workOrderInfo.status_com_qty > 0) {
          return "製令無法退站，已完成數量大於0";
        } else {
          for (int i = 0; i < fLine.length; i++) {
            if (fLine[i] == workOrderInfo.status_flow_line_id) {
              navigator.push(MaterialPageRoute(
                  builder: (context) => const BackStationPage()));
              return "success";
            }
          }
          return "人員權限不足，此製令在\n ${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        }
      } else if (options == "換站") {
        workOrderInfo.setWorkOrderInfoWithProcessListAndRouting(checkResult);
        if (workOrderInfo.status_check_pause) {
          return "製令暫停中，無法換站";
        } else if (!workOrderInfo.status_check_ready) {
          return "製令尚在加工中，\n目前在${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        } else {
          for (int i = 0; i < fLine.length; i++) {
            if (fLine[i] == workOrderInfo.status_flow_line_id) {
              navigator.push(MaterialPageRoute(
                  builder: (context) => const ChangeStationPage()));
              return "success";
            }
          }
          return "人員權限不足，此製令在\n ${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        }
      } else if (options == "報工") {
        workOrderInfo.setWorkOrderInfoWithEquipment(checkResult);
        if (workOrderInfo.status_check_pause) {
          return "製令暫停中，無法報工";
        } else if (!workOrderInfo.status_check_wip) {
          return "製令尚未進站，\n目前在${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        } else if (workOrderInfo.status_com_qty >=
            workOrderInfo.info_batch_qty) {
          return "製令無法報工，數量已達目標${workOrderInfo.info_batch_qty}";
        } else {
          for (int i = 0; i < fLine.length; i++) {
            if (fLine[i] == workOrderInfo.status_flow_line_id) {
              navigator.push(MaterialPageRoute(
                  builder: (context) => const ComStationPage()));
              return "success";
            }
          }
          return "人員權限不足，此製令在\n ${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        }
      } else if (options == "暫停") {
        workOrderInfo.setOrderList(checkResult);
        return workOrderInfo.order_list.toString();
      } else if (options == "復工") {
        workOrderInfo.setOrderList(checkResult);
        return workOrderInfo.order_list.toString();
      } else if (options == "入庫") {
        workOrderInfo.setWorkOrderInfoWithRouting(checkResult);
        if (workOrderInfo.status_check_pause) {
          return "製令暫停中，無法入庫";
        } else if (!workOrderInfo.status_check_wip) {
          return "製令尚未進站，\n目前在${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        } else if (workOrderInfo.status_com_qty == 0) {
          return "製令無法入庫，完成數量為0";
        } else {
          for (int i = 0; i < fLine.length; i++) {
            if (fLine[i] == workOrderInfo.status_flow_line_id) {
              if (workOrderInfo.routing[workOrderInfo.routing.length - 1]
                      ['step'] ==
                  workOrderInfo.status_routing_step) {
                navigator.push(MaterialPageRoute(
                    builder: (context) => const InStockPage()));
                return "success";
              } else {
                return "製令無法入庫，未在最後一站";
              }
            }
          }
          return "人員權限不足，此製令在\n ${workOrderInfo.status_flow_line_id} ${workOrderInfo.status_flow_line_name}";
        }
      } else {
        // showAlertDialog.showErrorAlertDialog(context, "option error!");
        // showErrorAlertDialog(context, "option error!");
        return "option error!";
      }
    } else {
      // showErrorAlertDialog(context, jsonData['res_status']);
      return jsonData['res_status'];
    }
  }

  Future<String> doPause(options, navigator, WorkOrderInfo workOrderInfo,
      LoginInfo loginInfo) async {
    Map<String, dynamic> bodyParams = {};
    // bodyParams["order_id"] = orderID!;
    bodyParams["order_id"] = 'pause_resume';
    bodyParams["action"] = options;
    bodyParams["flow_line_id"] = loginInfo.user_flow_line;
    var httpAction = HttpAction();
    final checkResult = await httpAction.actionCheck(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    workOrderInfo.killState();
    if (jsonData['res_status'] == 'success') {
      workOrderInfo.setOrderList(checkResult);
    }
    return jsonData['res_status'];
  }

  Future<String> inAction(
      navigator, WorkOrderInfo workOrderInfo, LoginInfo loginInfo) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    Map<String, dynamic> orderStatus = {
      "order_id": workOrderInfo.status_order_id,
      "wip_qty": workOrderInfo.status_com_qty,
      "com_qty": workOrderInfo.status_wip_qty,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "class_id": workOrderInfo.status_class_id,
      "next_flow_line_id": workOrderInfo.status_next_flow_line_id,
      "check_ready": false,
      "check_wip": true,
      "check_pause": workOrderInfo.status_check_pause,
      "check_outsource": workOrderInfo.status_check_outsource,
      "outsource_process_id": workOrderInfo.status_outsource_process_id,
      "update_time": formattedDate,
      "create_time": workOrderInfo.status_create_time
    };
    Map<String, dynamic> orderLog = {
      "order_id": workOrderInfo.info_order_id,
      "user_id": loginInfo.user_id,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "access_id": "進站自訂轉換ID",
      "access_qty": workOrderInfo.status_com_qty,
      "create_time": formattedDate,
      "equipment_id_1": null,
      "equipment_id_2": null,
      "equipment_id_3": null,
      "equipment_id_4": null,
      "equipment_id_5": null,
      "equipment_id_6": null,
      "equipment_id_7": null,
      "equipment_id_8": null,
      "equipment_id_9": null,
      "equipment_id_10": null
    };
    Map<String, dynamic> bodyParams = {
      "action": "進站",
      "order_status": orderStatus,
      "order_log": orderLog
    };
    var httpAction = HttpAction();
    final checkResult = await httpAction.updateStatus(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    if (jsonData['res_status'] != 'success') {
      return jsonData['res_status'];
    } else {
      return 'success';
    }
  }

  Future<String> comAction(
      navigator, WorkOrderInfo workOrderInfo, LoginInfo loginInfo, comQty) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    // "order_status": {
    //   "order_id": "5101-120221222001",
    //   "wip_qty": 2000,
    //   "com_qty": 0,
    //   "routing_step": "010",
    //   "process_id": "A209",
    //   "flow_line_id": "A209",
    //   "next_flow_line_id": "A30",
    //   "check_ready": false,
    //   "check_wip": true,
    //   "check_pause": false,
    //   "check_outsource": false,
    //   "outsource_process_id": null,
    //   "update_time": "2023-01-05 10:00:00",
    //   "create_time": "2023-01-05 10:00:00"
    // },
    Map<String, dynamic> orderStatus = {
      "order_id": workOrderInfo.status_order_id,
      "wip_qty": workOrderInfo.status_wip_qty - comQty,
      "com_qty": workOrderInfo.status_com_qty + comQty,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "class_id": workOrderInfo.status_class_id,
      "next_flow_line_id": workOrderInfo.status_next_flow_line_id,
      "check_ready": false,
      "check_wip": true,
      "check_pause": workOrderInfo.status_check_pause,
      "check_outsource": workOrderInfo.status_check_outsource,
      "outsource_process_id": workOrderInfo.status_outsource_process_id,
      "update_time": formattedDate,
      "create_time": workOrderInfo.status_create_time
    };

    // "order_log": {
    //   "order_id":"5101-120221222001",
    //   "user_id": "T0005",
    //   "routing_step": "010",
    //   "process_id": "A209",
    //   "flow_line_id": "A209",
    //   "access_id": "007",
    //   "access_qty": 2000,
    //   "create_time": "2023-01-05 10:00:00",
    //   "equipment_id_1": null,
    //   "equipment_id_2": null,
    //   "equipment_id_3": null,
    //   "equipment_id_4": null,
    //   "equipment_id_5": null,
    //   "equipment_id_6": null,
    //   "equipment_id_7": null,
    //   "equipment_id_8": null,
    //   "equipment_id_9": null,
    //   "equipment_id_10": null
    // }

    List eIdList = [];
    for (int i = 0; i < 10; i++) {
      if (i < workOrderInfo.selectList.length) {
        eIdList.add(workOrderInfo.selectList[i]['equipment_id']);
      } else {
        eIdList.add(null);
      }
    }

    Map<String, dynamic> orderLog = {
      "order_id": workOrderInfo.info_order_id,
      "user_id": loginInfo.user_id,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "access_id": "報工自訂轉換ID",
      "access_qty": comQty,
      "create_time": formattedDate,
      "equipment_id_1": eIdList[0],
      "equipment_id_2": eIdList[1],
      "equipment_id_3": eIdList[2],
      "equipment_id_4": eIdList[3],
      "equipment_id_5": eIdList[4],
      "equipment_id_6": eIdList[5],
      "equipment_id_7": eIdList[6],
      "equipment_id_8": eIdList[7],
      "equipment_id_9": eIdList[8],
      "equipment_id_10": eIdList[9]
    };
    Map<String, dynamic> bodyParams = {
      "action": "報工",
      "order_status": orderStatus,
      "order_log": orderLog
    };
    var httpAction = HttpAction();
    final checkResult = await httpAction.updateStatus(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    if (jsonData['res_status'] != 'success') {
      return jsonData['res_status'];
    } else {
      return 'success';
    }
    // print(bodyParams);
  }

  Future<String> outAction(
      navigator, WorkOrderInfo workOrderInfo, LoginInfo loginInfo) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String fLineID = '';
    String nextRStep = '';
    String nextPID = '';
    String nextFLineID = '';
    if (workOrderInfo.status_next_flow_line_id == 'WIPStock') {
      nextRStep = workOrderInfo.status_routing_step;
      fLineID = workOrderInfo.status_flow_line_id;
      nextFLineID = workOrderInfo.status_next_flow_line_id;
      nextPID = workOrderInfo.status_process_id;
    } else {
      fLineID = workOrderInfo.status_next_flow_line_id;
      for (int i = 0; i < workOrderInfo.routing.length - 1; i++) {
        if (workOrderInfo.routing[i]['step'] ==
            workOrderInfo.status_routing_step) {
          nextRStep = workOrderInfo.routing[i + 1]['step'];
          nextPID = workOrderInfo.routing[i + 1]['process_id'];
          if (i + 2 > workOrderInfo.routing.length - 1) {
            nextFLineID = 'STOCK';
          } else {
            nextFLineID = workOrderInfo.routing[i + 2]['flow_line_id'];
          }
        }
      }
    }

    Map<String, dynamic> orderStatus = {
      "order_id": workOrderInfo.status_order_id,
      "wip_qty": workOrderInfo.status_wip_qty,
      "com_qty": workOrderInfo.status_com_qty,
      "routing_step": nextRStep,
      "process_id": nextPID,
      "class_id": workOrderInfo.status_class_id,
      "flow_line_id": fLineID,
      "next_flow_line_id": nextFLineID,
      "check_ready": true,
      "check_wip": false,
      "check_pause": workOrderInfo.status_check_pause,
      "check_outsource": workOrderInfo.status_check_outsource,
      "outsource_process_id": workOrderInfo.status_outsource_process_id,
      "update_time": formattedDate,
      "create_time": workOrderInfo.status_create_time
    };

    Map<String, dynamic> orderLog = {
      "order_id": workOrderInfo.info_order_id,
      "user_id": loginInfo.user_id,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "access_id": "出站自訂轉換ID",
      "access_qty": workOrderInfo.status_com_qty,
      "create_time": formattedDate,
      "equipment_id_1": null,
      "equipment_id_2": null,
      "equipment_id_3": null,
      "equipment_id_4": null,
      "equipment_id_5": null,
      "equipment_id_6": null,
      "equipment_id_7": null,
      "equipment_id_8": null,
      "equipment_id_9": null,
      "equipment_id_10": null
    };

    Map<String, dynamic> bodyParams = {
      "action": "出站",
      "order_status": orderStatus,
      "order_log": orderLog
    };

    var httpAction = HttpAction();
    final checkResult = await httpAction.updateStatus(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    if (jsonData['res_status'] != 'success') {
      return jsonData['res_status'];
    }
    if (workOrderInfo.status_next_flow_line_id == 'WIPStock') {
      return '在製入庫';
    } else {
      return 'success';
    }
  }

  Future<dynamic> batchOrReworkOutAction(
      navigator,
      WorkOrderInfo workOrderInfo,
      LoginInfo loginInfo,
      int batchQTY,
      String action,
      int selectProcessIndex,
      var reworkReason) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    String nextRStep = '';
    String nextPID = '';
    String nextFLineID = '';
    if (workOrderInfo.status_next_flow_line_id != "STOCK"){
      for (int i = 0; i < workOrderInfo.routing.length; i++) {
        if (workOrderInfo.routing[i]['step'] ==
            workOrderInfo.status_routing_step) {
          nextRStep = workOrderInfo.routing[i + 1]['step'];
          nextPID = workOrderInfo.routing[i + 1]['process_id'];
          if (i + 2 > workOrderInfo.routing.length - 1) {
            nextFLineID = 'STOCK';
          } else {
            nextFLineID = workOrderInfo.routing[i + 2]['flow_line_id'];
          }
        }
      }
    }


    Map<String, dynamic> insertOrderStatus;
    if (action == '線上回流') {
      insertOrderStatus = {
        "order_id": workOrderInfo.status_order_id,
        "wip_qty": 0,
        "com_qty": batchQTY,
        "routing_step": workOrderInfo.routing[selectProcessIndex]["step"],
        "process_id": workOrderInfo.routing[selectProcessIndex]["process_id"],
        "flow_line_id": workOrderInfo.routing[selectProcessIndex]
            ["flow_line_id"],
        "class_id": workOrderInfo.status_class_id,
        "next_flow_line_id": workOrderInfo.routing[selectProcessIndex + 1]
            ["flow_line_id"],
        "check_ready": true,
        "check_wip": false,
        "check_pause": workOrderInfo.status_check_pause,
        "check_outsource": workOrderInfo.status_check_outsource,
        "outsource_process_id": workOrderInfo.status_outsource_process_id,
        "update_time": formattedDate,
        "create_time": workOrderInfo.status_create_time
      };
    } else if (action == '整支重做') {
      insertOrderStatus = {
        "order_id": workOrderInfo.status_order_id,
        "wip_qty": 0,
        "com_qty": batchQTY,
        "routing_step": workOrderInfo.status_routing_step,
        "process_id": workOrderInfo.status_process_id,
        "flow_line_id": workOrderInfo.status_flow_line_id,
        "class_id": workOrderInfo.status_class_id,
        "next_flow_line_id": workOrderInfo.status_next_flow_line_id,
        "check_ready": false,
        "check_wip": false,
        "check_pause": workOrderInfo.status_check_pause,
        "check_outsource": workOrderInfo.status_check_outsource,
        "outsource_process_id": workOrderInfo.status_outsource_process_id,
        "update_time": formattedDate,
        "create_time": workOrderInfo.status_create_time
      };
    } else {
      insertOrderStatus = {
        "order_id": workOrderInfo.status_order_id,
        "wip_qty": 0,
        "com_qty": batchQTY,
        "routing_step": nextRStep,
        "process_id": nextPID,
        "flow_line_id": workOrderInfo.status_next_flow_line_id,
        "class_id": workOrderInfo.status_class_id,
        "next_flow_line_id": nextFLineID,
        "check_ready": true,
        "check_wip": false,
        "check_pause": workOrderInfo.status_check_pause,
        "check_outsource": workOrderInfo.status_check_outsource,
        "outsource_process_id": workOrderInfo.status_outsource_process_id,
        "update_time": formattedDate,
        "create_time": workOrderInfo.status_create_time
      };
    }

    Map<String, dynamic> updateOrderInfo = {
      "order_id": workOrderInfo.info_order_id,
      "order_no": workOrderInfo.info_order_no,
      "order_num": workOrderInfo.info_order_num,
      "order_batch_no": workOrderInfo.info_order_batch_no,
      "order_rework_no": workOrderInfo.info_order_rework_no,
      "father_id": workOrderInfo.info_father_id,
      "customer_id": workOrderInfo.info_customer_id,
      "customer_name": workOrderInfo.info_customer_name,
      "plan_lot_id": workOrderInfo.info_plan_lot_id,
      "plan_class": workOrderInfo.info_plan_class,
      "plan_no": workOrderInfo.info_plan_no,
      "plan_num": workOrderInfo.info_plan_num,
      "item_id": workOrderInfo.info_item_id,
      "item_name": workOrderInfo.info_item_name,
      "plan_qty": workOrderInfo.info_plan_qty,
      "order_qty": workOrderInfo.info_order_qty,
      "batch_qty": workOrderInfo.status_com_qty + workOrderInfo.status_wip_qty,
      "check_start": workOrderInfo.info_check_start,
      "check_com": workOrderInfo.info_check_com,
      "final_class_id": workOrderInfo.info_final_class_id,
      "specification": workOrderInfo.info_specification,
      "rework_reason": workOrderInfo.info_rework_reason,
      "due_date": workOrderInfo.info_due_date,
      "release_date": workOrderInfo.info_release_date,
      "update_time": formattedDate,
      "create_time": workOrderInfo.info_create_time
    };

    var reworkReasonString =
        json.encode({"status": insertOrderStatus, "reason": reworkReason});

    Map<String, dynamic> insertOrderInfo = {
      "order_id": workOrderInfo.info_order_id,
      "order_no": workOrderInfo.info_order_no,
      "order_num": workOrderInfo.info_order_num,
      "order_batch_no": workOrderInfo.info_order_batch_no,
      "order_rework_no": workOrderInfo.info_order_rework_no,
      "father_id": workOrderInfo.info_order_id,
      "customer_id": workOrderInfo.info_customer_id,
      "customer_name": workOrderInfo.info_customer_name,
      "plan_lot_id": workOrderInfo.info_plan_lot_id,
      "plan_class": workOrderInfo.info_plan_class,
      "plan_no": workOrderInfo.info_plan_no,
      "plan_num": workOrderInfo.info_plan_num,
      "item_id": workOrderInfo.info_item_id,
      "item_name": workOrderInfo.info_item_name,
      "plan_qty": workOrderInfo.info_plan_qty,
      "order_qty": workOrderInfo.info_order_qty,
      "batch_qty": batchQTY,
      "check_start": true,
      "check_com": workOrderInfo.info_check_com,
      "final_class_id": workOrderInfo.info_final_class_id,
      "specification": workOrderInfo.info_specification,
      "rework_reason": reworkReasonString,
      "due_date": workOrderInfo.info_due_date,
      "release_date": workOrderInfo.info_release_date,
      "update_time": formattedDate,
      "create_time": formattedDate
    };

    Map<String, dynamic> updateOrderStatus = {
      "order_id": workOrderInfo.status_order_id,
      "wip_qty": workOrderInfo.status_wip_qty,
      "com_qty": workOrderInfo.status_com_qty,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "class_id": workOrderInfo.status_class_id,
      "next_flow_line_id": workOrderInfo.status_next_flow_line_id,
      "check_ready": workOrderInfo.status_check_ready,
      "check_wip": workOrderInfo.status_check_wip,
      "check_pause": workOrderInfo.status_check_pause,
      "check_outsource": workOrderInfo.status_check_outsource,
      "outsource_process_id": workOrderInfo.status_outsource_process_id,
      "update_time": formattedDate,
      "create_time": workOrderInfo.status_create_time
    };

    Map<String, dynamic> orderLog = {
      "order_id": workOrderInfo.info_order_id,
      "user_id": loginInfo.user_id,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "access_id": action,
      "access_qty": batchQTY,
      "create_time": formattedDate,
      "equipment_id_1": null,
      "equipment_id_2": null,
      "equipment_id_3": null,
      "equipment_id_4": null,
      "equipment_id_5": null,
      "equipment_id_6": null,
      "equipment_id_7": null,
      "equipment_id_8": null,
      "equipment_id_9": null,
      "equipment_id_10": null
    };

    Map<String, dynamic> bodyParams = {
      "action": action,
      "updateOrderInfo": updateOrderInfo,
      "insertOrderInfo": insertOrderInfo,
      "updateOrderStatus": updateOrderStatus,
      "insertOrderStatus": insertOrderStatus,
      "order_log": orderLog
    };

    var httpAction = HttpAction();
    final checkResult = await httpAction.createReworkOrBatch(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    return jsonData;
  }

  Future<String> backAction(navigator, workOrderInfo, loginInfo) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    Map<String, dynamic> orderStatus = {
      "order_id": workOrderInfo.status_order_id,
      "wip_qty": workOrderInfo.status_com_qty,
      "com_qty": workOrderInfo.status_wip_qty,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "class_id": workOrderInfo.status_class_id,
      "next_flow_line_id": workOrderInfo.status_next_flow_line_id,
      "check_ready": true,
      "check_wip": false,
      "check_pause": workOrderInfo.status_check_pause,
      "check_outsource": workOrderInfo.status_check_outsource,
      "outsource_process_id": workOrderInfo.status_outsource_process_id,
      "update_time": formattedDate,
      "create_time": workOrderInfo.status_create_time
    };
    Map<String, dynamic> orderLog = {
      "order_id": workOrderInfo.info_order_id,
      "user_id": loginInfo.user_id,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "access_id": "退站自訂轉換ID",
      "access_qty": workOrderInfo.status_wip_qty,
      "create_time": formattedDate,
      "equipment_id_1": null,
      "equipment_id_2": null,
      "equipment_id_3": null,
      "equipment_id_4": null,
      "equipment_id_5": null,
      "equipment_id_6": null,
      "equipment_id_7": null,
      "equipment_id_8": null,
      "equipment_id_9": null,
      "equipment_id_10": null
    };

    Map<String, dynamic> bodyParams = {
      "action": "退站",
      "order_status": orderStatus,
      "order_log": orderLog
    };
    var httpAction = HttpAction();
    final checkResult = await httpAction.updateStatus(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    if (jsonData['res_status'] != 'success') {
      return jsonData['res_status'];
    } else {
      return 'success';
    }
  }

  Future<String> switchAction(
      navigator, WorkOrderInfo workOrderInfo, LoginInfo loginInfo) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    Map<String, dynamic> orderStatus = {
      "order_id": workOrderInfo.status_order_id,
      "wip_qty": workOrderInfo.status_wip_qty,
      "com_qty": workOrderInfo.status_com_qty,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.selectList[0]['process_id'],
      "flow_line_id": workOrderInfo.selectList[0]['flow_line_id'],
      "class_id": workOrderInfo.status_class_id,
      "next_flow_line_id": workOrderInfo.status_next_flow_line_id,
      "check_ready": workOrderInfo.status_check_ready,
      "check_wip": workOrderInfo.status_check_wip,
      "check_pause": workOrderInfo.status_check_pause,
      "check_outsource": workOrderInfo.status_check_outsource,
      "outsource_process_id": workOrderInfo.status_outsource_process_id,
      "update_time": formattedDate,
      "create_time": workOrderInfo.status_create_time
    };
    Map<String, dynamic> orderLog = {
      "order_id": workOrderInfo.info_order_id,
      "user_id": loginInfo.user_id,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "access_id": "換站自訂轉換ID",
      "access_qty": workOrderInfo.status_com_qty,
      "create_time": formattedDate,
      "equipment_id_1": null,
      "equipment_id_2": null,
      "equipment_id_3": null,
      "equipment_id_4": null,
      "equipment_id_5": null,
      "equipment_id_6": null,
      "equipment_id_7": null,
      "equipment_id_8": null,
      "equipment_id_9": null,
      "equipment_id_10": null
    };

    for (int i = 0; i < workOrderInfo.routing.length; i++) {
      // var temp = <String, String?>{
      //   'step':'dummy',
      //   'process_id':'dummy',
      //   'process_name':'dummy',
      //   'flow_line_id':'dummy',
      //   'flow_line_name':'dummy',
      //   'outsource':'dummy',
      // };
      if (workOrderInfo.routing[i]['process_id'] ==
          workOrderInfo.status_process_id) {
        workOrderInfo.routing[i]['process_id'] =
            workOrderInfo.selectList[0]['process_id'];
        workOrderInfo.routing[i]['process_name'] =
            workOrderInfo.selectList[0]['process_name'];
        workOrderInfo.routing[i]['flow_line_id'] =
            workOrderInfo.selectList[0]['flow_line_id'];
        workOrderInfo.routing[i]['flow_line_name'] =
            workOrderInfo.selectList[0]['flow_line_name'];
      }
    }

    Map<String, dynamic> bodyParams = {
      "action": "換站",
      "order_status": orderStatus,
      "order_log": orderLog,
      "order_routing": {"routing": workOrderInfo.routing}
    };
    var httpAction = HttpAction();
    final checkResult = await httpAction.editOrderRouting(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    if (jsonData['res_status'] != 'success') {
      return jsonData['res_status'];
    } else {
      return 'success';
    }
  }

  Future<String> resumeAction(
      navigator, WorkOrderInfo workOrderInfo, LoginInfo loginInfo, List orderList) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    Map<String, dynamic> bodyParams = {
      "action": "復工",
      "order_list": orderList,
      "update_time": formattedDate,
      "user_id": loginInfo.user_id
    };
    var httpAction = HttpAction();
    final checkResult = await httpAction.orderPauseOrResume(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    if (jsonData['res_status'] != 'success') {
      return jsonData['res_status'];
    } else {
      return 'success';
    }
  }

  Future<String> pauseAction(
      navigator, WorkOrderInfo workOrderInfo, LoginInfo loginInfo, List orderList) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    Map<String, dynamic> bodyParams = {
      "action": "暫停",
      "order_list": orderList,
      "update_time": formattedDate,
      "user_id": loginInfo.user_id
    };
    var httpAction = HttpAction();
    final checkResult = await httpAction.orderPauseOrResume(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    if (jsonData['res_status'] != 'success') {
      return jsonData['res_status'];
    } else {
      return 'success';
    }
  }

  Future<String> inStockAction(
      navigator, WorkOrderInfo workOrderInfo, LoginInfo loginInfo) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    Map<String, dynamic> orderStatus = {
      "order_id": workOrderInfo.status_order_id,
      "wip_qty": workOrderInfo.status_com_qty,
      "com_qty": workOrderInfo.status_wip_qty,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "class_id": workOrderInfo.status_class_id,
      "next_flow_line_id": workOrderInfo.status_next_flow_line_id,
      "check_ready": false,
      "check_wip": false,
      "check_pause": workOrderInfo.status_check_pause,
      "check_outsource": workOrderInfo.status_check_outsource,
      "outsource_process_id": workOrderInfo.status_outsource_process_id,
      "update_time": formattedDate,
      "create_time": workOrderInfo.status_create_time
    };
    Map<String, dynamic> orderLog = {
      "order_id": workOrderInfo.info_order_id,
      "user_id": loginInfo.user_id,
      "routing_step": workOrderInfo.status_routing_step,
      "process_id": workOrderInfo.status_process_id,
      "flow_line_id": workOrderInfo.status_flow_line_id,
      "access_id": "入庫自訂轉換ID",
      "access_qty": workOrderInfo.status_com_qty,
      "create_time": formattedDate,
      "equipment_id_1": null,
      "equipment_id_2": null,
      "equipment_id_3": null,
      "equipment_id_4": null,
      "equipment_id_5": null,
      "equipment_id_6": null,
      "equipment_id_7": null,
      "equipment_id_8": null,
      "equipment_id_9": null,
      "equipment_id_10": null
    };

    Map<String, dynamic> updateOrderInfo = {
      "order_id": workOrderInfo.info_order_id,
      "order_no": workOrderInfo.info_order_no,
      "order_num": workOrderInfo.info_order_num,
      "order_batch_no": workOrderInfo.info_order_batch_no,
      "order_rework_no": workOrderInfo.info_order_rework_no,
      "father_id": workOrderInfo.info_father_id,
      "customer_id": workOrderInfo.info_customer_id,
      "customer_name": workOrderInfo.info_customer_name,
      "plan_lot_id": workOrderInfo.info_plan_lot_id,
      "plan_class": workOrderInfo.info_plan_class,
      "plan_no": workOrderInfo.info_plan_no,
      "plan_num": workOrderInfo.info_plan_num,
      "item_id": workOrderInfo.info_item_id,
      "item_name": workOrderInfo.info_item_name,
      "plan_qty": workOrderInfo.info_plan_qty,
      "order_qty": workOrderInfo.info_order_qty,
      "batch_qty": workOrderInfo.status_com_qty + workOrderInfo.status_wip_qty,
      "check_start": workOrderInfo.info_check_start,
      "check_com": true,
      "final_class_id": workOrderInfo.info_final_class_id,
      "specification": workOrderInfo.info_specification,
      "rework_reason": workOrderInfo.info_rework_reason,
      "due_date": workOrderInfo.info_due_date,
      "release_date": workOrderInfo.info_release_date,
      "update_time": formattedDate,
      "create_time": workOrderInfo.info_create_time
    };
    Map<String, dynamic> bodyParams = {
      "action": "入庫",
      "order_status": orderStatus,
      "order_log": orderLog,
      "updateOrderInfo": updateOrderInfo
    };
    var httpAction = HttpAction();
    final checkResult = await httpAction.inStock(navigator, bodyParams);
    var jsonData = jsonDecode(checkResult);
    if (jsonData['res_status'] != 'success') {
      return jsonData['res_status'];
    } else {
      return 'success';
    }
  }
}
