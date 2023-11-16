import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PdfBody extends StatefulWidget {
  @override
  _PdfBodyState createState() => _PdfBodyState();
}

class _PdfBodyState extends State<PdfBody> {
  late String pdfPath;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    setState(() {
      isLoading = true;
    });

    final pdfAssetPath = 'assets/about.pdf'; // 替換成您的PDF文件在assets中的路徑
    final dir = await getApplicationDocumentsDirectory();
    final assetData = await rootBundle.load(pdfAssetPath);
    final pdfPath = '${dir.path}/about.pdf'; // 替換成您希望將PDF文件儲存到的路徑

    // print(pdfPath);
    final file = File(pdfPath);
    await file.writeAsBytes(assetData.buffer.asUint8List());

    setState(() {
      this.pdfPath = pdfPath;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        :
      Column(
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: PDFView(
                  filePath: pdfPath,
                ),
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
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
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
                      "上一頁",
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
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
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
        ]
      );
  }
}
