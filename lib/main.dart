import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//version 12/09/2022

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final _tag = "Beacons Plugin";
  String _beaconResult = 'Not Scanned Yet.';
  int _nrMessagesReceived = 0;
  var isRunning = false;
  final List<dynamic> _results = [];
  bool _isInForeground = true;

  final ScrollController _scrollController = ScrollController();

  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();

    //WidgetsFlutterBinding.ensureInitialized(); //!added by me

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    //!AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS =
        const DarwinInitializationSettings(onDidReceiveLocalNotification: null);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    beaconEventsController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Background Locations",
          message:
              "This app collects data to enable the Location of nearby devices even when the app is closed or not in use");

      //Only in case, you want the dialog to be shown again. By Default, dialog will never be shown if permissions are granted.
      await BeaconsPlugin.clearDisclosureDialogShowFlag(false);
    }

    if (Platform.isAndroid) {
      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        print("Method: ${call.method}");
        if (call.method == 'scannerReady') {
          _showNotification("Beacons monitoring started..");
          await BeaconsPlugin.startMonitoring();
          setState(() {
            isRunning = true;
          });
        } else if (call.method == 'isPermissionDialogShown') {
          _showNotification(
              "Prominent disclosure message is shown to the user!");
        }
      });
    } else if (Platform.isIOS) {
      _showNotification("Beacons monitoring started..");
      await BeaconsPlugin.startMonitoring();
      setState(() {
        isRunning = true;
      });
    }

    BeaconsPlugin.listenToBeacons(beaconEventsController);

    await BeaconsPlugin.addRegion(
        "BeaconType1", "909c3cf9-fc5c-4841-b695-380958a51a5a");
    await BeaconsPlugin.addRegion(
        "BeaconType2", "6a84c716-0f2a-1ce9-f210-6a63bd873dd9");

    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25");
    BeaconsPlugin.addBeaconLayoutForAndroid(
        "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24");

    BeaconsPlugin.setForegroundScanPeriodForAndroid(
        foregroundScanPeriod: 2200, foregroundBetweenScanPeriod: 10);

    BeaconsPlugin.setBackgroundScanPeriodForAndroid(
        backgroundScanPeriod: 2200, backgroundBetweenScanPeriod: 10);

    beaconEventsController.stream.listen(
        (data) {
          if (data.isNotEmpty && isRunning) {
            print("******Reading**************");
            setState(() {
              _beaconResult = data;
              //!NO OLVIDAR ARRGLAR LA PERMISOLOGIA PARA QUE A CADA RATO NO PIDA MERMISO MANUALS y la pimpiada de CACHE
              //checkIfBeaconExist(_results, jsonDecode(data)); //! esto qda comentado??????

              bool uuidExist = otroFor(data);

              if (uuidExist == false) {
                _results.add(jsonDecode(_beaconResult));
              }
              // Asi en vez de almacenarlo en string ya lo guardas en json o en un arreglo
              _nrMessagesReceived++;
            });

            if (!_isInForeground) {
              _showNotification("Beacons DataReceived: " + data);
            }

            print("Beacons DataReceived: " + data);
          }
        },
        onDone: () {},
        onError: (error) {
          print("Error: $error");
        });

    //Send 'true' to run in background
    await BeaconsPlugin.runInBackground(true);

    if (!mounted) return;
  }

  bool otroFor(String data) {
    var uuidExist = false;
    for (var element in _results) {
      if (element['uuid'] == jsonDecode(data)['uuid']) {
        uuidExist = true;
      }
    }
    return uuidExist;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Loop Manager',
            style: TextStyle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: 35,
                  color: const Color.fromARGB(255, 14, 193, 233),
                  child: const Card(
                      elevation: 25,
                      child: Text(
                        "Monitoring Volvo's Racks",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 71, 207, 245),
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ))),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Total Results: ' + _results.length.toString(),
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 14, 193, 233),
                          fontWeight: FontWeight.bold,
                        )),
              )),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (isRunning) {
                      print("corriendo");
                      await BeaconsPlugin.stopMonitoring();
                    } else {
                      print("No corriendo");
                      initPlatformState();
                      await BeaconsPlugin.startMonitoring();
                    }
                    setState(() {
                      isRunning = !isRunning;
                    });
                  },
                  child: Text(isRunning ? 'Stop Scanning' : 'Start Scanning',
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              Visibility(
                visible: _results.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _nrMessagesReceived = 0;
                        _results.clear();
                      });
                    },
                    child: const Text("Clear Results",
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Expanded(child: _buildResultsList())
            ],
          ),
        ),
      ),
    );
  }

  void _showNotification(String subtitle) {
    var rng = Random();
    Future.delayed(const Duration(seconds: 5)).then((result) async {
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          rng.nextInt(100000), _tag, subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }

  Widget _buildResultsList() {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        controller: _scrollController,
        itemCount: _results.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 1,
          color: Colors.black,
        ),
        itemBuilder: (context, index) {
          DateTime now = DateTime.now();
          String formattedDate =
              DateFormat('yyyy-MM-dd – kk:mm:ss.SSS').format(now);

          final item2 = Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: ThemeLabelValue(
                            label: 'Proximity:',
                            value: _results[index]['proximity'],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ThemeLabelValue(
                          label: 'UUID:',
                          value: _results[index]['uuid'],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
          final item = ListTile(
              title: Text(
                "Time: $formattedDate\nuuid: ${_results[index]['uuid']}", //!PONER LOS NOMBRS EN NEGRITA
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF1A1B26),
                      fontWeight: FontWeight.normal,
                    ),
              ),
              onTap: () {});

          final item3 = SizedBox(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(5),
              child: Card(
                elevation: 15,
                child: Column(
                  children: [
                    // ListTile(
                    //   title: const Text(
                    //     textAlign: TextAlign.justify,
                    //     'NAME',
                    //     style: TextStyle(
                    //       color: Color.fromARGB(255, 71, 207, 245),
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: 14,
                    //     ),
                    //   ),
                    //   subtitle: Text(
                    //     _results[index]['name'],
                    //     style: const TextStyle(
                    //         fontWeight: FontWeight.normal, fontSize: 14),
                    //   ),
                    // ),
                    ListTile(
                      title: const Text(
                        'UUID',
                        style: TextStyle(
                          color: Color.fromARGB(255, 71, 207, 245),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(_results[index]['uuid']),
                    ),

                    ListTile(
                      title: const Text(
                        'MAJOR',
                        style: TextStyle(
                          color: Color.fromARGB(255, 71, 207, 245),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(_results[index]['major']),
                    ),
                    ListTile(
                      title: const Text(
                        'MINOR',
                        style: TextStyle(
                          color: Color.fromARGB(255, 71, 207, 245),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(_results[index]['minor']),
                    ),
                    ListTile(
                      title: const Text(
                        textAlign: TextAlign.justify,
                        'DISTANCE',
                        style: TextStyle(
                          color: Color.fromARGB(255, 71, 207, 245),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        _results[index]['distance'],
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'PROXIMITY',
                        style: TextStyle(
                          color: Color.fromARGB(255, 71, 207, 245),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text((_results[index]['proximity']).toString()),
                    ),
                    ListTile(
                      title: const Text(
                        textAlign: TextAlign.justify,
                        'RSSI',
                        style: TextStyle(
                          color: Color.fromARGB(255, 71, 207, 245),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        _results[index]['rssi'],
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        textAlign: TextAlign.justify,
                        'macAddress',
                        style: TextStyle(
                          color: Color.fromARGB(255, 71, 207, 245),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        _results[index]['macAddress'],
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        textAlign: TextAlign.justify,
                        'TxPower',
                        style: TextStyle(
                          color: Color.fromARGB(255, 71, 207, 245),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        _results[index]['txPower'],
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          return item3;
        },
      ),
    );
  }
}

class ThemeLabelValue extends StatelessWidget {
  final String label;
  final String? value;

  const ThemeLabelValue({this.label = '', this.value}) : super(key: null);

  @override
  Widget build(BuildContext context) {
    String text = value ?? '';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Text((text != '') ? text : 'N/A'),
      ],
    );
  }
}
