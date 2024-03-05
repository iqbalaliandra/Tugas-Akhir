import 'dart:async';
import 'package:festov4/pages/controlpage.dart';
import 'package:festov4/pages/monitorpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:festov4/pages/loginpage.dart';
import 'package:festov4/models/konfigurasi_mqtt.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrendsPage extends StatefulWidget {
  final String ipAddress, nama, port;

  const TrendsPage({
    super.key,
    required this.ipAddress,
    required this.nama,
    required this.port,
  });

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  late MQTTService mqttService;
  late List<LiveData> dataProcess;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    dataProcess = getChartData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();

    mqttService = MQTTService(
      widget.ipAddress,
      widget.nama,
      int.parse(widget.port),
    );
    mqttService.connect();
    mqttService.trend();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Proportional (KP):",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        )),
                    ValueListenableBuilder(
                      valueListenable: mqttService.kp,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return Text(
                          value,
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
                    const Text("Integral (KI):",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        )),
                    ValueListenableBuilder(
                      valueListenable: mqttService.ki,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return Text(
                          value,
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
                    const Text("Derivative (KD):",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        )),
                    ValueListenableBuilder(
                      valueListenable: mqttService.kd,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return Text(
                          value,
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
          ),
          SizedBox(height: 30),
          Container(
            height: 700,
            padding:
                const EdgeInsets.only(left: 0, right: 15, top: 25, bottom: 0),
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
            child: SfCartesianChart(
                isTransposed: false,
                plotAreaBorderWidth: 0,
                primaryXAxis: NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 20,
                  labelFormat: '{value}%',
                  labelRotation: 90,
                  labelAlignment: LabelAlignment.center,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  minorTicksPerInterval: 1,
                  minorGridLines: const MinorGridLines(width: 0),
                  majorGridLines: MajorGridLines(
                      width: 1, color: Colors.white.withOpacity(0.1)),
                  opposedPosition: false,
                ),
                primaryYAxis: NumericAxis(
                  minimum: dataProcess[0].time,
                  maximum: dataProcess[89].time,
                  interval: 5,
                  labelRotation: 90,
                  labelAlignment: LabelAlignment.center,
                  labelFormat: '{value}s',
                  labelStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                  majorGridLines: const MajorGridLines(width: 0),
                  isInversed: true,
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                ),
                series: <LineSeries<LiveData, double>>[
                  LineSeries<LiveData, double>(
                    dataSource: dataProcess,
                    xValueMapper: (LiveData sales, _) => sales.value,
                    yValueMapper: (LiveData sales, _) => sales.time,
                    color: Colors.blue[400],
                    animationDuration: 0,
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                  )
                ]),
          )
        ],
      ),
    );
  }

  double time = 91;
  void updateDataSource(Timer timer) {
    dataProcess.add(LiveData(time++, (mqttService.doubleDataProcess)));
    dataProcess.removeAt(0);
    if (mounted) {
      setState(() {});
    }
    _chartSeriesController.updateDataSource(
        addedDataIndex: dataProcess.length - 1, removedDataIndex: 0);
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(1, 0),
      LiveData(2, 0),
      LiveData(3, 0),
      LiveData(4, 0),
      LiveData(5, 0),
      LiveData(6, 0),
      LiveData(7, 0),
      LiveData(8, 0),
      LiveData(9, 0),
      LiveData(10, 0),
      LiveData(11, 0),
      LiveData(12, 0),
      LiveData(13, 0),
      LiveData(14, 0),
      LiveData(15, 0),
      LiveData(16, 0),
      LiveData(17, 0),
      LiveData(18, 0),
      LiveData(19, 0),
      LiveData(20, 0),
      LiveData(21, 0),
      LiveData(22, 0),
      LiveData(23, 0),
      LiveData(24, 0),
      LiveData(25, 0),
      LiveData(26, 0),
      LiveData(27, 0),
      LiveData(29, 0),
      LiveData(30, 0),
      LiveData(31, 0),
      LiveData(32, 0),
      LiveData(33, 0),
      LiveData(34, 0),
      LiveData(35, 0),
      LiveData(36, 0),
      LiveData(37, 0),
      LiveData(38, 0),
      LiveData(39, 0),
      LiveData(40, 0),
      LiveData(41, 0),
      LiveData(42, 0),
      LiveData(43, 0),
      LiveData(44, 0),
      LiveData(45, 0),
      LiveData(46, 0),
      LiveData(47, 0),
      LiveData(48, 0),
      LiveData(49, 0),
      LiveData(50, 0),
      LiveData(51, 0),
      LiveData(52, 0),
      LiveData(53, 0),
      LiveData(54, 0),
      LiveData(55, 0),
      LiveData(56, 0),
      LiveData(57, 0),
      LiveData(58, 0),
      LiveData(59, 0),
      LiveData(60, 0),
      LiveData(61, 0),
      LiveData(62, 0),
      LiveData(63, 0),
      LiveData(64, 0),
      LiveData(65, 0),
      LiveData(66, 0),
      LiveData(67, 0),
      LiveData(68, 0),
      LiveData(69, 0),
      LiveData(70, 0),
      LiveData(71, 0),
      LiveData(72, 0),
      LiveData(73, 0),
      LiveData(74, 0),
      LiveData(75, 0),
      LiveData(76, 0),
      LiveData(77, 0),
      LiveData(78, 0),
      LiveData(79, 0),
      LiveData(80, 0),
      LiveData(81, 0),
      LiveData(82, 0),
      LiveData(83, 0),
      LiveData(84, 0),
      LiveData(85, 0),
      LiveData(86, 0),
      LiveData(87, 0),
      LiveData(88, 0),
      LiveData(89, 0),
      LiveData(90, 0),
    ];
  }

  Row _headerText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Trends View",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        Icon(
          Icons.ssid_chart_rounded,
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
                        )),
              );
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
            onTap: () {},
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

class LiveData {
  LiveData(this.time, this.value);
  final double time;
  final double value;
}
