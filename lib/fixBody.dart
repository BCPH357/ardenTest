import 'package:arden/alertDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'http.dart';
import 'mult_provider.dart';

List<String> list = <String>["整修方式", "整修", "換鎢鋼刀片", "整支重作"];

List<String> pList = <String>[];

List<String> fixList = <String>["線上回流", "整支重做"];

String fixStr = '';
String fixProcess = '';

int selectProcessIndex = 0;
int selectActionIndex = 0;

class DropdownButtonExample1 extends StatefulWidget {
  const DropdownButtonExample1({super.key});

  @override
  State<DropdownButtonExample1> createState() => _DropdownButtonExampleState1();
}

class _DropdownButtonExampleState1 extends State<DropdownButtonExample1> {
  String dropdownValue = fixList.first;

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue,
        icon: const Icon(
          Icons.arrow_drop_down_outlined,
          color: Colors.black,
          size: 50,
        ),
        elevation: 16,
        style: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
            fixStr = value!;
            userInfo.setReStep(fixList.indexOf(value!).toString());
            print("value");
            print(dropdownValue);
            print(value!);
            print(fixList.indexOf(value!).toString());
            selectActionIndex = fixList.indexOf(value!);
            print(selectActionIndex);
          });
        },
        items: fixList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }
}

class DropdownButtonExample2 extends StatefulWidget {
  const DropdownButtonExample2({super.key});

  @override
  State<DropdownButtonExample2> createState() => _DropdownButtonExampleState2();
}

class _DropdownButtonExampleState2 extends State<DropdownButtonExample2> {
  String dropdownValue = pList.first;

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue,
        icon: const Icon(
          Icons.arrow_drop_down_outlined,
          color: Colors.black,
          size: 50,
        ),
        elevation: 16,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
            fixProcess = value!.split(' ')[0];
            userInfo.setReStep(pList.indexOf(value!).toString());
            print("rework process");
            print(dropdownValue);
            print(value!);
            selectProcessIndex = pList.indexOf(value!);
            print(selectProcessIndex);
          });
        },
        items: pList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }
}

class FixBody extends StatelessWidget {
  List selectList = [];

  Future<void> loadPList(WorkOrderInfo workOrderInfo) async {
    pList.clear();
    for (int i = 0; i < workOrderInfo.routing.length; i++) {
      if (workOrderInfo.status_routing_step !=
          workOrderInfo.routing[i]["step"]) {
        pList.add(
            '${workOrderInfo.routing[i]["process_id"]} ${workOrderInfo.routing[i]["process_name"]}');
      } else {
        break;
      }
    }

    pList.add("其他線別");
    fixStr = fixList[0];
    fixProcess = pList[0];
  }

  FixBody({super.key});

  static const _options = <String>[
    "圖面錯誤",
    "車床欠料",
    "車床不良",
    "銑床不良",
    "架刀損壞",
    "開度不夠",
    "開度太寬",
    "焊接針孔",
    "焊接不良",
    "噴砂不良",
    "柄徑刮傷",
    "柄徑太小",
    "柄徑橢圓",
    "柄徑凹陷",
    "刀體偏擺",
    "外徑偏擺",
    "刀片龜裂",
    "刀片崩角",
    "底徑太小",
    "外徑太小",
    "刀片太薄",
    "刀片太短",
    "刀片R研磨不良",
    "遺失",
    "熱處理後欠刀",
  ];

  //initializing all options value to false.
  //when we want to know which options are selected by us we can check the List that's value are true.
  //The type(ValueNotifier) be used to listen user's operation.
  final ValueNotifier<List<bool>> _optionsSelected =
      ValueNotifier(List<bool>.generate(_options.length, (int index) => false));

