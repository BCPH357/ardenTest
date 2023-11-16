import 'package:arden/alertDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';

class DeviceSelection extends StatelessWidget {
  DeviceSelection({super.key});

  //Loading counter value on start
  List selectList = [];

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final workOrderInfo = Provider.of<WorkOrderInfo>(context);

    int numOfOption = returnOptionSize(workOrderInfo.equipment_options);
    int numOfColumn = numOfOption % 6 == 0
        ? (numOfOption / 6).toInt()
        : (numOfOption / 6).toInt() + 1;
    int blank = 6 - (numOfOption % 6);

    //initializing all options value to false.
    //when we want to know which options are selected by us we can check the List that's value are true.
    //The type(ValueNotifier) be used to listen user's operation.
    final ValueNotifier<List<bool>> optionsSelected = ValueNotifier(
        List<bool>.generate(
            workOrderInfo.equipment_options.length, (int index) => false));

    // show the outcome.
    final ValueNotifier<String> _text = ValueNotifier('');

    final fixController = TextEditingController();
    final fixTextField = TextField(
      controller: fixController,
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
              height: 425,
              width: 1000,
              margin: const EdgeInsets.only(top: 51.3),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(right: 780, top: 10),
                      child: const Text(
                        "設備清單",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 5, left: 50, right: 80),
                        color: const Color(0XFF424E52),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(numOfColumn, (index) {
                            //if (index == )
                            return Container(
                              width: 200,
                              child: ValueListenableBuilder<List<bool>>(
                                // builder: selectionColumns[index],
                                builder: (context, hobbiesSelected, child) {
                                  if (index == numOfColumn - 1 &&
                                      numOfOption % 6 != 0) {
                                    return _optionsSelectionBuilder(
                                        context,
                                        hobbiesSelected,
                                        child,
                                        blank,
                                        index * 6,
                                        workOrderInfo.equipment_options,
                                        optionsSelected);
                                  } else {
                                    return _optionsSelectionBuilder(
                                        context,
                                        hobbiesSelected,
                                        child,
                                        0,
                                        index * 6,
                                        workOrderInfo.equipment_options,
                                        optionsSelected);
                                  }
                                },
                                valueListenable: optionsSelected,
                              ),
                            );
                          }),
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
              top: 46,
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
                      print("blank: ");
                      print(blank);
                      print(numOfColumn);
                      print(numOfOption);
                      // userInfo.clearSelectList();
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
                    onPressed: () {
                      selectionIndex(optionsSelected, workOrderInfo);
                      workOrderInfo.setSelectList(selectList);
                      if (workOrderInfo.equipment.isEmpty ||
                          workOrderInfo.selectList.isNotEmpty) {
                        navigator.pop();
                        // showAlertDialog(navigator, setPop2AlertDialog(navigator, "${selectList.length}"));
                      } else {
                        showAlertDialog(
                            navigator, setPop1AlertDialog(navigator, '請選擇設備'));
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
                      "確認",
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

  //0 = 沒選
  //1 = 正確
  //2 = 多選
  void selectionIndex(
      ValueNotifier<List<bool>> input, WorkOrderInfo workOrderInfo) {
    final eqlist = workOrderInfo.equipment;
    for (int i = 0; i < input.value.length; ++i) {
      if (input.value[i]) {
        selectList.add(eqlist[i]);
      }
    }
  }

  //_optionsSelectionBuilder1 to 5 are fix option column for example _optionsSelectionBuilder1 means column1 and so on.
  //this function is use by a builder so you shouldn't add () when you using this function.
  //the reason for _optionsSelectionBuilder1 to 5 are defined individually is that function be used can't receive arguments.
  Widget _optionsSelectionBuilder(
      BuildContext context,
      List<bool> hobbiesSelected,
      Widget? child,
      int blank,
      int startIndex,
      List options,
      ValueNotifier<List<bool>> optionsSelected) {
    List<CheckboxListTile> checkboxes = [];
    // Adding options to the Checkbox list.
    for (var i = startIndex; i < startIndex + 6 - blank; i++) {
      checkboxes.add(CheckboxListTile(
        side: const BorderSide(
          // ======> CHANGE THE BORDER COLOR HERE <======
          color: Colors.white,
          // Give your checkbox border a custom width
          width: 2,
        ),
        title: Text(
          options[i],
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: optionsSelected.value[i],
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (newValue) {
          optionsSelected.value[i] = newValue as bool;

          //The code is from official example at next line , I don't know that means,
          //that is a key to covert the options to false, I recommend shouldn't change it.
          optionsSelected.value = List.from(optionsSelected.value);
        },
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: checkboxes,
      ),
    );

    // final wid = Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: checkboxes,
    // );
    // return wid;
  }
}

int returnOptionSize(List option) {
  int cnt = 0;

  for (int i = 0; i < option.length; ++i) {
    if (option[i] != "") {
      ++cnt;
    }
  }
  return cnt;
}
