import 'dart:convert';

import 'package:flutter/cupertino.dart';

class FixAndOutStationChangeNotifier with ChangeNotifier {
  int _totalVal = 200;
  int _comQty = 0;
  int _sum = 0;
  List<int> _fixRecord = [];

  //Consumer can use it to get count
  // int get totalVal => _totalVal;
  List<int> get fixRecord => _fixRecord;

  int get comQty => _comQty;

  int get sum => _sum;

  increment(int x) {
    _fixRecord.add(x);
    _sum += x;
    // _totalVal -= _fixRecord[_fixRecord.length - 1];
    notifyListeners();
  }

  fixSum() {
    if (_fixRecord.length > 0) {
      for (int i = 0; i < _fixRecord.length; ++i) {
        _sum += _fixRecord[i];
      }
    }
    notifyListeners();
  }

  setComQty(int x) {
    _comQty = x;
  }

  clearState() {
    _fixRecord = [];
    _sum = 0;
    notifyListeners();
  }
}

class indicatorState with ChangeNotifier {
  // 設定一個整數私有變數 _count的欄位，初值為零
  ScrollController _mController = ScrollController();
  double _index = 0;
  double _currentPosition = 0;

  //可以透過 Consumer 來獲得當下 count 值
  double get index => _index;

  ScrollController get mController => _mController;

  double get currentPosition => _currentPosition;

  increment() {
    _mController.addListener(() {
      //监听滚动事件，打印滚动位置
      _mController.addListener(() {
        _index = _mController.offset;
        _currentPosition = _index >= 50 ? 1 : 0;
        var temp = _currentPosition;
        // print(mController.offset); //打印滚动位置
        // notifyListeners();
      });
    });
  }
}

class WorkOrderInfo with ChangeNotifier {
  // {
  //   "order_info": {
  //     "res_status": "success",
  //     "res": {
  //       "order_id": "5101-120221222001",
  //       "order_main_no": "5101-120221222001",
  //       "order_batch_no": null,
  //       "order_rework_no": null,
  //       "father_id": null,
  //       "customer_id": "001",
  //       "plan_lot_id": "001",
  //       "item_id": "5AB150002BL36-0002",
  //       "order_qty": 2000,
  //       "batch_qty": 2000,
  //       "check_new": true,
  //       "rework_reason": null,
  //       "update_time": "2022-12-22 15:00:00",
  //       "create_time": "2022-12-22 15:00:00"
  //     }
  //   },
  //   "order_status": {
  //   "res_status": "success",
  //     "res": {
  //     "order_id": "5101-120221222001",
  //     "wip_qty": 0,
  //     "com_qty": 2000,
  //     "routing_step": "010",
  //     "process_id": "A209",
  //     "flow_line_id": "A209",
  //     "next_flow_line_id": "A30",
  //     "check_ready": true,
  //     "check_wip": false,
  //     "check_pause": false,
  //     "check_outsource": false,
  //     "outsource_process_id": null,
  //     "update_time": "2023-01-06 20:56:57",
  //     "create_time": "2023-01-06 20:56:57"
  //     }
  //   }
  // }
  // "routing": {
  //   "res_status": "success",
  //   "routing": [
  //     {
  //       "step": "010",
  //       "process_id": "A209",
  //       "flow_line_id": "A209",
  //       "outsource": null
  //     },
  //     {
  //       "step": "020",
  //       "process_id": "A300",
  //       "flow_line_id": "A30",
  //       "outsource": null
  //     },
  //     {
  //       "step": "030",
  //       "process_id": "Y302",
  //       "flow_line_id": "103001",
  //       "outsource": null
  //     },
  //     {
  //       "step": "040",
  //       "process_id": "B110",
  //       "flow_line_id": "B11",
  //       "outsource": null
  //     },
  //     {
  //       "step": "050",
  //       "process_id": "B210",
  //       "flow_line_id": "B21",
  //       "outsource": null
  //     }
  //   ]
  // }
  String _info_status = "";
  String _info_order_id = "";
  String _info_order_no = "";
  String _info_order_num = "";
  String? _info_order_batch_no = "";
  String? _info_order_rework_no = "";
  String? _info_father_id = "";
  String _info_customer_id = "";
  String _info_customer_name = "";
  String _info_plan_lot_id = "";
  String _info_plan_class = "";
  String _info_plan_no = "";
  String _info_plan_num = "";
  String _info_item_id = "";
  String _info_item_name = "";
  String _info_specification = "";
  int _info_plan_qty = 0;
  int _info_order_qty = 0;
  int _info_batch_qty = 0;
  bool _info_check_start = true;
  bool _info_check_com = false;
  String _info_final_class_id = "";
  String? _info_rework_reason = "";
  String _info_due_date = "";
  String _info_release_date = "";
  String _info_update_time = "";
  String _info_create_time = "";

