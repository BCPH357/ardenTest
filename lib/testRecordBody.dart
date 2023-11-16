import 'dart:async';
import 'dart:math' as math;

import 'package:arden/alertDialog.dart';
import 'package:arden/http.dart';
import 'package:arden/pdfPage.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'controlChartPage.dart';
import 'mult_provider.dart';

class TestRecordBody extends StatelessWidget {
  const TestRecordBody({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    int batch = 450;
    int ratio = 15;
    int sample_quantity_int = (batch / ratio).toInt();

    final List<String> buttonNamesFirst = [
      "車床",
      "铣床",
      "攻牙",
      "成品A",
      "成品B",
      "車床",
      "铣床",
      "攻牙",
      "成品A",
      "成品B",
      "車床",
      "铣床",
      "攻牙",
      "成品A",
      "成品B",
    ];
    final List<String> buttonNamesSecond = [
      "總長",
      "總刀長",
      "底徑",
      "角度",
      "凹R",
      "總長",
      "總刀長",
      "底徑",
      "角度",
      "凹R",
      "總長",
      "總刀長",
      "底徑",
      "角度",
      "凹R",
    ];

    final List<String> textFieldNames = fillTextFieldTitle(sample_quantity_int);


    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 將主軸對齊方式更改為居中
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 250,
                        // height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0XFF424E52),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 4,
                                offset: Offset(1, 8), // Shadow position
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "客戶編號123456",
                              style: TextStyle(
                                color: Color(0xFFEFB818),
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ),
                      Container(
                        width: 250,
                        // height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0XFF424E52),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 4,
                              offset: Offset(1, 8), // Shadow position
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "訂單編號123456",
                            style: TextStyle(
                              color: Color(0xFFEFB818),
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        // height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0XFF424E52),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 4,
                              offset: Offset(1, 8), // Shadow position
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "批量: $batch",
                            style: TextStyle(
                              color: Color(0xFFEFB818),
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250,
                        // height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0XFF424E52),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 4,
                              offset: Offset(1, 8), // Shadow position
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "抽檢數量: $sample_quantity_int",
                            style: TextStyle(
                              color: Color(0xFFEFB818),
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  // width: 1500,
                  decoration: BoxDecoration(
                    color: const Color(0XFF424E52),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 4,
                        offset: Offset(1, 8),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 20),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: buttonNamesFirst.map((name) {
                          return Container(
                            width: 200,
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {

                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0))),
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ), //label text
                              )
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  // width: 1500,
                  decoration: BoxDecoration(
                    color: const Color(0XFF424E52),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 4,
                        offset: Offset(1, 8),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(left: 15, right: 15, bottom: 13,),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: buttonNamesSecond.map((name) {
                          return Container(
                            width: 200,
                            height: 80,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF8b896e),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0))),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ), //label text
                                )
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  // width: 1500,
                  decoration: BoxDecoration(
                    color: const Color(0XFF424E52),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 4,
                        offset: Offset(1, 8),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(left: 15, right: 15, bottom: 13,),
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // 设置水平滚动
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              spacing: 10.0, // 两个文本框之间的水平间距
                              runSpacing: 10.0, // 两行之间的垂直间距
                              children: textFieldNames.take(textFieldNames.length ~/ 2).map((name) {
                                return Container(
                                  padding: EdgeInsets.only(bottom: 10, top: 10),
                                  margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                  width: MediaQuery.of(context).size.width / 9,
                                  child: TextField(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: name,
                                      labelStyle: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFFEFB818),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.always, // 让labelText一直浮动在上方
                                        enabledBorder: OutlineInputBorder( // 添加边框样式
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Colors.white, // 边框颜色
                                          width: 4.0, // 边框宽度
                                        ), // 边框颜色
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),// 获取焦点时的边框样式
                                        borderSide: BorderSide(
                                          color: Colors.blue, // 边框颜色
                                          width: 4.0, // 边框宽度
                                        ),
                                      ),
                                    ),
                                  )
                                );
                              }).toList(),
                            ),
                            Wrap(
                              spacing: 10.0, // 两个文本框之间的水平间距
                              runSpacing: 10.0, // 两行之间的垂直间距
                              children: textFieldNames.skip(textFieldNames.length ~/ 2).map((name) {
                                return Container(
                                  margin: const EdgeInsets.only(left: 10, right: 10),
                                  width: MediaQuery.of(context).size.width / 9,
                                  child: TextField(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: name,
                                      labelStyle: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFFEFB818),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.always, // 让labelText一直浮动在上方
                                      enabledBorder: OutlineInputBorder( // 添加边框样式
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: Colors.white, // 边框颜色
                                          width: 4.0, // 边框宽度
                                        ), // 边框颜色
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),// 获取焦点时的边框样式
                                        borderSide: BorderSide(
                                          color: Colors.blue, // 边框颜色
                                          width: 4.0, // 边框宽度
                                        ),
                                      ),
                                    ),
                                  )
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                  ),
                ),
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
                child: ElevatedButton.icon(
                  onPressed: () async {
                    navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3BBA00),
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
                margin: const EdgeInsets.only(right: 60, left: 60),
                // margin: const EdgeInsets.only(left: 30),
                child: ElevatedButton.icon(
                  onPressed: () {
                    navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF006CBA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  icon: const Icon(
                    Icons.file_download_done_outlined,
                    size: 50,
                  ), //icon data for elevated button
                  label: const Text(
                    "儲存",
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
  Color getRowColor(int rowIndex) {
    return rowIndex % 2 == 0 ? Color(0xFF285357) : Color(0xFF8b896e); // 偶数行使用浅蓝色，奇数行使用白色
  }

  List<String> fillTextFieldTitle(int num) {
    List<String> output = [];
    for (int i = 0; i < num; ++i) {
      output.add("抽檢數${i + 1}");
    }
    return output;
  }
}
