import 'package:festov4/pages/controlpage.dart';
import 'package:festov4/pages/loginpage.dart';
import 'package:festov4/pages/trendpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:festov4/models/konfigurasi_mqtt.dart';

class MonitorPage extends StatefulWidget {
  final String ipAddress, nama, port;

  const MonitorPage({
    super.key,
    required this.ipAddress,
    required this.nama,
    required this.port,
  });

  @override
  State<MonitorPage> createState() => _MonitorPageV2State();
}

class _MonitorPageV2State extends State<MonitorPage> {
  late MQTTService mqttService;

  @override
  void initState() {
    super.initState();

    mqttService = MQTTService(
      widget.ipAddress,
      widget.nama,
      int.parse(widget.port),
    );
    mqttService.connect();
    mqttService.monitor();
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 38, 72),
      appBar: _appBar(),
      drawer: _drawer(context),
      body: ListView(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
        children: [
          _headerText(),
          const SizedBox(height: 30),
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 60, 59, 109).withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(-5, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _monitorTemp(),
                _monitorPress(),
                _monitorLevel(),
                _monitorFLow(),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 60, 59, 109).withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(-5, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tempBarChart(context),
                _pressBarChart(context),
                _levBarChart(context),
                _flowBarChart(context),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Column _flowBarChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("L/min", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              height: 200,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("10-", style: TextStyle(color: Colors.white70)),
                  Text("8-", style: TextStyle(color: Colors.white70)),
                  Text("6-", style: TextStyle(color: Colors.white70)),
                  Text("4-", style: TextStyle(color: Colors.white70)),
                  Text("2-", style: TextStyle(color: Colors.white70)),
                  Text("0-", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width / 11,
              color: Colors.white,
              alignment: Alignment.bottomCenter,
              child: ValueListenableBuilder(
                valueListenable: mqttService.dataFlow,
                builder: (context, height, child) {
                  return Container(
                    height: (height == "None")
                        ? 0
                        : double.parse(height) * 200 / 10,
                    color: Colors.green[900],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _levBarChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("liter", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              height: 200,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("9-", style: TextStyle(color: Colors.white70)),
                  Text("6-", style: TextStyle(color: Colors.white70)),
                  Text("3-", style: TextStyle(color: Colors.white70)),
                  Text("0-", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width / 11,
              color: Colors.white,
              alignment: Alignment.bottomCenter,
              child: ValueListenableBuilder(
                valueListenable: mqttService.dataLevel,
                builder: (context, height, child) {
                  return Container(
                    height:
                        (height == "None") ? 0 : double.parse(height) * 200 / 9,
                    color: Colors.blue[900],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _pressBarChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("mbar", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              height: 200,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("0.4-", style: TextStyle(color: Colors.white70)),
                  Text("0.3-", style: TextStyle(color: Colors.white70)),
                  Text("0.2-", style: TextStyle(color: Colors.white70)),
                  Text("0.1-", style: TextStyle(color: Colors.white70)),
                  Text("0.0-", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width / 11,
              color: Colors.white,
              alignment: Alignment.bottomCenter,
              child: ValueListenableBuilder(
                valueListenable: mqttService.dataPressure,
                builder: (context, height, child) {
                  return Container(
                    height: (height == "None")
                        ? 0
                        : double.parse(height) * 200 / 0.4,
                    color: Colors.orange,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _tempBarChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("°C", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              height: 200,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("100-", style: TextStyle(color: Colors.white70)),
                  Text("80-", style: TextStyle(color: Colors.white70)),
                  Text("60-", style: TextStyle(color: Colors.white70)),
                  Text("40-", style: TextStyle(color: Colors.white70)),
                  Text("20-", style: TextStyle(color: Colors.white70)),
                  Text("0-", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width / 11,
              color: Colors.white,
              alignment: Alignment.bottomCenter,
              child: ValueListenableBuilder(
                valueListenable: mqttService.dataTemperature,
                builder: (context, height, child) {
                  return Container(
                    height: (height == "None")
                        ? 0
                        : double.parse(height) * 200 / 100,
                    color: Colors.red[900],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row _monitorTemp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Temperature : ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: mqttService.dataTemperature,
          builder: (BuildContext context, String value, Widget? child) {
            return Text(
              '$value °C',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            );
          },
        ),
      ],
    );
  }

  Row _monitorPress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Pressure :",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )),
        ValueListenableBuilder(
          valueListenable: mqttService.dataPressure,
          builder: (BuildContext context, String value, Widget? child) {
            return Text(
              '$value mbar',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            );
          },
        ),
      ],
    );
  }

  Row _monitorLevel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Level :",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )),
        ValueListenableBuilder(
          valueListenable: mqttService.dataLevel,
          builder: (BuildContext context, String value, Widget? child) {
            return Text(
              '$value liter',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            );
          },
        ),
      ],
    );
  }

  Row _monitorFLow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Flow :",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )),
        ValueListenableBuilder(
          valueListenable: mqttService.dataFlow,
          builder: (BuildContext context, String value, Widget? child) {
            return Text(
              '$value liter/min',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            );
          },
        ),
      ],
    );
  }

  Row _headerText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Monitoring View",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        Icon(
          Icons.monitor_rounded,
          color: Colors.white,
          size: 35,
        )
      ],
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff212039),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "FESTO\nMPA PA",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.monitor_rounded,
              color: Colors.white,
            ),
            title: const Text(
              "Monitoring",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.engineering,
              color: Colors.white,
            ),
            title: const Text(
              "Control",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ControlPage(
                            nama: widget.nama,
                            ipAddress: widget.ipAddress,
                            port: widget.port,
                          )));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.ssid_chart_rounded,
              color: Colors.white,
            ),
            title: const Text(
              "Trends",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => TrendsPage(
                          nama: widget.nama,
                          ipAddress: widget.ipAddress,
                          port: widget.port,
                        )),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
            title: const Text(
              "Disconect",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xff212039),
      title: const Text(
        "FESTO MPS PA",
      ),
    );
  }
}