  String _status_status = "";
  String _status_order_id = "";
  int _status_wip_qty = 0;
  int _status_com_qty = 0;
  String _status_routing_step = "";
  String _status_process_id = "";
  String _status_flow_line_id = "";
  String _status_flow_line_name = "";
  String _status_class_id = "";
  String _status_next_flow_line_id = "";
  String _status_next_flow_line_name = "";
  bool _status_check_ready = false;
  bool _status_check_wip = false;
  bool _status_check_pause = false;
  bool _status_check_outsource = false;
  String? _status_outsource_process_id = "";
  String _status_update_time = "";
  String _status_create_time = "";

  String _routing_status = "";
  List _routing = [];

  String _equipment_status = "";
  List _equipment = [];
  List _equipment_options = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  String _process_list_status = "";
  List _process_list = [];
  List _process_options = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  List _selectList = [];
  int _temp_qty = 0;

  List _order_list = [];
  List _order_options = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  // bool _check_do = false;

  String get info_status => _info_status;

  String get info_order_id => _info_order_id;

  String get info_order_no => _info_order_no;

  String get info_order_num => _info_order_num;

  String? get info_order_batch_no => _info_order_batch_no;

  String? get info_order_rework_no => _info_order_rework_no;

  String? get info_father_id => _info_father_id;

  String get info_customer_id => _info_customer_id;

  String get info_customer_name => _info_customer_name;

  String get info_plan_lot_id => _info_plan_lot_id;

  String get info_plan_class => _info_plan_class;

  String get info_plan_no => _info_plan_no;

  String get info_plan_num => _info_plan_num;

  String get info_item_id => _info_item_id;

  String get info_item_name => _info_item_name;

  String get info_specification => _info_specification;

  int get info_plan_qty => _info_plan_qty;

  int get info_order_qty => _info_order_qty;

  int get info_batch_qty => _info_batch_qty;

  bool get info_check_start => _info_check_start;

  bool get info_check_com => _info_check_com;

  String get info_final_class_id => _info_final_class_id;

  String? get info_rework_reason => _info_rework_reason;

  String get info_due_date => _info_due_date;

  String get info_release_date => _info_release_date;

  String get info_update_time => _info_update_time;

  String get info_create_time => _info_create_time;

  String get status_status => _status_status;

  String get status_order_id => _status_order_id;

  int get status_wip_qty => _status_wip_qty;

  int get status_com_qty => _status_com_qty;

  String get status_routing_step => _status_routing_step;

  String get status_process_id => _status_process_id;

  String get status_flow_line_id => _status_flow_line_id;

  String get status_flow_line_name => _status_flow_line_name;

  String get status_class_id => _status_class_id;

  String get status_next_flow_line_id => _status_next_flow_line_id;

  String get status_next_flow_line_name => _status_next_flow_line_name;

  bool get status_check_ready => _status_check_ready;

  bool get status_check_wip => _status_check_wip;

  bool get status_check_pause => _status_check_pause;

  bool get status_check_outsource => _status_check_outsource;

  String? get status_outsource_process_id => _status_outsource_process_id;

  String get status_update_time => _status_update_time;

  String get status_create_time => _status_create_time;

  String get routing_status => _routing_status;

  List get routing => _routing;

  String get equipment_status => _equipment_status;

  List get equipment => _equipment;

  List get equipment_options => _equipment_options;

  String get process_list_status => _process_list_status;

  List get process_list => _process_list;

  List get process_options => _process_options;

  List get order_list => _order_list;

  List get order_options => _order_options;

  List get selectList => _selectList;

  int get temp_qty => _temp_qty;

  // bool get check_do => _check_do;

  // setCheckDo(bool check){
  //   _check_do = check;
  //   notifyListeners();
  // }

