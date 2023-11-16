import 'dart:convert';

class Data {
  var stringData;
  var jsonData;
  String p_line_id = "A209";

  void set_jsonData(stringData) {
    this.stringData = stringData;
    jsonData = jsonDecode(stringData);
    // deviceDropdownValue = jsonData['equipmentList'].cast<String>()[0];
  }

  String getStringData() {
    return stringData;
  }

  String getUserName() {
    return jsonData['u_name'];
  }

  String getUserId() {
    return jsonData['u_id'];
  }

  String getMOId() {
    return jsonData['mo_id'];
  }

  String getPlanNum() {
    return jsonData['c_id'] + "(" + jsonData['lot_id'] + ")";
  }

  String getItemId() {
    return jsonData['item_id'];
  }

  int getMoQty() {
    return jsonData['mo_qty'];
  }

  int getLotQty() {
    return jsonData['lot_qty'];
  }

  int getWIPQty() {
    return jsonData['wip_qty'];
  }

  int getComQty() {
    return jsonData['com_qty'];
  }

  List<String> getEquipmentList() {
    List<String> res = [];
    print(jsonData['equipmentList']);
    print(jsonData['equipmentList']['equipment_list']);
    for (int i = 0;
        i < jsonData['equipmentList']['equipment_list'].length;
        i++) {
      res.add(jsonData['equipmentList']['equipment_list'][i]['e_id']);
      // +"-"+jsonData['equipmentList']['equipment_list'][i]['e_name']
    }
    return res;
  }

  List<String> getProcessList() {
    jsonData['processList'].cast<String>();
    List<String> res = [];
    for (int i = 0; i < jsonData['processList'].length; i++) {
      res.add(jsonData['processList'][i]['p_id']);
      // +"-"+jsonData['processList'][i]['p_name']
    }
    return res;
  }

  String getPLineId() {
    return p_line_id;
  }
}
