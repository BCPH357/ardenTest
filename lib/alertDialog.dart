import 'dart:convert';

import 'package:arden/supervisorHomePage.dart';
import 'package:flutter/material.dart';

import 'http.dart';
import 'inStationPage.dart';
import 'mult_provider.dart';

// class ShowAlertDialog{
//   String text = '';
//   setDialogText(String str){
//     text = str;
//   }
//   setErrorAlertDialog(navigator, String text) {
//     // Init
//     AlertDialog dialog = AlertDialog(
//       title: Text(
//         text,
//         style: const TextStyle(
//           height: 2,
//           fontSize: 52,
//           letterSpacing: 5,
//         ),
//       ),
//       titlePadding: const EdgeInsets.fromLTRB(70, 20, 70, 10),
//       buttonPadding: const EdgeInsets.symmetric(horizontal: 10.0),
//       backgroundColor: Colors.white,
//       // 背景色
//       elevation: 10,
//       // 阴影高度
//       actions: [
//         ElevatedButton(
//             child: const Text(
//               "確認",
//               style: TextStyle(
//                 fontSize: 40,
//                 letterSpacing: 5,
//               ),
//             ),
//             onPressed: () {
//               navigator.pop();
//             }),
//       ],
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20))),
//     );
//
//     return dialog;
//   }
// }

reDoCheckToAction(String orderID, String options, WorkOrderInfo workOrderInfo,
    LoginInfo loginInfo, BuildContext context) async {
  final navigator = Navigator.of(context);
  final dartHttpUtils = DartHttpUtils();
  final res = await dartHttpUtils.reDoCheck(
      orderID, options, navigator, workOrderInfo, loginInfo);
  if (res == 'rework') {
    var reason = workOrderInfo.info_rework_reason;
    if (reason != null) {
      final jsonBody = json.decode(reason);
      if (jsonBody['reason'] != null) {
        print(jsonBody);
        // Init
        AlertDialog dialog = AlertDialog(
          title: Text(
            '此工單為整修單，原因如下：\n${jsonBody['reason']}',
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
                  navigator.pop();
                  navigator.push(MaterialPageRoute(
                      builder: (context) => const InStationPage()));
                }),
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        );
        showAlertDialog(navigator, dialog);
      } else {
        navigator.push(
            MaterialPageRoute(builder: (context) => const InStationPage()));
      }
    }
  } else if (res != 'success') {
    showAlertDialog(navigator, setPop1AlertDialog(navigator, res));
  }
}

doCheckToAction(String orderID, String options, WorkOrderInfo workOrderInfo,
    LoginInfo loginInfo, BuildContext context) async {
  final navigator = Navigator.of(context);
  final dartHttpUtils = DartHttpUtils();
  final res = await dartHttpUtils.doCheck(
      orderID, options, navigator, workOrderInfo, loginInfo);
  if (res == 'rework') {
    var reason = workOrderInfo.info_rework_reason;
    if (reason != null) {
      final jsonBody = json.decode(reason);
      if (jsonBody['reason'] != null) {
        print(jsonBody);
        // Init
        AlertDialog dialog = AlertDialog(
          title: Text(
            '此工單為整修單，原因如下：\n${jsonBody['reason']}',
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
                  navigator.pop();
                  navigator.push(MaterialPageRoute(
                      builder: (context) => const InStationPage()));
                }),
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        );
        showAlertDialog(navigator, dialog);
      } else {
        navigator.push(
            MaterialPageRoute(builder: (context) => const InStationPage()));
      }
    }
  } else if (res != 'success') {
    showAlertDialog(navigator, setPop1AlertDialog(navigator, res));
  }
}

setPop1CancelAlertDialog(
    navigator, String text, Function() toDo, Function() cToDo) {
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
            "取消",
            style: TextStyle(
              fontSize: 40,
              letterSpacing: 5,
            ),
          ),
          onPressed: () {
            navigator.pop();
            cToDo();
          }),
      ElevatedButton(
          child: const Text(
            "確認",
            style: TextStyle(
              fontSize: 40,
              letterSpacing: 5,
            ),
          ),
          onPressed: () {
            navigator.pop();
            toDo();
          }),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );

  return dialog;
}

