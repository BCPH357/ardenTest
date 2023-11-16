import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';

List<String> _options = [
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
int numOfOption = returnOptionSize(_options);
int numOfColumn = numOfOption % 6 == 0
    ? (numOfOption / 6).toInt()
    : (numOfOption / 6).toInt() + 1;
int blank = 6 - (numOfOption % 6);

class OutsourcingStationList extends StatelessWidget {
  OutsourcingStationList({super.key});

  //Loading counter value on start
  List<int> selectList = [];

  Future<void> loadPList(List<String> input) async {
    for (int i = 0; i < _options.length; i++) {
      if (i < input.length) {
        _options[i] = input[i];
      } else {
        _options[i] = "";
      }
    }
  }

  //initializing all options value to false.
  //when we want to know which options are selected by us we can check the List that's value are true.
  //The type(ValueNotifier) be used to listen user's operation.
  final ValueNotifier<List<bool>> _optionsSelected =
      ValueNotifier(List<bool>.generate(_options.length, (int index) => false));

  // show the outcome.
  final ValueNotifier<String> _text = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
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
                                        index * 6);
                                  } else {
                                    return _optionsSelectionBuilder(context,
                                        hobbiesSelected, child, 0, index * 6);
                                  }
                                },
                                valueListenable: _optionsSelected,
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
                      Navigator.pop(context);
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
                      final checkList = selectionIndex(_optionsSelected);
                      if (checkList.isEmpty) {
                        showErrorAlertDialog(context, "請選擇外包製程");
                      } else if (checkList.length == 1) {
                        Provider.of<UserInfo>(context, listen: false)
                            .setSelectP(selectList);
                        showFinishAlertDialog(context,
                            "選擇的製程：\n${userInfo.selectList.toString()}");
                      } else {
                        showErrorAlertDialog(context, "僅單選");
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
  List<int> selectionIndex(ValueNotifier<List<bool>> input) {
    for (int i = 0; i < input.value.length; ++i) {
      if (input.value[i]) {
        selectList.add(i);
      }
    }
    return selectList;
  }

  //_optionsSelectionBuilder1 to 5 are fix option column for example _optionsSelectionBuilder1 means column1 and so on.
  //this function is use by a builder so you shouldn't add () when you using this function.
  //the reason for _optionsSelectionBuilder1 to 5 are defined individually is that function be used can't receive arguments.
  Widget _optionsSelectionBuilder(BuildContext context,
      List<bool> hobbiesSelected, Widget? child, int blank, int startIndex) {
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

int returnOptionSize(List option) {
  int cnt = 0;

  for (int i = 0; i < option.length; ++i) {
    if (option[i] != "") {
      ++cnt;
    }
  }
  return cnt;
}

// Show AlertDialog
showFinishAlertDialog(BuildContext context, String text) {
  // Init
  AlertDialog dialog = AlertDialog(
    title: Text(
      text,
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
            Navigator.pop(context);
            Navigator.pop(context);
          }),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );

  // Show the dialog (showDialog() => showGeneralDialog())
  showGeneralDialog(
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Wrap();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform(
        transform: Matrix4.translationValues(
          0.0,
          (1.0 - Curves.easeInOut.transform(anim1.value)) * 400,
          0.0,
        ),
        child: dialog,
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

// Show AlertDialog
showErrorAlertDialog(BuildContext context, String text) {
  // Init
  AlertDialog dialog = AlertDialog(
    title: Text(
      text,
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
            Navigator.pop(context);
          }),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );

  // Show the dialog (showDialog() => showGeneralDialog())
  showGeneralDialog(
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Wrap();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform(
        transform: Matrix4.translationValues(
          0.0,
          (1.0 - Curves.easeInOut.transform(anim1.value)) * 400,
          0.0,
        ),
        child: dialog,
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}
