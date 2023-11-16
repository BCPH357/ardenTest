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

class ProductionBody extends StatelessWidget {
  const ProductionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final List<Map<String, String>> tableData = [
      {
        '頁次': '1',
        '客戶品號': 'X875941',
        '品號': 'A13241',
        '預計產量': '100',
        '製令單別': '3',
        '製令單號' : "H439709234",
        '品名': '刀頭',
        '規格': 'ABC',
        '備註': '無備註',
      },
      {
        '頁次': '2',
        '客戶品號': 'X87dsg41',
        '品號': 'A13fds41',
        '預計產量': '1000',
        '製令單別': '2',
        '製令單號' : "H439709fdsf34",
        '品名': '刀頭',
        '規格': 'ABC',
        '備註': '無備註',
      },
      {
        '頁次': '3',
        '客戶品號': 'X87d45sg41',
        '品號': 'A13f435s41',
        '預計產量': '190',
        '製令單別': '7',
        '製令單號' : "H4d09fdsf34",
        '品名': '刀頭',
        '規格': 'ABC',
        '備註': '無備註',
      },
      {
        '頁次': '4',
        '客戶品號': 'X87dsfg41',
        '品號': 'A323fds41',
        '預計產量': '10',
        '製令單別': '5',
        '製令單號' : "G4300fdsf34",
        '品名': '刀頭',
        '規格': 'ABC',
        '備註': '無備註',
      },
      // 可以继续添加更多数据行
    ];

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
                            "客戶號123456",
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
                            "發圖日: 112/09/08",
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
                            "完成日: 112/09/08",
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
                  width: 1500,
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
                  margin: const EdgeInsets.only(left: 15, right: 15, bottom: 13, top: 20),
                  padding: EdgeInsets.only(bottom: 15),
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(
                              label: Text(
                                '頁次',
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                          ),
                          DataColumn(
                              label: Text(
                                '客戶品號',
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                          ),
                          DataColumn(
                              label: Text(
                                '品號',
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                          ),
                          DataColumn(
                              label: Text(
                                '預計產量',
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                          ),
                          DataColumn(
                              label: Text(
                                '製令單別',
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                          ),
                          DataColumn(
                              label: Text(
                                '製令單號',
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                          ),
                          DataColumn(
                              label: Text(
                                '品名',
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                          ),
                          DataColumn(
                              label: Text(
                                '規格',
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                          ),
                          DataColumn(
                              label: Text(
                                '備註',
                                style: TextStyle(
                                  color: Color(0xFFEFB818),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                          ),
                        ],
                        rows: tableData.asMap().entries.map((entry) {
                          final rowIndex = entry.key;
                          final rowData = entry.value;

                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                              return getRowColor(rowIndex);
                            }),
                            cells: <DataCell>[
                              DataCell(
                                Text(
                                  rowData['頁次']!,
                                  style: TextStyle(
                                    color: rowIndex.isOdd ? Colors.black : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  rowData['客戶品號']!,
                                  style: TextStyle(
                                    color: rowIndex.isOdd ? Colors.black : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  rowData['品號']!,
                                  style: TextStyle(
                                    color: rowIndex.isOdd ? Colors.black : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  rowData['預計產量']!,
                                  style: TextStyle(
                                    color: rowIndex.isOdd ? Colors.black : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  rowData['製令單別']!,
                                  style: TextStyle(
                                    color: rowIndex.isOdd ? Colors.black : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DataCell(
                                InkWell(
                                  onTap: () {
                                    // 处理点击事件，您可以在这里执行所需的操作
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ControlChartPage(),
                                      ),
                                    );
                                    print('您点击了製令單號: ${rowData['製令單號']}');
                                  },
                                  child: Text(
                                    rowData['製令單號']!,
                                    style: TextStyle(
                                      color: rowIndex.isOdd ? Colors.black : Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  rowData['品名']!,
                                  style: TextStyle(
                                    color: rowIndex.isOdd ? Colors.black : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  rowData['規格']!,
                                  style: TextStyle(
                                    color: rowIndex.isOdd ? Colors.black : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  rowData['備註']!,
                                  style: TextStyle(
                                    color: rowIndex.isOdd ? Colors.black : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),

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
              // Container(
              //   width: 200,
              //   height: 50,
              //   margin: const EdgeInsets.only(left: 60),
              //   // margin: const EdgeInsets.only(left: 30),
              //   child: ElevatedButton.icon(
              //     onPressed: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(
              //             builder: (context) => const PdfPage(),
              //           )
              //       );
              //     },
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: Color(0xFF006CBA),
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(8.0))),
              //     icon: const Icon(
              //       Icons.close_outlined,
              //       size: 50,
              //     ), //icon data for elevated button
              //     label: const Text(
              //       "成品圖",
              //       style: TextStyle(
              //         fontSize: 30,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ), //label text
              //   ),
              // ),
              Container(
                width: 200,
                height: 50,
                margin: const EdgeInsets.only(right: 60, left: 60),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    navigator.pop(context);
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
  Color getRowColor(int rowIndex) {
    return rowIndex % 2 == 0 ? Color(0xFF285357) : Color(0xFF8b896e); // 偶数行使用浅蓝色，奇数行使用白色
  }
}
