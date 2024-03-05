import 'package:festov4/models/konfigurasi_mqtt.dart';
import 'package:festov4/pages/loginpage.dart';
import 'package:festov4/pages/monitorpage.dart';
import 'package:festov4/pages/trendpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlPage extends StatefulWidget {
  final String ipAddress, nama, port;

  const ControlPage({
    super.key,
    required this.ipAddress,
    required this.nama,
    required this.port,
  });

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final TextEditingController inputSetpoint = TextEditingController();
  late MQTTService mqttService;
  String selectLoop = "None";

  @override
  void initState() {
    super.initState();

    mqttService = MQTTService(
      widget.ipAddress,
      widget.nama,
      int.parse(widget.port),
    );
    mqttService.connect();
    mqttService.control();
  }

  @override
  void dispose() {
    super.dispose();
    mqttService.disconnect();
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
          _controlSelect(context),
          const SizedBox(height: 25),
          _parameter(),
          const SizedBox(height: 25),
          _chartControl(context),
          const SizedBox(height: 25)
        ],
      ),
    );
  }

  Container _chartControl(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("SP %", style: TextStyle(color: Colors.white)),
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
                      valueListenable: mqttService.dataSetpoint,
                      builder: (context, height, child) {
                        return Container(
                          height: (height == "None")
                              ? 0
                              : double.parse(height) * 200 / 100,
                          color: Colors.black,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("PV %", style: TextStyle(color: Colors.white)),
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
                      valueListenable: mqttService.dataProcess,
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
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("CO %", style: TextStyle(color: Colors.white)),
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
                      valueListenable: mqttService.dataOutput,
                      builder: (context, height, child) {
                        return Container(
                          height: (height == "None")
                              ? 0
                              : double.parse(height) * 200 / 100,
                          color: Colors.green[900],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _parameter() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Setpoint :",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              ValueListenableBuilder(
                valueListenable: mqttService.dataSetpoint,
                builder: (BuildContext context, String value, Widget? child) {
                  return Text(
                    '$value %',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Process Variable :",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              ValueListenableBuilder(
                valueListenable: mqttService.dataProcess,
                builder: (BuildContext context, String value, Widget? child) {
                  return Text(
                    '$value %',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Controller Output :",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
              ValueListenableBuilder(
                valueListenable: mqttService.dataOutput,
                builder: (BuildContext context, String value, Widget? child) {
                  return Text(
                    '$value %',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _controlSelect(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Close loop :",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  mqttService.kirimPesan("Select Loop", "Level");
                  setState(() {
                    selectLoop = "LIC";
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 6,
                  color: selectLoop == "LIC" ? Colors.green[800] : Colors.grey,
                  child: Center(
                    child: Text(
                      "LIC\nB101",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 0.25 * MediaQuery.of(context).size.width / 6,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  mqttService.kirimPesan("Select Loop", "Flow");
                  setState(() {
                    selectLoop = "FIC";
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 6,
                  color: selectLoop == "FIC" ? Colors.green[800] : Colors.grey,
                  child: Center(
                    child: Text(
                      "FIC\nB102",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 0.25 * MediaQuery.of(context).size.width / 6,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  mqttService.kirimPesan("Select Loop", "Pressure");
                  setState(() {
                    selectLoop = "PIC";
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 6,
                  color: selectLoop == "PIC" ? Colors.green[800] : Colors.grey,
                  child: Center(
                    child: Text(
                      "PIC\nB103",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 0.25 * MediaQuery.of(context).size.width / 6,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  mqttService.kirimPesan("Select Loop", "Temperature");
                  setState(() {
                    selectLoop = "TIC";
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 6,
                  color: selectLoop == "TIC" ? Colors.green[800] : Colors.grey,
                  child: Center(
                    child: Text(
                      "TIC\nB104",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 0.25 * MediaQuery.of(context).size.width / 6,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 5),
            child: const Text(
              "Input Setpoint :",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextField(
            controller: inputSetpoint,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(0),
              prefixIcon: const Icon(
                Icons.settings,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  mqttService.kirimPesan(
                      "Control setpoint", inputSetpoint.text);
                },
                child: const Icon(Icons.send_rounded),
              ),
              hintText: 'setpoint (0-100 %)',
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
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                mqttService.kirimPesan("Control setpoint", "0");
                mqttService.kirimPesan("Select Loop", "Stop");
                setState(() {
                  selectLoop = "None";
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 15, bottom: 5),
                height: 45,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    "STOP",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _headerText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Control View",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        Icon(
          Icons.engineering_rounded,
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
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => MonitorPage(
                          nama: widget.nama,
                          ipAddress: widget.ipAddress,
                          port: widget.port,
                        )),
              );
            },
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
            onTap: () {},
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
