import 'package:arden/student.dart';
import 'package:flutter/material.dart';

class InfoBody extends StatelessWidget {
  const InfoBody({super.key});

  @override
  Widget build(BuildContext context) {
    //http data future<list>
    Student studentService = Student();
    return Column(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: Container(
            // padding: const EdgeInsets.only(right: 300, left: 300),
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: FutureBuilder<List>(
                  future: studentService.getAllStudent(),
                  builder: (context, snapshot) {
                    print(snapshot.data);

                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          Table(
                            columnWidths: const <int, TableColumnWidth>{
                              //指定索引及固定列宽
                              0: FixedColumnWidth(389),
                              1: FixedColumnWidth(389),
                              2: FixedColumnWidth(389),
                              // 3: FixedColumnWidth(50),
                              // 4: FixedColumnWidth(50),
                              // 5: FixedColumnWidth(50),
                            },
                            //設定表格樣式
                            border: TableBorder.all(
                                color: Colors.grey,
                                width: 1.0,
                                style: BorderStyle.solid),
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 5, bottom: 5),
                                    child: const Text(
                                      "站別",
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 5, bottom: 5),
                                    child: const Text(
                                      "數量",
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 5, bottom: 5),
                                    child: const Text(
                                      "狀態",
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, i) {
                              return Container(
                                child: Table(
                                  columnWidths: const <int, TableColumnWidth>{
                                    //指定索引及固定列宽
                                    0: FixedColumnWidth(389),
                                    1: FixedColumnWidth(389),
                                    2: FixedColumnWidth(389),
                                    // 3: FixedColumnWidth(50),
                                    // 4: FixedColumnWidth(50),
                                    // 5: FixedColumnWidth(50),
                                  },
                                  //設定表格樣式
                                  border: TableBorder.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                      style: BorderStyle.solid),
                                  children: <TableRow>[
                                    TableRow(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, top: 5, bottom: 5),
                                          child: Text(
                                            snapshot.data![i]['articlenumber'],
                                            style: const TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, top: 5, bottom: 5),
                                          child: Text(
                                            snapshot.data![i]['name'],
                                            style: const TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, top: 5, bottom: 5),
                                          child: Text(
                                            snapshot.data![i]['day'],
                                            style: const TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('No Data Found'),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(left: 30),
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
                "cancel",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ), //label text
            ),
          ),
        ),
      ],
    );
  }
}
