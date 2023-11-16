import 'dart:async';
import 'dart:math' as math;

import 'package:arden/alertDialog.dart';
import 'package:arden/http.dart';
import 'package:arden/messageBoardPage.dart';
import 'package:arden/pdfPage.dart';
import 'package:arden/supervisorHomePage.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';

class ControlChartBody extends StatelessWidget {
  const ControlChartBody({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final workOrderInfo = Provider.of<WorkOrderInfo>(context);
    final loginInfo = Provider.of<LoginInfo>(context, listen: false);
    final dartHttpUtils = DartHttpUtils();
    List<String> dataList = [
      "車床", "車床", "車床", "車床車床", "車車床",
      "車床", "車床", "車床", "車床車床", "車車床",
    ];
    dataList = preSring(dataList);
    List<List<int>> dotList = [
      [0, 0], [0, 0], [0, 95],
      [45, 45], [28, 29], [20, 20],
      [15, 15], [11, 15], [9, 11],
      [7, 11], [6, 7], [5, 5],
      [4, 5], [0, 0], [0, 0],
      [0, 0], [0, 0], [0, 0],
      [0, 0], [0, 0], [0, 0],
      [0, 0],
    ];
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  // height: 100,
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
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 將主軸對齊方式更改為居中
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 將裡面的Row水平對齊方式更改為居中
                          children: <Widget>[
                            Container(
                              ///text middle
                              alignment: Alignment.center,
                              child: const Text(
                                "生產流程品質管制表",
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 42,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 100, right: 250),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  ///text middle
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "客戶代號",
                                        style: TextStyle(
                                          color: Color(0xFFEFB818),
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Text(
                                          fillSpace(6, "200支"),
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.white, // 文本颜色
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  ///text middle
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "訂單數量",
                                        style: TextStyle(
                                          color: Color(0xFFEFB818),
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Text(
                                          fillSpace(6, "200支"),
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.white, // 文本颜色
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  ///text middle
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "刀具編號",
                                        style: TextStyle(
                                          color: Color(0xFFEFB818),
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Text(
                                          fillSpace(6, "200支"),
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.white, // 文本颜色
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  ///text middle
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "訂單頁次",
                                        style: TextStyle(
                                          color: Color(0xFFEFB818),
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10, right: 15), // 设置内边距
                                        margin: EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0), // 圆角边框
                                          border: Border.all(
                                            color: Colors.black, // 外框颜色
                                            width: 2.0, // 外框宽度
                                          ),
                                          color: Colors.white, // 背景颜色
                                        ),
                                        // child: Text(
                                        //   fillSpace(24, "200支"),
                                        //   style: TextStyle(
                                        //     fontSize: 32,
                                        //     color: Colors.black, // 文本颜色
                                        //   ),
                                        // ),
                                        child: Container(
                                            width: 160,
                                            height: 50,
                                            padding: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white, // 白色背景
                                              borderRadius: BorderRadius.circular(15.0), // 圆角边框
                                            ),
                                            child: Container(
                                              // height: 60,
                                              // padding: const EdgeInsets.only(left: 15),
                                              child: TextField(
                                                style: TextStyle(
                                                  color: Colors.black, // 文本颜色
                                                  fontSize: 32,
                                                  // fontWeight: FontWeight.w500,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: '200支',
                                                  hintStyle: TextStyle(
                                                    fontSize: 32, // 调整hintText的字体大小
                                                  ),
                                                  border: InputBorder.none, //
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    borderSide: BorderSide(
                                                      color: Colors.white, // 边框颜色
                                                      width: 4.0, // 边框宽度
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // margin: const EdgeInsets.only(right: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  ///text middle
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "訂單編號",
                                        style: TextStyle(
                                          color: Color(0xFFEFB818),
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Text(
                                          fillSpace(6, "200支"),
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.white, // 文本颜色
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  ///text middle
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "發圖日期",
                                        style: TextStyle(
                                          color: Color(0xFFEFB818),
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Text(
                                          fillSpace(6, "200支"),
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.white, // 文本颜色
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  ///text middle
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "完成日期",
                                        style: TextStyle(
                                          color: Color(0xFFEFB818),
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Text(
                                          fillSpace(6, "200支"),
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.white, // 文本颜色
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  ///text middle
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "印柄樣式",
                                        style: TextStyle(
                                          color: Color(0xFFEFB818),
                                          fontSize: 32,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10, right: 15), // 设置内边距
                                        margin: EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0), // 圆角边框
                                          border: Border.all(
                                            color: Colors.black, // 外框颜色
                                            width: 2.0, // 外框宽度
                                          ),
                                          color: Colors.white, // 背景颜色
                                        ),
                                        // child: Text(
                                        //   fillSpace(24, "200支"),
                                        //   style: TextStyle(
                                        //     fontSize: 32,
                                        //     color: Colors.black, // 文本颜色
                                        //   ),
                                        // ),
                                        child: Container(
                                            width: 160,
                                            height: 50,
                                            padding: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white, // 白色背景
                                              borderRadius: BorderRadius.circular(15.0), // 圆角边框
                                            ),
                                            child: Container(
                                              // height: 60,
                                              // padding: const EdgeInsets.only(left: 15),
                                              child: TextField(
                                                style: TextStyle(
                                                  color: Colors.black, // 文本颜色
                                                  fontSize: 32,
                                                  // fontWeight: FontWeight.w500,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: '200支',
                                                  hintStyle: TextStyle(
                                                    fontSize: 32, // 调整hintText的字体大小
                                                  ),
                                                  border: InputBorder.none, //
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    borderSide: BorderSide(
                                                      color: Colors.white, // 边框颜色
                                                      width: 4.0, // 边框宽度
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        ///text middle
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 10, left: 100),
                        child: Row(
                          children: [
                            const Text(
                              "備        註",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Color(0xFFEFB818),
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 12, right: 15), // 设置内边距
                              margin: EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0), // 圆角边框
                                border: Border.all(
                                  color: Colors.black, // 外框颜色
                                  width: 2.0, // 外框宽度
                                ),
                                color: Colors.white, // 背景颜色
                              ),
                              // child: Text(
                              //   fillSpace(24, "200支"),
                              //   style: TextStyle(
                              //     fontSize: 32,
                              //     color: Colors.black, // 文本颜色
                              //   ),
                              // ),
                              child: Container(
                                  width: 730,
                                  height: 50,
                                  padding: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white, // 白色背景
                                    borderRadius: BorderRadius.circular(15.0), // 圆角边框
                                  ),
                                  child: Container(
                                    // height: 60,
                                    // padding: const EdgeInsets.only(left: 15),
                                    child: TextField(
                                      style: TextStyle(
                                        color: Colors.black, // 文本颜色
                                        fontSize: 32,
                                        // fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '200支',
                                        hintStyle: TextStyle(
                                          fontSize: 32, // 调整hintText的字体大小
                                        ),
                                        border: InputBorder.none, //
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          borderSide: BorderSide(
                                            color: Colors.white, // 边框颜色
                                            width: 4.0, // 边框宽度
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 127,
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
                  margin: const EdgeInsets.only(left: 15, right: 15, bottom: 13),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        // color: Colors.grey,
                        margin: const EdgeInsets.only(left: 29, right: 29),
                        child: dataList.isEmpty
                            ? Center(
                          // 当dataList为空时，显示消息
                          child: Text(
                            "没有数据",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        )
                            : dataList.length == 1
                            ? Center(
                          // 当dataList只有一个元素时，显示单个元素
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              dataList.first,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        )
                            : Row(
                          children: <Widget>[
                            // 头部元素
                            Container(
                              height: 105,
                              padding: EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFEFB818),
                                border: Border.all(color: Color(0xFFEFB818)),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                dataList.first,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // 中间元素，使用Expanded来均匀分布
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  int numberOfDots = (constraints.maxWidth / 50).floor();
                                  print(constraints.maxWidth);
                                  // 中间元素，使用Expanded来均匀分布
                                  return dataList.length < 13 ? Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: dataList
                                        .getRange(1, dataList.length - 1)
                                        .map((item) {
                                      return Row(
                                        children: [
                                          for (int i = 0; i < dotList[dataList.length][0]; ++i)
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Container(
                                            height: 105,
                                            padding: EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
                                            margin: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFEFB818),
                                              border: Border.all(color: Color(0xFFEFB818)),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),

                                  )
                                    : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: dataList
                                        .getRange(1, dataList.length - 1)
                                        .map((item) {
                                      return Row(
                                        children: [
                                          Container(
                                            height: 105,
                                            padding: EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
                                            margin: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFEFB818),
                                              border: Border.all(color: Color(0xFFEFB818)),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),

                                  );

                                },
                              ),
                            ),
                            for (int i = 0; i < dotList[dataList.length][1]; ++i)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            // 尾部元素
                            Container(
                              height: 105,
                              padding: EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF7eb300),
                                border: Border.all(color: Color(0xFF7eb300)),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                dataList.last,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
        //bottom Bar
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
          // margin: const EdgeInsets.only(top: 60),
          // padding: const EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[

              Container(
                width: 200,
                height: 50,
                margin: const EdgeInsets.only(left: 60),
                // margin: const EdgeInsets.only(left: 30),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => const MessageBoardPage(),
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEE7700),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  icon: const Icon(
                    Icons.ad_units_sharp,
                    size: 50,
                  ), //icon data for elevated button
                  label: const Text(
                    "留言板",
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
                margin: const EdgeInsets.only(left: 60),
                // margin: const EdgeInsets.only(left: 30),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => const PdfPage(),
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF006CBA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  icon: const Icon(
                    Icons.close_outlined,
                    size: 50,
                  ), //icon data for elevated button
                  label: const Text(
                    "成品圖",
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
                margin: const EdgeInsets.only(right: 60, left: 60),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                          builder: (context) => const SupervisorHomePage(),
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3BBA00),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  icon: const Icon(
                    Icons.file_download_done_outlined,
                    size: 50,
                  ), //icon data for elevated button
                  label: const Text(
                    "主畫面",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ), //label text
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  String fillSpace(int num, String input) {
    int spaceNum =  num - input.length;
    if (spaceNum < 0) {
      return input;
    }
    else {
      for (int i = 0; i < spaceNum * 4; ++i) {
        input += " ";
      }
      return input;
    }
  }

  List<String> preSring(List<String> input) {
    for (int i = 0; i < input.length; ++i) {
      if (input[i].length == 2) {
        String firstWord = input[i][0];
        String secondWord = input[i][1];
        input[i] = "$firstWord\n\n\n$secondWord";
      }
      if (input[i].length == 3) {
        String firstWord = input[i][0];
        String secondWord = input[i][1];
        String thirdWord = input[i][2];
        input[i] = "$firstWord\n$secondWord\n\n$thirdWord";
      }
      if (input[i].length == 4) {
        String firstWord = input[i][0];
        String secondWord = input[i][1];
        String thirdWord = input[i][2];
        String forthWord = input[i][3];
        input[i] = "$firstWord\n$secondWord\n$thirdWord\n$forthWord";
      }
    }
    return input;
  }
}
