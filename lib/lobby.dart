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
    );
  }
}

class LobbyPage extends StatefulWidget {
  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  Future<List<Map<String, dynamic>>> fetchDataFromServer() async {
    final String serverUrl = 'http://localhost/server/connect.php';

    final response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('ไม่สามารถดึงข้อมูลได้');
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
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text('ชื่อผัก: ${item['vegetableName']}'),
                    subtitle: Text(
                        'เวลารดน้ำ: ${item['rond']}, ใส่ปุ๋ย: ${item['fertilizer']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // ทำอะไรก็ตามเมื่อปุ่มลบถูกคลิก
                      },
                    ),
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
                color: Colors.green,
              ),
              child: Image.asset('assets/images/logo.png'),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => add(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
    );
  }
}
