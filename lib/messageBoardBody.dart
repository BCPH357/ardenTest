import 'package:flutter/material.dart';



class MessageBoardBody extends StatefulWidget {
  const MessageBoardBody({super.key});

  @override
  _MessageBoardBodyState createState() => _MessageBoardBodyState();
}

class _MessageBoardBodyState extends State<MessageBoardBody> {
  final List<String> buttonNames = [
    "A01", "A02", "A03", "A04", "A05", "A06", "A07", "A08", "A09", "A10",
    "A11", "A12", "A13", "A14", "A15", "A16", "A17", "A18", "A19", "A20", "A21"
  ];

  List<Map<String, String>> yourDataList = [
    {
      'time': '2023/02/25',
      'station': 'A01, A02',
      'content': '這裡是留言板內容這裡是留言板內容',
    },
    {
      'time': '2023/02/27',
      'station': 'A03',
      'content': '這裡是留言板內容這裡是留言板內容',
    },
    {
      'time': '2023/02/28',
      'station': 'A08',
      'content': '這裡是留言板內容這裡是留言板內容',
    },
    {
      'time': '2023/02/25',
      'station': 'A01, A02',
      'content': '這裡是留言板內容這裡是留言板內容',
    },
    {
      'time': '2023/02/27',
      'station': 'A03',
      'content': '這裡是留言板內容這裡是留言板內容',
    },
    {
      'time': '2023/02/28',
      'station': 'A08',
      'content': '這裡是留言板內容這裡是留言板內容',
    },
    // 添加更多数据项...
  ];

  TextEditingController _textEditingController = TextEditingController();
  List<String> selectedButtons = [];

  void toggleButton(String buttonText) {
    setState(() {
      if (selectedButtons.contains(buttonText)) {
        selectedButtons.remove(buttonText);
      } else {
        selectedButtons.add(buttonText);
      }
    });
  }

  bool isButtonSelected(String buttonText) {
    return selectedButtons.contains(buttonText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
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
                  padding: EdgeInsets.only(bottom: 10, top: 10,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Text(
                          "選擇站別",
                          style: TextStyle(
                            color: Color(0xFFEFB818),
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: buttonNames.map((name) {
                              return Container(
                                width: 150,
                                height: 80,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      toggleButton(name); // 切换按钮状态
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: isButtonSelected(name) ? Colors.blueGrey : Color(0xFF285357), // 根据按钮状态设置颜色
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        if (isButtonSelected(name))
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Row(
                          children: [
                            Container(
                                width: 900,
                                margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white, // 白色背景
                                  borderRadius: BorderRadius.circular(15.0), // 圆角边框
                                ),
                                child: Container(
                                  height: 60,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: TextField(
                                    controller: _textEditingController, // 設定controller
                                    style: TextStyle(
                                      color: Colors.black, // 文本颜色
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '請輸入留言',
                                      hintStyle: TextStyle(
                                        fontSize: 18, // 调整hintText的字体大小
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
                            Container(
                              width: 150,
                              height: 50,
                              margin: const EdgeInsets.only(left: 15),
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  // Add your action here
                                  print(selectedButtons);
                                  // Navigator.pop(context);
                                  Map<String, String> temp = {
                                    'time': '2023/02/25',
                                    'station': '',
                                    'content': '',
                                  };
                                  temp["station"] = selectButtonToString(selectedButtons);
                                  temp["content"] = _textEditingController.text;

                                  setState(() {
                                    yourDataList.add(temp);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF006CBA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.file_download_done_outlined,
                                  size: 30,
                                ),
                                label: const Text(
                                  "確認",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  )
                ),

                Container(
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
                  margin: const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: yourDataList.map((item) {
                        return Card(
                          color: Color(0XFF424E52),
                          child: Container(
                            width: 300, // 设置卡片的宽度
                            height: 200,
                            decoration: BoxDecoration(
                              color: Color(0xFF8b896e), // 修改卡片的背景颜色
                              borderRadius: BorderRadius.circular(20.0), // 圆角边框
                            ),
                            child: ListTile(
                              title: Text(
                                '站點: ${item['station']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   '時間: ${item['time']}',
                                  //   style: const TextStyle(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // ),
                                  SizedBox(height: 8), // 添加一些垂直间距
                                  Text(
                                    '內容: ${item['content']}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ), // 添加内容
                                ],
                              ),
                              // trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                // 处理卡片点击事件
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        // Bottom Bar
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 200,
                height: 50,
                margin: const EdgeInsets.only(right: 60, left: 60),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Add your action here
                    print(selectedButtons);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3BBA00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: const Icon(
                    Icons.file_download_done_outlined,
                    size: 50,
                  ),
                  label: const Text(
                    "主畫面",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color getRowColor(int rowIndex) {
    return rowIndex % 2 == 0 ? Color(0xFF285357) : Color(0xFF8b896e);
  }

  String selectButtonToString (List<String> input) {
    String output = "";

    for (int i = 0; i < input.length; ++i) {
      output += input[i];
      if (i != input.length - 1) {
        output += ", ";
      }
    }
    return output;
  }
 }