  setWorkOrderInfo(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    _info_status = jsonData["order_info"]["res_status"];
    _info_order_id = jsonData["order_info"]["res"]["order_id"];
    _info_order_no = jsonData["order_info"]["res"]["order_no"];
    _info_order_num = jsonData["order_info"]["res"]["order_num"];
    _info_order_batch_no = jsonData["order_info"]["res"]["order_batch_no"];
    _info_order_rework_no = jsonData["order_info"]["res"]["order_rework_no"];
    _info_father_id = jsonData["order_info"]["res"]["father_id"];
    _info_customer_id = jsonData["order_info"]["res"]["customer_id"];
    _info_customer_name = jsonData["order_info"]["res"]["customer_name"];
    _info_plan_lot_id = jsonData["order_info"]["res"]["plan_lot_id"];
    _info_plan_class = jsonData["order_info"]["res"]["plan_class"];
    _info_plan_no = jsonData["order_info"]["res"]["plan_no"];
    _info_plan_num = jsonData["order_info"]["res"]["plan_num"];
    _info_item_id = jsonData["order_info"]["res"]["item_id"];
    _info_item_name = jsonData["order_info"]["res"]["item_name"];
    _info_specification = jsonData["order_info"]["res"]["specification"];
    _info_plan_qty = jsonData["order_info"]["res"]["plan_qty"];
    _info_order_qty = jsonData["order_info"]["res"]["order_qty"];
    _info_batch_qty = jsonData["order_info"]["res"]["batch_qty"];
    _info_check_start = jsonData["order_info"]["res"]["check_start"];
    _info_check_com = jsonData["order_info"]["res"]["check_com"];
    _info_final_class_id = jsonData["order_info"]["res"]["final_class_id"];
    _info_rework_reason = jsonData["order_info"]["res"]["rework_reason"];
    _info_due_date = jsonData["order_info"]["res"]["due_date"];
    _info_release_date = jsonData["order_info"]["res"]["release_date"];
    _info_update_time = jsonData["order_info"]["res"]["update_time"];
    _info_create_time = jsonData["order_info"]["res"]["create_time"];

    _status_status = jsonData["order_status"]["res_status"];
    _status_order_id = jsonData["order_status"]["res"]["order_id"];
    _status_wip_qty = jsonData["order_status"]["res"]["wip_qty"];
    _status_com_qty = jsonData["order_status"]["res"]["com_qty"];
    _status_routing_step = jsonData["order_status"]["res"]["routing_step"];
    _status_process_id = jsonData["order_status"]["res"]["process_id"];
    _status_flow_line_id = jsonData["order_status"]["res"]["flow_line_id"];
    _status_flow_line_name = jsonData["order_status"]["res"]["flow_line_name"];
    _status_class_id = jsonData["order_status"]["res"]["class_id"];
    _status_next_flow_line_id =
        jsonData["order_status"]["res"]["next_flow_line_id"];
    _status_next_flow_line_name =
        jsonData["order_status"]["res"]["next_flow_line_name"];
    _status_check_ready = jsonData["order_status"]["res"]["check_ready"];
    _status_check_wip = jsonData["order_status"]["res"]["check_wip"];
    _status_check_pause = jsonData["order_status"]["res"]["check_pause"];
    _status_check_outsource =
        jsonData["order_status"]["res"]["check_outsource"];
    _status_outsource_process_id =
        jsonData["order_status"]["res"]["outsource_process_id"];
    _status_update_time = jsonData["order_status"]["res"]["update_time"];
    _status_create_time = jsonData["order_status"]["res"]["create_time"];
    notifyListeners();
  }