  // show the outcome.
  final ValueNotifier<String> _text = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    var txt = TextEditingController();
    final navigator = Navigator.of(context);
    final workOrderInfo = Provider.of<WorkOrderInfo>(context);
    final loginInfo = Provider.of<LoginInfo>(context, listen: false);
    final fixANdOutStationState =
        Provider.of<FixAndOutStationChangeNotifier>(context);
    final fixController = TextEditingController();
    final dartHttpUtils = DartHttpUtils();
    final fixTextField = TextField(
      controller: fixController..text = "0",
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(left: 10.0),
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 40,
          fontWeight: FontWeight.w500,
        ),
        hintText: '0',
      ),
      // cursorHeight: 40,
      strutStyle: const StrutStyle(
        fontSize: 40,
      ),
    );

    return Column(
      children: <Widget>[
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
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          margin:
              const EdgeInsets.only(left: 60, top: 51.3, bottom: 15, right: 70),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 60),

                ///text middle
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, bottom: 10),

                height: 55,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  border: Border.all(
                    width: 1,
                  ),
                ),
                child: const DropdownButtonExample1(),
              ),
              Container(
                margin: const EdgeInsets.only(left: 60),

                ///text middle
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, bottom: 10),

                height: 55,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  border: Border.all(
                    width: 1,
                  ),
                ),
                child: const DropdownButtonExample2(),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 120,
                ),
                child: const Icon(
                  Icons.construction_outlined,
                  color: Colors.white,
                  size: 55,
                ),
              ),
              Container(
                ///text middle
                alignment: const Alignment(0, 0),
                margin: const EdgeInsets.only(
                  left: 15,
                ),
                height: 55,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  border: Border.all(
                    width: 1,
                  ),
                ),
                child: fixTextField,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
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
              height: 335,
              margin: const EdgeInsets.only(left: 60, right: 70),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(right: 780, top: 10),
                      child: const Text(
                        "損壞情形",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 5, left: 50, right: 80),
                        color: const Color(0XFF424E52),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: ValueListenableBuilder<List<bool>>(
                                builder: _optionsSelectionBuilder1,
                                valueListenable: _optionsSelected,
                              ),
                            ),
                            Container(
                              width: 200,
                              child: ValueListenableBuilder<List<bool>>(
                                builder: _optionsSelectionBuilder2,
                                valueListenable: _optionsSelected,
                              ),
                            ),
                            Container(
                              width: 200,
                              child: ValueListenableBuilder<List<bool>>(
                                builder: _optionsSelectionBuilder3,
                                valueListenable: _optionsSelected,
                              ),
                            ),
                            Container(
                              width: 280,
                              child: ValueListenableBuilder<List<bool>>(
                                builder: _optionsSelectionBuilder4,
                                valueListenable: _optionsSelected,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        Container(
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
            margin: const EdgeInsets.only(
              top: 45,
            ),
            // padding: const EdgeInsets.only(top: 30, bottom: 30,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 50,
                  margin: const EdgeInsets.only(
                    left: 60,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      selectProcessIndex = 0;
                      selectActionIndex = 0;
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
                Container(
                  width: 200,
                  height: 50,
                  margin: const EdgeInsets.only(
                    right: 60,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      int outQty = int.parse(fixController.text);
                      if (outQty > workOrderInfo.status_com_qty) {
                        showAlertDialog(navigator,
                            setPop1AlertDialog(navigator, "錯誤！\n整修數量大於完工數量"));
                      } else if (outQty == 0) {
                        showAlertDialog(navigator,
                            setPop1AlertDialog(navigator, "錯誤！\n整修數量不得等於0"));
                      } else {
                        selectionIndex(_optionsSelected);
                        // String res = "整修方式：$fixStr\n回流製程：$fixProcess\n整修數量：$outQty\n整修原因：$selectList";
                        // void x (){
                        //   1+1;
                        // }
                        // showAlertDialog(navigator, setPop1AlertDialog(navigator, selectActionIndex.toString()));
                        workOrderInfo.updateComQty(outQty);
                        workOrderInfo.updateBatchQty(outQty);
                        String action = "";
                        if (selectActionIndex == 0) {
                          action = "線上回流";
                        } else {
                          action = "整支重做";
                        }
                        final res = await dartHttpUtils.batchOrReworkOutAction(
                            navigator,
                            workOrderInfo,
                            loginInfo,
                            outQty,
                            action,
                            selectProcessIndex,
                            selectList.join(','));
                        // print(action);
                        // print(res);
                        if (res['res_status'] == 'success') {
                          fixANdOutStationState.increment(outQty);
                          selectProcessIndex = 0;
                          selectActionIndex = 0;
                          showAlertDialog(
                              navigator, setPop2AlertDialog(navigator, '整修成功'));
                        } else {
                          workOrderInfo.reUpdateComQty(outQty);
                          workOrderInfo.reUpdateBatchQty(outQty);
                          showAlertDialog(navigator,
                              setPop1AlertDialog(navigator, res['res_status']));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3BBA00),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    icon: const Icon(
                      Icons.done_outlined,
                      size: 50,
                    ), //icon data for elevated button
                    label: const Text(
                      "確定",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ), //label text
                  ),
                ),
              ],
            ))
      ],
    );
  }

  void selectionIndex(ValueNotifier<List<bool>> input) {
    for (int i = 0; i < input.value.length; ++i) {
      if (input.value[i]) {
        selectList.add(_options[i]);
      }
    }
  }

  //_optionsSelectionBuilder1 to 5 are fix option column for example _optionsSelectionBuilder1 means column1 and so on.
  //this function is use by a builder so you shouldn't add () when you using this function.
  //the reason for _optionsSelectionBuilder1 to 5 are defined individually is that function be used can't receive arguments.
  Widget _optionsSelectionBuilder1(
    BuildContext context,
    List<bool> hobbiesSelected,
    Widget? child,
  ) {
    List<CheckboxListTile> checkboxes = [];
    // Adding options to the Checkbox list.
    for (var i = 0; i < 7; i++) {
      checkboxes.add(CheckboxListTile(
        side: const BorderSide(
          // ======> CHANGE THE BORDER COLOR HERE <======
          color: Colors.white,
          // Give your checkbox border a custom width
          width: 2,
        ),
        title: Text(
          _options[i],
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: _optionsSelected.value[i],
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (newValue) {
          _optionsSelected.value[i] = newValue as bool;

          //The code is from official example at next line , I don't know that means,
          //that is a key to covert the options to false, I recommend shouldn't change it.
          _optionsSelected.value = List.from(_optionsSelected.value);
        },
      ));
    }

    final wid = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: checkboxes,
    );
    return wid;
  }

  Widget _optionsSelectionBuilder2(
    BuildContext context,
    List<bool> hobbiesSelected,
    Widget? child,
  ) {
    List<CheckboxListTile> checkboxes = [];
    // Adding options to the Checkbox list.
    for (var i = 7; i < 14; i++) {
      checkboxes.add(CheckboxListTile(
        side: const BorderSide(
          // ======> CHANGE THE BORDER COLOR HERE <======
          color: Colors.white,
          // Give your checkbox border a custom width
          width: 2,
        ),
        title: Text(
          _options[i],
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: _optionsSelected.value[i],
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (newValue) {
          _optionsSelected.value[i] = newValue as bool;

          //The code is from official example at next line , I don't know that means,
          //that is a key to covert the options to false, I recommend shouldn't change it.
          _optionsSelected.value = List.from(_optionsSelected.value);
        },
      ));
    }

    final wid = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: checkboxes,
    );
    return wid;
  }

  Widget _optionsSelectionBuilder3(
    BuildContext context,
    List<bool> hobbiesSelected,
    Widget? child,
  ) {
    List<CheckboxListTile> checkboxes = [];
    // Adding options to the Checkbox list.
    for (var i = 14; i < 20; i++) {
      checkboxes.add(CheckboxListTile(
        side: const BorderSide(
          // ======> CHANGE THE BORDER COLOR HERE <======
          color: Colors.white,
          // Give your checkbox border a custom width
          width: 2,
        ),
        title: Text(
          _options[i],
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: _optionsSelected.value[i],
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (newValue) {
          _optionsSelected.value[i] = newValue as bool;

          //The code is from official example at next line , I don't know that means,
          //that is a key to covert the options to false, I recommend shouldn't change it.
          _optionsSelected.value = List.from(_optionsSelected.value);
        },
      ));
    }

    final wid = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: checkboxes,
    );
    return wid;
  }

  Widget _optionsSelectionBuilder4(
    BuildContext context,
    List<bool> hobbiesSelected,
    Widget? child,
  ) {
    List<CheckboxListTile> checkboxes = [];
    // Adding options to the Checkbox list.
    for (var i = 20; i < 25; i++) {
      checkboxes.add(CheckboxListTile(
        side: const BorderSide(
          // ======> CHANGE THE BORDER COLOR HERE <======
          color: Colors.white,
          // Give your checkbox border a custom width
          width: 2,
        ),
        title: Text(
          _options[i],
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: _optionsSelected.value[i],
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (newValue) {
          _optionsSelected.value[i] = newValue as bool;

          //The code is from official example at next line , I don't know that means,
          //that is a key to covert the options to false, I recommend shouldn't change it.
          _optionsSelected.value = List.from(_optionsSelected.value);
        },
      ));
    }

    final wid = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: checkboxes,
    );
    return wid;
  }
}
