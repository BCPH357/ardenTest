import 'package:arden/alertDialog.dart';
import 'package:arden/http.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';

class ResumeWork extends StatelessWidget {
  ResumeWork({super.key});

  //Loading counter value on start
  List selectList = [];

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final workOrderInfo = Provider.of<WorkOrderInfo>(context);
    final loginInfo = Provider.of<LoginInfo>(context, listen: false);
    final dartHttpUtils = DartHttpUtils();

    int numOfOption = returnOptionSize(workOrderInfo.order_options);
    int numOfColumn = numOfOption % 5 == 0
        ? (numOfOption / 5).toInt()
        : (numOfOption / 5).toInt() + 1;
    int blank = numOfOption % 5 == 0 ? 0 : 5 - (numOfOption % 5);

    //initializing all options value to false.
    //when we want to know which options are selected by us we can check the List that's value are true.
    //The type(ValueNotifier) be used to listen user's operation.
    final ValueNotifier<List<bool>> optionsSelected = ValueNotifier(
        List<bool>.generate(
            workOrderInfo.order_options.length, (int index) => false));

    // show the outcome.
    final ValueNotifier<String> _text = ValueNotifier('');

//Loading counter value on start

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
              margin: const EdgeInsets.only(top: 46.3),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 970,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 50, left: 50, right: 80),
                        color: const Color(0XFF424E52),
                        // color: Colors.orange,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(numOfColumn, (index) {
                            //if (index == )
                            return Container(
                              width: 450,
                              child: ValueListenableBuilder<List<bool>>(
                                // builder: selectionColumns[index],
                                builder: (context, hobbiesSelected, child) {
                                  if (index == numOfColumn - 1) {
                                    return _optionsSelectionBuilder(
                                        context,
                                        hobbiesSelected,
                                        child,
                                        blank,
                                        index * 5,
                                        workOrderInfo.order_options,
                                        optionsSelected);
                                  } else {
                                    return _optionsSelectionBuilder(
                                        context,
                                        hobbiesSelected,
                                        child,
                                        0,
                                        index * 5,
                                        workOrderInfo.order_options,
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
              top: 15,
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
                      navigator.pop(context);
                      print(blank);
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
                      final res = await dartHttpUtils.resumeAction(
                          navigator, workOrderInfo, loginInfo, workOrderInfo.order_list);
                      if (res == 'success') {
                        showAlertDialog(
                            navigator, setPop3AlertDialog(navigator, '復工成功'));
                      } else {
                        showAlertDialog(
                            navigator, setPop1AlertDialog(navigator, res));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3BBA00),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    icon: const Icon(
                      Icons.play_arrow_outlined,
                      size: 50,
                    ), //icon data for elevated button
                    label: const Text(
                      "全部復工",
                      style: TextStyle(
                        fontSize: 26,
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
                      selectionIndex(optionsSelected, workOrderInfo);
                      // showAlertDialog(context, checkList.toString());
                      if (selectList.isEmpty) {
                        showAlertDialog(
                            navigator, setPop1AlertDialog(navigator, "請選擇製令"));
                      } else {
                        workOrderInfo.setSelectList(selectList);
                        final res = await dartHttpUtils.resumeAction(
                            navigator, workOrderInfo, loginInfo, workOrderInfo.selectList);
                        if (res == 'success') {
                          showAlertDialog(
                              navigator, setPop3AlertDialog(navigator, '復工成功'));
                        } else {
                          showAlertDialog(
                              navigator, setPop1AlertDialog(navigator, res));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3BBA00),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    icon: const Icon(
                      Icons.play_arrow_outlined,
                      size: 50,
                    ), //icon data for elevated button
                    label: const Text(
                      "復工",
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
    selectList.clear();
    for (int i = 0; i < input.value.length; ++i) {
      if (input.value[i]) {
        selectList.add(workOrderInfo.order_list[i]);
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
    for (var i = startIndex; i < startIndex + 5 - blank; i++) {
      checkboxes.add(CheckboxListTile(
        // isThreeLine: true,
        side: const BorderSide(
          // ======> CHANGE THE BORDER COLOR HERE <======
          color: Colors.white,
          // Give your checkbox border a custom width
          width: 2,
        ),
        title: Text(
          options[i],
          style: const TextStyle(
            fontSize: 30,
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

    final wid = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: checkboxes,
    );
    return wid;
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