  setWorkOrderInfoWithProcessListAndRouting(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    _info_status = jsonData["order_info"]["res_status"];
    _info_order_id = jsonData["order_info"]["res"]["order_id"];
    _info_order_no = jsonData["order_info"]["res"]["order_no"];
    _info_order_num = jsonData["order_info"]["res"]["order_num"];
    _info_order_batch_no = jsonData["order_info"]["res"]["order_batch_no"];
    _info_order_rework_no = jsonData["order_info"]["res"]["order_rework_no"];
    _info_father_id = jsonData["order_info"]["res"]["father_id"];
    _info_customer_id = jsonData["order_info"]["res"]["customer_id"];
    _info_customer_name = jsonData["order_info"]["res"]["customer_name"];
    _info_plan_lot_id = jsonData["order_info"]["res"]["plan_lot_id"];
    _info_plan_class = jsonData["order_info"]["res"]["plan_class"];
    _info_plan_no = jsonData["order_info"]["res"]["plan_no"];
    _info_plan_num = jsonData["order_info"]["res"]["plan_num"];
    _info_item_id = jsonData["order_info"]["res"]["item_id"];
    _info_item_name = jsonData["order_info"]["res"]["item_name"];
    _info_specification = jsonData["order_info"]["res"]["specification"];
    _info_plan_qty = jsonData["order_info"]["res"]["plan_qty"];
    _info_order_qty = jsonData["order_info"]["res"]["order_qty"];
    _info_batch_qty = jsonData["order_info"]["res"]["batch_qty"];
    _info_check_start = jsonData["order_info"]["res"]["check_start"];
    _info_check_com = jsonData["order_info"]["res"]["check_com"];
    _info_final_class_id = jsonData["order_info"]["res"]["final_class_id"];
    _info_rework_reason = jsonData["order_info"]["res"]["rework_reason"];
    _info_due_date = jsonData["order_info"]["res"]["due_date"];
    _info_release_date = jsonData["order_info"]["res"]["release_date"];
    _info_update_time = jsonData["order_info"]["res"]["update_time"];
    _info_create_time = jsonData["order_info"]["res"]["create_time"];

    _status_status = jsonData["order_status"]["res_status"];
    _status_order_id = jsonData["order_status"]["res"]["order_id"];
    _status_wip_qty = jsonData["order_status"]["res"]["wip_qty"];
    _status_com_qty = jsonData["order_status"]["res"]["com_qty"];
    _status_routing_step = jsonData["order_status"]["res"]["routing_step"];
    _status_process_id = jsonData["order_status"]["res"]["process_id"];
    _status_flow_line_id = jsonData["order_status"]["res"]["flow_line_id"];
    _status_flow_line_name = jsonData["order_status"]["res"]["flow_line_name"];
    _status_class_id = jsonData["order_status"]["res"]["class_id"];
    _status_next_flow_line_id =
        jsonData["order_status"]["res"]["next_flow_line_id"];
    _status_next_flow_line_name =
        jsonData["order_status"]["res"]["next_flow_line_name"];
    _status_check_ready = jsonData["order_status"]["res"]["check_ready"];
    _status_check_wip = jsonData["order_status"]["res"]["check_wip"];
    _status_check_pause = jsonData["order_status"]["res"]["check_pause"];
    _status_check_outsource =
        jsonData["order_status"]["res"]["check_outsource"];
    _status_outsource_process_id =
        jsonData["order_status"]["res"]["outsource_process_id"];
    _status_update_time = jsonData["order_status"]["res"]["update_time"];
    _status_create_time = jsonData["order_status"]["res"]["create_time"];

    _process_list_status = jsonData["process_list"]["res_status"];
    _process_list = List.from(jsonData["process_list"]["res"]);

    for (int i = 0; i < _process_options.length; i++) {
      if (i < _process_list.length) {
        _process_options[i] =
            "${_process_list[i]['process_id']}\n${_process_list[i]['process_name']}";
      } else {
        _process_options[i] = "";
      }
    }

    // "step":"0050",
    // "process_id": "B210",
    // "process_name": "製程5",
    // "flow_line_id": "B21",
    // "flow_line_name": "線別5",
    // "outsource": null
    _routing_status = jsonData["routing"]["res_status"];
    _routing = List.from(jsonData["routing"]["routing"]);
    notifyListeners();
  }

