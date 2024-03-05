import 'package:festov4/pages/monitorpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212039),
      body: ListView(
        children: [
          const SizedBox(height: 50),
          Column(
            children: [
              const Text(
                "FESTO MPS PA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Icon(
                  Icons.lock_person,
                  size: 90,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            child: TextField(
              controller: namaController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(15),
                prefixIcon: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.person_2_rounded)),
                hintText: 'Username',
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 167, 167, 167),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            child: TextField(
              controller: ipController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(15),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.wifi_rounded),
                ),
                hintText: 'IP Address',
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 167, 167, 167),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: portController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(15),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Icon(
                    Icons.door_back_door_rounded,
                  ),
                ),
                hintText: 'Port',
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 167, 167, 167),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            margin:
                const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 39, 38, 72),
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MonitorPage(
                        nama: namaController.text,
                        ipAddress: ipController.text,
                        port: portController.text),
                  ),
                );
              },
              child: const Text("Connect"),
            ),
          )
        ],
      ),
    );
  }
}
