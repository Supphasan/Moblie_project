import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_projecct/lobby.dart';
import 'package:http/http.dart' as http;

void main() => runApp(add());

class add extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextEntryPage(), // ใช้ TextEntryPage เป็นหน้าแรก
    );
  }
}

class TextEntryPage extends StatefulWidget {
  @override
  _TextEntryPageState createState() => _TextEntryPageState();
}

class _TextEntryPageState extends State<TextEntryPage> {
  String selectedDropdownValue = 'รดน้ำ1ครั้งต่อวัน';
  TextEditingController textEditingController = TextEditingController();
  bool useFertilizer = false; // สถานะของช่องใส่ปุ๋ย

  // เพิ่ม URL ของเซิร์ฟเวอร์ที่คุณต้องการส่งข้อมูลไป
  final String serverUrl = 'http://localhost/sever/connect.php';

  // เมื่อกดปุ่ม "OK"
  void sendDataToServer() async {
    String vegetableName = textEditingController.text;
    String fertilizerStatus = useFertilizer ? 'ใส่ปุ๋ย' : 'ไม่ใส่ปุ๋ย';

    // สร้างข้อมูล JSON ที่จะส่งไปยังเซิร์ฟเวอร์
    Map<String, dynamic> data = {
      'name': vegetableName,
      'description': selectedDropdownValue + ', ' + fertilizerStatus,
    };

    // ส่งข้อมูลไปยังเซิร์ฟเวอร์โดยใช้ HTTP POST
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // ส่งข้อมูลสำเร็จ
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ข้อมูลผัก'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('ชื่อผัก: $vegetableName'),
                  Text('ชื่อรดน้ำ: $selectedDropdownValue'),
                  Text('การใส่ปุ๋ย: $fertilizerStatus'),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );

        // ล้างข้อมูลในช่องกรอก
        textEditingController.clear();

        // รีเซ็ตสถานะ
        setState(() {
          selectedDropdownValue = 'รดน้ำ1ครั้งต่อวัน';
          useFertilizer = false;
        });

        // นำทางไปยังหน้า Lobby หลังจากส่งข้อมูลสำเร็จ
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Lobby(),
          ),
        );
      } else {
        // ไม่สามารถส่งข้อมูลไปยังเซิร์ฟเวอร์ได้
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ข้อผิดพลาด'),
              content: Text('ไม่สามารถส่งข้อมูลไปยังเซิร์ฟเวอร์ได้'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // เกิดข้อผิดพลาดในการส่งข้อมูล
      print('เกิดข้อผิดพลาดในการส่งข้อมูล: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('กรอกข้อมูลผัก'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('ชื่อผัก: ', style: TextStyle(fontSize: 18.0)),
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Text('ชื่อรดน้ำ: ', style: TextStyle(fontSize: 18.0)),
                DropdownButton<String>(
                  value: selectedDropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    'รดน้ำ1ครั้งต่อวัน',
                    'รดน้ำ2ครั้งต่อวัน',
                    'รดน้ำ3ครั้งต่อวัน',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Text('ใส่ปุ๋ย: ', style: TextStyle(fontSize: 18.0)),
                Checkbox(
                  value: useFertilizer,
                  onChanged: (bool? newValue) {
                    setState(() {
                      useFertilizer = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    sendDataToServer();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text('OK'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    textEditingController.clear();
                    setState(() {
                      selectedDropdownValue = 'รดน้ำ1ครั้งต่อวัน';
                      useFertilizer = false;
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => Lobby(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