  setWorkOrderInfoWithRouting(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    _info_status = jsonData["order_info"]["res_status"];
    _info_order_id = jsonData["order_info"]["res"]["order_id"];
    _info_order_no = jsonData["order_info"]["res"]["order_no"];
    _info_order_num = jsonData["order_info"]["res"]["order_num"];
    _info_order_batch_no = jsonData["order_info"]["res"]["order_batch_no"];
    _info_order_rework_no = jsonData["order_info"]["res"]["order_rework_no"];
    _info_father_id = jsonData["order_info"]["res"]["father_id"];
    _info_customer_id = jsonData["order_info"]["res"]["customer_id"];
    _info_customer_name = jsonData["order_info"]["res"]["customer_name"];
    _info_plan_lot_id = jsonData["order_info"]["res"]["plan_lot_id"];
    _info_plan_class = jsonData["order_info"]["res"]["plan_class"];
    _info_plan_no = jsonData["order_info"]["res"]["plan_no"];
    _info_plan_num = jsonData["order_info"]["res"]["plan_num"];
    _info_item_id = jsonData["order_info"]["res"]["item_id"];
    _info_item_name = jsonData["order_info"]["res"]["item_name"];
    _info_specification = jsonData["order_info"]["res"]["specification"];
    _info_plan_qty = jsonData["order_info"]["res"]["plan_qty"];
    _info_order_qty = jsonData["order_info"]["res"]["order_qty"];
    _info_batch_qty = jsonData["order_info"]["res"]["batch_qty"];
    _info_check_start = jsonData["order_info"]["res"]["check_start"];
    _info_check_com = jsonData["order_info"]["res"]["check_com"];
    _info_final_class_id = jsonData["order_info"]["res"]["final_class_id"];
    _info_rework_reason = jsonData["order_info"]["res"]["rework_reason"];
    _info_due_date = jsonData["order_info"]["res"]["due_date"];
    _info_release_date = jsonData["order_info"]["res"]["release_date"];
    _info_update_time = jsonData["order_info"]["res"]["update_time"];
    _info_create_time = jsonData["order_info"]["res"]["create_time"];

    _status_status = jsonData["order_status"]["res_status"];
    _status_order_id = jsonData["order_status"]["res"]["order_id"];
    _status_wip_qty = jsonData["order_status"]["res"]["wip_qty"];
    _status_com_qty = jsonData["order_status"]["res"]["com_qty"];
    _status_routing_step = jsonData["order_status"]["res"]["routing_step"];
    _status_process_id = jsonData["order_status"]["res"]["process_id"];
    _status_flow_line_id = jsonData["order_status"]["res"]["flow_line_id"];
    _status_flow_line_name = jsonData["order_status"]["res"]["flow_line_name"];
    _status_class_id = jsonData["order_status"]["res"]["class_id"];
    _status_next_flow_line_id =
        jsonData["order_status"]["res"]["next_flow_line_id"];
    _status_next_flow_line_name =
        jsonData["order_status"]["res"]["next_flow_line_name"];
    _status_check_ready = jsonData["order_status"]["res"]["check_ready"];
    _status_check_wip = jsonData["order_status"]["res"]["check_wip"];
    _status_check_pause = jsonData["order_status"]["res"]["check_pause"];
    _status_check_outsource =
        jsonData["order_status"]["res"]["check_outsource"];
    _status_outsource_process_id =
        jsonData["order_status"]["res"]["outsource_process_id"];
    _status_update_time = jsonData["order_status"]["res"]["update_time"];
    _status_create_time = jsonData["order_status"]["res"]["create_time"];

    _routing_status = jsonData["routing"]["res_status"];

    _routing = List.from(jsonData["routing"]["routing"]);

    // var temp = <String, String?>{
    //   'step':'dummy',
    //   'process_id':'dummy',
    //   'process_name':'dummy',
    //   'flow_line_id':'dummy',
    //   'flow_line_name':'dummy',
    //   'outsource':'dummy',
    // };

    notifyListeners();
  }

  setWorkOrderInfoWithEquipment(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    _info_status = jsonData["order_info"]["res_status"];
    _info_order_id = jsonData["order_info"]["res"]["order_id"];
    _info_order_no = jsonData["order_info"]["res"]["order_no"];
    _info_order_num = jsonData["order_info"]["res"]["order_num"];
    _info_order_batch_no = jsonData["order_info"]["res"]["order_batch_no"];
    _info_order_rework_no = jsonData["order_info"]["res"]["order_rework_no"];
    _info_father_id = jsonData["order_info"]["res"]["father_id"];
    _info_customer_id = jsonData["order_info"]["res"]["customer_id"];
    _info_customer_name = jsonData["order_info"]["res"]["customer_name"];
    _info_plan_lot_id = jsonData["order_info"]["res"]["plan_lot_id"];
    _info_plan_class = jsonData["order_info"]["res"]["plan_class"];
    _info_plan_no = jsonData["order_info"]["res"]["plan_no"];
    _info_plan_num = jsonData["order_info"]["res"]["plan_num"];
    _info_item_id = jsonData["order_info"]["res"]["item_id"];
    _info_item_name = jsonData["order_info"]["res"]["item_name"];
    _info_specification = jsonData["order_info"]["res"]["specification"];
    _info_plan_qty = jsonData["order_info"]["res"]["plan_qty"];
    _info_order_qty = jsonData["order_info"]["res"]["order_qty"];
    _info_batch_qty = jsonData["order_info"]["res"]["batch_qty"];
    _info_check_start = jsonData["order_info"]["res"]["check_start"];
    _info_check_com = jsonData["order_info"]["res"]["check_com"];
    _info_final_class_id = jsonData["order_info"]["res"]["final_class_id"];
    _info_rework_reason = jsonData["order_info"]["res"]["rework_reason"];
    _info_due_date = jsonData["order_info"]["res"]["due_date"];
    _info_release_date = jsonData["order_info"]["res"]["release_date"];
    _info_update_time = jsonData["order_info"]["res"]["update_time"];
    _info_create_time = jsonData["order_info"]["res"]["create_time"];

    _status_status = jsonData["order_status"]["res_status"];
    _status_order_id = jsonData["order_status"]["res"]["order_id"];
    _status_wip_qty = jsonData["order_status"]["res"]["wip_qty"];
    _status_com_qty = jsonData["order_status"]["res"]["com_qty"];
    _status_routing_step = jsonData["order_status"]["res"]["routing_step"];
    _status_process_id = jsonData["order_status"]["res"]["process_id"];
    _status_flow_line_id = jsonData["order_status"]["res"]["flow_line_id"];
    _status_flow_line_name = jsonData["order_status"]["res"]["flow_line_name"];
    _status_class_id = jsonData["order_status"]["res"]["class_id"];
    _status_next_flow_line_id =
        jsonData["order_status"]["res"]["next_flow_line_id"];
    _status_next_flow_line_name =
        jsonData["order_status"]["res"]["next_flow_line_name"];
    _status_check_ready = jsonData["order_status"]["res"]["check_ready"];
    _status_check_wip = jsonData["order_status"]["res"]["check_wip"];
    _status_check_pause = jsonData["order_status"]["res"]["check_pause"];
    _status_check_outsource =
        jsonData["order_status"]["res"]["check_outsource"];
    _status_outsource_process_id =
        jsonData["order_status"]["res"]["outsource_process_id"];
    _status_update_time = jsonData["order_status"]["res"]["update_time"];
    _status_create_time = jsonData["order_status"]["res"]["create_time"];

    _routing_status = jsonData["eqlist"]["res_status"];
    // var temp = <String, String?>{
    //   'equipment_id':'dummy',
    //   'equipment_name':'dummy',
    //   'equipment_type':'dummy',
    //   'flow_line_id':'dummy',
    // };
    _equipment = List.from(jsonData["eqlist"]["res"]);
    for (int i = 0; i < _equipment_options.length; i++) {
      if (i < _equipment.length) {
        _equipment_options[i] =
            "${_equipment[i]['equipment_id']}\n${_equipment[i]['equipment_name']}";
      } else {
        _equipment_options[i] = "";
      }
    }

    notifyListeners();
  }