setRePop1AlertDialog(navigator, String text) {
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
            navigator.pushReplacement(MaterialPageRoute(
                builder: (context) => const SupervisorHomePage()));
          }),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );

  return dialog;
}

String dialogReStr = 'no';
TextEditingController _textFieldController = TextEditingController();

inputOrderIDAlertDialog(navigator, workOrderInfo, loginInfo, options) {
  _textFieldController.clear();
  // Init
  AlertDialog dialog = AlertDialog(
    title: const Text(
      '請輸入製令',
      style: TextStyle(
        height: 2,
        fontSize: 35,
        letterSpacing: 5,
      ),
    ),
    content: TextField(
      controller: _textFieldController,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 10.0),
        hintStyle: TextStyle(
          color: Colors.black12,
          fontSize: 40,
          fontWeight: FontWeight.w500,
        ),
        hintText: "5101-12345678912",
      ),
      // cursorHeight: 40,
      strutStyle: const StrutStyle(
        fontSize: 40,
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
            "返回",
            style: TextStyle(
              fontSize: 40,
              letterSpacing: 5,
            ),
          ),
          onPressed: () {
            navigator.pop();
          }),
      ElevatedButton(
          child: const Text(
            "確認",
            style: TextStyle(
              fontSize: 40,
              letterSpacing: 5,
            ),
          ),
          onPressed: () {
            dialogReStr = _textFieldController.text;
            doCheckToAction(dialogReStr, options, workOrderInfo, loginInfo,
                navigator.context);
            navigator.pop();
          }),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );

  return dialog;
}

reInputOrderIDAlertDialog(text, navigator, workOrderInfo, loginInfo, options) {
  _textFieldController.clear();
  // Init
  AlertDialog dialog = AlertDialog(
    title: Text(
      '$text，請輸入下張$options製令',
      style: const TextStyle(
        height: 2,
        fontSize: 35,
        letterSpacing: 5,
      ),
    ),
    content: TextField(
      controller: _textFieldController,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w500,
      ),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 10.0),
        hintStyle: TextStyle(
          color: Colors.black12,
          fontSize: 40,
          fontWeight: FontWeight.w500,
        ),
        hintText: "5101-12345678912",
      ),
      // cursorHeight: 40,
      strutStyle: const StrutStyle(
        fontSize: 40,
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
            "返回",
            style: TextStyle(
              fontSize: 40,
              letterSpacing: 5,
            ),
          ),
          onPressed: () {
            navigator.pop();
          }),
      ElevatedButton(
          child: const Text(
            "確認",
            style: TextStyle(
              fontSize: 40,
              letterSpacing: 5,
            ),
          ),
          onPressed: () {
            dialogReStr = _textFieldController.text;
            reDoCheckToAction(dialogReStr, options, workOrderInfo, loginInfo,
                navigator.context);
            navigator.pop();
          }),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );

  return dialog;
}

setPop1AlertDialog(navigator, String text) {
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
            navigator.pop();
          }),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );

  return dialog;
}

setPop2AlertDialog(navigator, String text) {
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
            navigator.pop();
            navigator.pop();
          }),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );
  return dialog;
}

setPop3AlertDialog(navigator, String text) {
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
            navigator.pop();
            navigator.pop();
            navigator.pop();
          }),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );
  return dialog;
}

setDoAgainAlertDialog(navigator, String text, Function() scan) {
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
            navigator.pop();
            scan();
          }),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );
  return dialog;
}

showAlertDialog(navigator, dialog) {
  // Show the dialog (showDialog() => showGeneralDialog())
  showGeneralDialog(
    context: navigator.context,
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

waitHttpConnectionAlertDialog(navigator) {
  // Init
  AlertDialog dialog = const AlertDialog(
    title: Text(
      '等候網路回應',
      style: TextStyle(
        height: 2,
        fontSize: 52,
        letterSpacing: 5,
      ),
    ),
    titlePadding: EdgeInsets.fromLTRB(70, 20, 70, 10),
    buttonPadding: EdgeInsets.symmetric(horizontal: 10.0),
    backgroundColor: Colors.white,
    // 背景色
    elevation: 10,
    // 阴影高度
    actions: [],
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
  );

  return dialog;
}