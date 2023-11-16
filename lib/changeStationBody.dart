import 'package:arden/alertDialog.dart';
import 'package:arden/changeStationListPage.dart';
import 'package:arden/http.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mult_provider.dart';

class ChangeStation extends StatelessWidget {
  const ChangeStation({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final workOrderInfo = Provider.of<WorkOrderInfo>(context);
    final loginInfo = Provider.of<LoginInfo>(context, listen: false);
    final dartHttpUtils = DartHttpUtils();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 450,
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
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: <Widget>[
                              Container(
                                ///text middle
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "製令 M",
                                  style: TextStyle(
                                    color: Color(0xFFEFB818),
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                ///text middle
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(left: 20),
                                // padding: const EdgeInsets.only(left: 10,),
                                // decoration: BoxDecoration(
                                //   color: const Color(0xFF878787),
                                //   borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                //   border: Border.all(width: 1,),
                                // ),
                                child: Text(
                                  workOrderInfo.info_order_id,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(right: 10),

                                ///text middle
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "客戶 C",
                                  style: TextStyle(
                                    color: Color(0xFFEFB818),
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                ///text middle
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(left: 20),
                                // padding: const EdgeInsets.only(left: 10,),
                                // decoration: BoxDecoration(
                                //   color: const Color(0xFF878787),
                                //   borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                //   border: Border.all(width: 1,),
                                // ),
                                child: Text(
                                  workOrderInfo.info_customer_id,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: <Widget>[
                              Container(
                                ///text middle
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "品號  I",
                                  style: TextStyle(
                                    color: Color(0xFFEFB818),
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                ///text middle
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(left: 35),
                                // padding: const EdgeInsets.only(left: 10,),
                                width: 500,
                                // decoration: BoxDecoration(
                                //   color: const Color(0xFF878787),
                                //   borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                //   border: Border.all(width: 1,),
                                // ),
                                child: Text(
                                  workOrderInfo.info_item_id,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: <Widget>[
                              Container(
                                ///text middle
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "總量 Q",
                                  style: TextStyle(
                                    color: Color(0xFFEFB818),
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                ///text middle
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(left: 30),
                                // padding: const EdgeInsets.only(left: 10,),
                                // decoration: BoxDecoration(
                                //   color: const Color(0xFF878787),
                                //   borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                //   border: Border.all(width: 1,),
                                // ),
                                child: Text(
                                  "${workOrderInfo.info_order_qty}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Row(
                            children: <Widget>[
                              Container(
                                ///text middle
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "批量 B",
                                  style: TextStyle(
                                    color: Color(0xFFEFB818),
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                ///text middle
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(left: 30),
                                // padding: const EdgeInsets.only(left: 10,),
                                // decoration: BoxDecoration(
                                //   color: const Color(0xFF878787),
                                //   borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                //   border: Border.all(width: 1,),
                                // ),
                                child: Text(
                                  "${workOrderInfo.info_batch_qty}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 420,
                  width: 400,
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
                  margin: const EdgeInsets.only(right: 15, top: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: const Text(
                          "換站 S",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15, bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 4,
                              offset: Offset(1, 8), // Shadow position
                            ),
                          ],
                        ),
                        width: 200.0,
                        height: 70.0,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangeStationListPage()));
                          },
                          style: ElevatedButton.styleFrom(
                              // backgroundColor: const Color(0xFF3D75CA),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0))),
                          //icon data for elevated button
                          child: const Text(
                            "選擇製程",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ), //label text
                        ),
                      ),
                      for (int i = 0; i < workOrderInfo.selectList.length; ++i)
                        Container(
                          // text middle
                          alignment: const Alignment(0, 0),
                          margin: const EdgeInsets.only(right: 35, bottom: 15),
                          height: 70,
                          width: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFF878787),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            border: Border.all(
                              width: 1,
                            ),
                          ),
                          child: Text(
                            workOrderInfo.selectList[i]['process_name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 93.4,
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
              width: 1.5,
              color: Color(0XFF333D40),
            )),
            color: Color(0XFF333D40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 200,
                height: 50,
                margin: const EdgeInsets.only(left: 60),
                child: ElevatedButton.icon(
                  onPressed: () {
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
                margin: const EdgeInsets.only(right: 60),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (workOrderInfo.selectList.isNotEmpty) {
                      final res = await dartHttpUtils.switchAction(
                          navigator, workOrderInfo, loginInfo);
                      if (res == 'success') {
                        showAlertDialog(
                            navigator, setPop3AlertDialog(navigator, '換站成功'));
                      } else {
                        showAlertDialog(
                            navigator, setPop1AlertDialog(navigator, res));
                      }
                    } else {
                      showAlertDialog(navigator,
                          setPop1AlertDialog(navigator, "警告!\n請選擇製程"));
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
          ),
        ),
      ],
    );
  }
}