  setSelectList(List list) {
    _selectList = List.from(list);
    notifyListeners();
  }

  updateComQty(int num) {
    _status_com_qty = _status_com_qty - num;
    notifyListeners();
  }

  reUpdateComQty(int num) {
    _status_com_qty = _status_com_qty + num;
    notifyListeners();
  }

  updateBatchQty(int num) {
    _info_batch_qty = _info_batch_qty - num;
    notifyListeners();
  }

  reUpdateBatchQty(int num) {
    _info_batch_qty = _info_batch_qty + num;
    notifyListeners();
  }

  setOrderList(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    for (var element in jsonData['order_list']) {
      _order_list.add(element['order_id']);
    }
    for (int i = 0; i < _order_options.length; i++) {
      if (i < _order_list.length) {
        _order_options[i] = '${_order_list[i]}';
      } else {
        _order_options[i] = "";
      }
    }
    notifyListeners();
  }

  setTempQTY(int num) {
    _temp_qty = num;
    notifyListeners();
  }

  killState() {
    _info_status = "";
    _info_order_id = "";
    _info_order_no = "";
    _info_order_num = "";
    _info_order_batch_no = "";
    _info_order_rework_no = "";
    _info_father_id = "";
    _info_customer_id = "";
    _info_customer_name = "";
    _info_plan_lot_id = "";
    _info_plan_class = "";
    _info_plan_no = "";
    _info_plan_num = "";
    _info_item_id = "";
    _info_item_name = "";
    _info_plan_qty = 0;
    _info_order_qty = 0;
    _info_batch_qty = 0;
    _info_check_start = true;
    _info_check_com = false;
    _info_specification = "";
    _info_rework_reason = "";
    _info_due_date = "";
    _info_release_date = "";
    _info_update_time = "";
    _info_create_time = "";

    _status_status = "";
    _status_order_id = "";
    _status_wip_qty = 0;
    _status_com_qty = 0;
    _status_routing_step = "";
    _status_process_id = "";
    _status_flow_line_id = "";
    _status_flow_line_name = "";
    _status_class_id = "";
    _status_next_flow_line_id = "";
    _status_next_flow_line_name = "";
    _status_check_ready = false;
    _status_check_wip = false;
    _status_check_pause = false;
    _status_check_outsource = false;
    _status_outsource_process_id = "";
    _status_update_time = "";
    _status_create_time = "";

    _routing_status = "";
    _routing = [];

    _equipment_status = "";
    _equipment = [];

    _selectList = [];
    _order_list = [];
    _temp_qty = 0;
    notifyListeners();
  }
}

