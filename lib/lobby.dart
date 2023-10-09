import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'add.dart';

void main() => runApp(Lobby());

class Lobby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LobbyPage(),
      routes: {
        '/add': (context) => add(),
      },
    );
  }
}


class LobbyPage extends StatefulWidget {
  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
Future<List<Map<String, dynamic>>> fetchDataFromServer() async {
  final String serverUrl = 'http://172.21.244.137/server/connect.php';

  try {
    final response = await http.get(Uri.parse(serverUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถดึงข้อมูลได้: ${response.statusCode}');
    }
  } catch (error) {
    print('เกิดข้อผิดพลาดในการเชื่อมต่อ: $error');
    // คุณอาจต้องการคืนข้อมูลว่างหรืออื่น ๆ ที่เหมาะสมในกรณีที่เกิดข้อผิดพลาด
    return <Map<String, dynamic>>[];
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi HAYT',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
              body: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchDataFromServer(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('ไม่พบข้อมูล'));
            } else {
              final data = snapshot.data;
              return RefreshIndicator(
                onRefresh: () async {
                  // คำสั่งอัปเดตข้อมูลเมื่อผู้ใช้ลากลงเพื่อรีเฟรช
                  setState(() {});
                },
                child: ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Card(
                      child: ListTile(
                        title: Text('ชื่อผัก: ${item['vegetableName']}'),
                        subtitle: Text(
                          'เวลารดน้ำ: ${item['rond']}, ใส่ปุ๋ย: ${item['fertilizer']}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // ทำอะไรก็ตามเมื่อปุ่มลบถูกคลิก
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),

        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF6C934D),
                ),
                child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/add');
                },
                child: ListTile(
                  title: Text('เพิ่มข้อมูล'),
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: ListTile(
                  title: Text('ปิดการแจ้งเตือน'),
                ),
              ),
            ],
          ),
        ),

            floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF6C934D),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
    );
  }
}
