import 'package:flutter/material.dart';
import 'package:flutter_application_projecct/add.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool isDrawerOpen = true;
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

  Future<void> fetchDataFromServer() async {
    final String serverUrl = 'http://localhost/sever/connect.php';

    try {
      final response = await http.get(Uri.parse(serverUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        throw Exception('ไม่สามารถดึงข้อมูลได้');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('เกิดข้อผิดพลาด: $error');
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : data.isEmpty
              ? Center(
                  child: Text('ไม่พบข้อมูล'),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
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
        onPressed: () 
        {
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