class LoginInfo with ChangeNotifier {
  // response example
  // "res_status": "success",
  // "user_id": "T0005",
  // "user_name": "陳建潭",
  // "user_access": {
  // "access_1": "001",
  // "access_2": "002",
  // "access_3": "003",
  // "access_4": "004",
  // "access_5": "005",
  // "access_6": "006",
  // "access_7": "007",
  // "access_8": "008"
  // },
  // "user_flow_line": {
  // "flow_line_id_1": "A10",
  // "flow_line_id_2": "B10",
  // "flow_line_id_3": "C10"
  // }
  String _res_status = "";
  String _user_id = "";
  String _user_name = "";
  List<String> _user_access = [];
  List<String> _user_flow_line = [];

  String get res_status => _res_status;

  String get user_id => _user_id;

  String get user_name => _user_name;

  List<String> get user_access => _user_access;

  List<String> get user_flow_line => _user_flow_line;

  setLoginInfo(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    _res_status = jsonData['res_status'];
    _user_id = jsonData['user_id'];
    _user_name = jsonData['user_name'];
    var keys = jsonData["user_access"].keys;

    for (var k in keys) {
      var v = jsonData["user_access"][k];
      if (v == "001") {
        _user_access.add("進站");
      } else if (v == "002") {
        _user_access.add("報工");
      } else if (v == "003") {
        _user_access.add("出站");
      } else if (v == "004") {
        _user_access.add("退站");
      } else if (v == "005") {
        _user_access.add("入庫");
      }
      // else if (v == "006") {
      //   _user_access.add("分批");
      // }
      // else if (v == "007") {
      //   _user_access.add("整修");
      // }
      // else if (v == "008") {
      //   _user_access.add("外包");
      // }
      else if (v == "009") {
        _user_access.add("換站");
      } else if (v == "010") {
        _user_access.add("暫停");
      } else if (v == "011") {
        _user_access.add("復工");
      } else {
        print("response user_access -> invalid data " + v);
      }
    }
    // jsonData["user_access"].forEach((k, v) => {
    //   if (v == "001") {
    //     _user_access.add("進站")
    //   }
    //   else if (v == "002") {
    //     _user_access.add("報工")
    //   }
    //   else if (v == "003") {
    //     _user_access.add("出站")
    //   }
    //   else if (v == "004") {
    //     _user_access.add("退站")
    //   }
    //   // else if (v == "005") {
    //   //   _user_access.add("入庫")
    //   // }
    //   // else if (v == "006") {
    //   //   _user_access.add("分批")
    //   // }
    //   // else if (v == "007") {
    //   //   _user_access.add("整修")
    //   // }
    //   else if (v == "008") {
    //     _user_access.add("外包")
    //   }
    //   else if (v == "009") {
    //     _user_access.add("換站")
    //   }
    //   else if (v == "010") {
    //     _user_access.add("暫停")
    //   }
    //   else if (v == "011") {
    //     _user_access.add("復工")
    //   }
    //   else {
    //     print("response user_access -> invalid data " + v)
    //   }
    // });

    // jsonData["user_flow_line"].forEach((k, v) => {
    //   _user_flow_line.add(v)
    // });

    var fkeys = jsonData["user_flow_line"].keys;

    for (var k in fkeys) {
      var v = jsonData["user_flow_line"][k];
      _user_flow_line.add(v);
    }
    notifyListeners();
  }

  killState() {
    _res_status = "";
    _user_id = "";
    _user_name = "";
    _user_access = [];
    _user_flow_line = [];
    notifyListeners();
  }

  setFakeLoginInfo() {
    _res_status = "success";
    _user_id = "T0005";
    _user_name = "陳建潭";

    _user_access.add("進站");
    _user_access.add("報工");
    _user_access.add("出站");
    _user_access.add("退站");
    _user_access.add("外包");
    _user_access.add("換站");
    _user_access.add("暫停");
    _user_access.add("復工");

    _user_flow_line.add("A10");
    _user_flow_line.add("B10");
    _user_flow_line.add("C10");

    notifyListeners();
  }
}

class UserInfo with ChangeNotifier {
  // userInfo
  // {"u_id":"T0001","u_name":"周忠信","f_in":true,"f_com":true,"f_out":true,"f_back":true,"f_switch":true,"f_outsource":true,"f_set":true,"sql_status":"success"}
  String _userId = "";
  String _userName = "";
  bool _fIn = false;
  bool _fOut = false;
  bool _fCom = false;
  bool _fBack = false;
  bool _fSwitch = false;
  bool _fOutsource = false;
  bool _fSet = false;

  String get userId => _userId;

  String get userName => _userName;

  bool get fIn => _fIn;

  bool get fOut => _fOut;

  bool get fCom => _fCom;

  bool get fBack => _fBack;

  bool get fSwitch => _fSwitch;

  bool get fOutsource => _fOutsource;

  bool get fSet => _fSet;

