import 'package:flutter/material.dart';
import 'package:flutter_application_projecct/add.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(Lobby());

class Lobby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LobbyPage(), // ใช้ LobbyPage เป็นหน้าแรก
    );
  }

  Future<List<Map<String, dynamic>>> fetchDataFromDatabase() async {
    final String serverUrl = 'http://localhost/sever/connect.php'; // เปลี่ยนเป็น URL ของเซิร์ฟเวอร์ที่มีข้อมูล
    final response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถดึงข้อมูลได้');
    }
  }

}



class LobbyPage extends StatefulWidget {
  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  // สถานะเพื่อควบคุมการเปิด/ปิด Drawer
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi HAYT',
        style: TextStyle(
          color: Colors.white
        ),
        ),
        backgroundColor: Colors.green, // ชื่อหน้า
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchDataFromDatabase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // แสดง Indicator รอข้อมูล
              } else if (snapshot.hasError) {
                return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
              } else {
                final data = snapshot.data; // ข้อมูลที่ดึงมาจากเซิร์ฟเวอร์

                if (data!.isEmpty) {
                  return Text('ไม่พบข้อมูล');
                }

                return ListView.builder(
                  itemCount: data?.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Card(
                      child: ListTile(
                        title: Text('ชื่อผัก: ${item['vegetableName']}'),
                        subtitle: Text('เวลารดน้ำ: ${item['rond']}, ใส่ปุ๋ย: ${item['fertilizer']}'),
                        // เพิ่มส่วนอื่น ๆ ของ Card ตามต้องการ
                      ),
                    );
                  },
                );
              }
            },
          ),

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green, // สีพื้นหลังของ DrawerHeader
              ),
              child: Image.asset('assets/images/logo.png'), // เนื้อหาของ DrawerHeader
            ),
            ListTile(
              title: Text('เพิ่มข้อมูล'),
              onTap: () {
                // ทำอะไรก็ตามเมื่อเมนู 1 ถูกคลิก
              },
            ),
            ListTile(
              title: Text('ปิดการแจ้งเตือน'),
              onTap: () {
                // ทำอะไรก็ตามเมื่อเมนู 2 ถูกคลิก
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ทำอะไรก็ตามเมื่อ FloatingActionButton ถูกคลิก
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => add(),
              ),
            );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green, // ใส่ไอคอนใน FloatingActionButton
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // ตำแหน่งของ FloatingActionButton ที่มุมล่างขวา
    );
  }
}