  setUserInfo(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    _userId = jsonData['u_id'];
    _userName = jsonData['u_name'];
    _fIn = jsonData['f_in'];
    _fOut = jsonData['f_out'];
    _fCom = jsonData['f_com'];
    _fBack = jsonData['f_back'];
    _fSwitch = jsonData['f_switch'];
    _fOutsource = jsonData['f_outsource'];
    _fSet = jsonData['f_set'];
    notifyListeners();
  }

  // moInfo
  //"moInfo":
  // {"mo_id":"1101-20221012001","c_id":"4801","lot_id":"21342-21342",
  // "item_id":"5AB150002BL36-0002","mo_qty":500,"lot_qty":500,
  // "sql_status":"success","com_qty":0},
  // "equipmentList":{"sql_status":"success","equipment_list":[]}

  String _pLineId = "J10";

  String get pLineId => _pLineId;

  String _moId = "";
  String _cId = "";
  String _lotId = "";
  String _itemId = "";
  int _moQty = 0;
  int _lotQty = 0;
  int _comQty = 0;
  List<String> _equipmentList = [];
  List<String> _processList = [];

  List<String> _moList = [];
  List<int> _select_index = [];
  List<String> _selectList = []; //select
  List<String> _rePLineIdList = [];
  String _reStep = "";

  String get moId => _moId;

  String get cId => _cId;

  String get lotId => _lotId;

  String get itemId => _itemId;

  int get moQty => _moQty;

  int get lotQty => _lotQty;

  int get comQty => _comQty;

  List<String> get equipmentList => _equipmentList;

  List<String> get processList => _processList;

  List<String> get moList => _moList;

  List<int> get selectIndex => _select_index;

  List<String> get selectList => _selectList;

  List<String> get rePLineIdList => _rePLineIdList;

  String get reStep => _reStep;

  setMOInfo(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    _moId = jsonData['mo_id'];
    _cId = jsonData['c_id'];
    _lotId = jsonData['lot_id'];
    _itemId = jsonData['item_id'];
    _moQty = jsonData['mo_qty'];
    _lotQty = jsonData['lot_qty'];
    _comQty = jsonData['com_qty'];
    notifyListeners();
  }

  setEquipmentList(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    _equipmentList.clear();
    for (int i = 0; i < jsonData['equipment_list'].length; i++) {
      _equipmentList.add(jsonData['equipment_list'][i]['e_id']);
      // +"-"+jsonData['equipmentList']['equipment_list'][i]['e_name']
    }
    notifyListeners();
  }

  clearEquipmentList() {
    _equipmentList.clear();
    notifyListeners();
  }

  setProcessList(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    _processList.clear();
    for (int i = 0; i < jsonData['process_list'].length; i++) {
      _processList.add(jsonData['process_list'][i]['p_id']);
      // +"-"+jsonData['processList'][i]['p_name']
    }
    notifyListeners();
  }

  setMOList(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    _moList.clear();
    _moList = new List.from(jsonData['mo_list']);
    notifyListeners();
  }

  setREPLineIdList(String jsonString) {
    var jsonData = jsonDecode(jsonString);
    _rePLineIdList.clear();
    _rePLineIdList = new List<String>.from(jsonData['rePLindIdList']);
    for (int i = 0; i < _rePLineIdList.length; i++) {
      _rePLineIdList[i] = "${i + 1}:${_rePLineIdList[i]}";
    }
    notifyListeners();
  }

  clearREPLineIdList() {
    _rePLineIdList.clear();
    notifyListeners();
  }

  setSelectE(List<int> input) {
    _select_index = new List<int>.from(input);
    _selectList.clear();
    for (int i = 0; i < _select_index.length; i++) {
      _selectList.add(_equipmentList[_select_index[i]]);
    }
    notifyListeners();
  }

  setSelectP(List<int> input) {
    _select_index = new List<int>.from(input);
    _selectList.clear();
    for (int i = 0; i < _select_index.length; i++) {
      _selectList.add(_processList[_select_index[i]]);
    }
    notifyListeners();
  }

  setSelectW(List<int> input) {
    _select_index = new List<int>.from(input);
    _selectList.clear();
    for (int i = 0; i < _select_index.length; i++) {
      _selectList.add(_moList[_select_index[i]]);
    }
    notifyListeners();
  }

  clearSelectList() {
    _selectList.clear();
    notifyListeners();
  }

  setComQtyAndLotQty(int comQty) {
    _comQty = comQty;
    notifyListeners();
  }

  setReStep(String input) {
    _reStep = input;
    notifyListeners();
  }

  setPLineId(String input) {
    _pLineId = input;
    notifyListeners();
  }
}
