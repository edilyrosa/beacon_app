import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:intl/intl_browser.dart';

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
    // initPlatformState();

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
    try {
      BeaconsPlugin.listenToBeacons(beaconEventsController);

      beaconEventsController.stream.listen((data) {
        print('data');
        //print(data);
        //print(data.isEmpty);
        if (data.isNotEmpty && isRunning) {
          print("******Reading**************");
          dynamic decodedData = jsonDecode(data);
          if (decodedData is Map) {
            final Map beaconResult = decodedData;

            int existingIndex = _results.indexWhere(
                (element) => element['uuid'] == beaconResult['uuid']);

            if (existingIndex >= 0) {
              _results[existingIndex] = beaconResult;
            } else {
              print('test');
              List<Map<String, dynamic>> dataReceived = [
                {
                  'uuid': '58b8008b-b05b-4783-bd32-2da7294b81d7',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '7ba4fa5e-5f3d-4ff8-b4f0-fd3667da162b',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': 'ab28f612-79e5-43a4-9bb4-a0f0c4c170de',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '8ad0b1a2-6b7f-468a-8d16-12a2e4b0eed7',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '6f7e45ce-ee71-4a1e-81e7-ac6eb6318478',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '04b41a3b-a926-45a5-b54a-f98cb8eaaec2',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': 'b1e467b2-ce29-4c93-a6bc-b50a8a5a0140',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': 'c4925d93-4258-43eb-8946-876c1a54f2c6',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': 'f9f142d8-83d4-4a80-a8f2-31a012473c20',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '769b054c-dafa-4aa3-acd7-1aee1a931600',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '6eca0817-b5dd-4556-8a4c-748dfbd1ed1d',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '443b0b45-d34a-4f72-a960-d87ce31b4f29',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': 'a9dcec49-cc40-4682-a3e9-efb6a9d3a498',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '3562a67c-83a9-4216-b44b-07d87d9e2915',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '07fce829-f984-4fbf-b6cc-3b7566719bda',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': 'c67dd57f-2db0-427a-9a6f-374c32906bfa',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '17ae34f6-077b-42da-bb27-158e298cea70',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': 'bd77811d-10b9-4137-9627-a4f8bf0325d9',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '649a63b0-ea76-4a01-a96b-466c32410aa8',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '0a1b0d57-79d2-4c73-ac31-dde7a94543c7',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': 'a4514da0-8a02-436c-a737-0806ffde91b3',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': 'dcdc4b39-35aa-4a0c-9ff6-94b71b7d9789',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '52aac7d6-85cd-40dd-8be5-42aa88bb80d5',
                  'major': 55,
                  'minor': 55
                },
                {
                  'uuid': '025fe329-ceb9-4fc8-b37a-178b6d207bbf',
                  'major': 55,
                  'minor': 55
                },
              ];

              //!Si el uuid q intenta entrar esta en la lista, que entre al array de _results

              for (int i = 0; i < dataReceived.length; i++) {
                if (dataReceived[i]['uuid'] == beaconResult['uuid']) {
                  _results.add(beaconResult);
                  break;
                }
              }
            }

            setState(() {
              _nrMessagesReceived++;
              _results;
            });

            if (!_isInForeground) {
              _showNotification("Beacons DataReceived: " + data);
            }

            print("Beacons DataReceived: " + data);
          }
        }
      }, onDone: () {
        print('done');
      }, onError: (error) {
        print("Error: $error");
      });

      //Send 'true' to run in background
      await BeaconsPlugin.runInBackground(true);

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
        List<Map<String, dynamic>> dataReceived = [
          {
            'uuid': '58b8008b-b05b-4783-bd32-2da7294b81d7',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '7ba4fa5e-5f3d-4ff8-b4f0-fd3667da162b',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': 'ab28f612-79e5-43a4-9bb4-a0f0c4c170de',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '8ad0b1a2-6b7f-468a-8d16-12a2e4b0eed7',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '6f7e45ce-ee71-4a1e-81e7-ac6eb6318478',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '04b41a3b-a926-45a5-b54a-f98cb8eaaec2',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': 'b1e467b2-ce29-4c93-a6bc-b50a8a5a0140',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': 'c4925d93-4258-43eb-8946-876c1a54f2c6',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': 'f9f142d8-83d4-4a80-a8f2-31a012473c20',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '769b054c-dafa-4aa3-acd7-1aee1a931600',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '6eca0817-b5dd-4556-8a4c-748dfbd1ed1d',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '443b0b45-d34a-4f72-a960-d87ce31b4f29',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': 'a9dcec49-cc40-4682-a3e9-efb6a9d3a498',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '3562a67c-83a9-4216-b44b-07d87d9e2915',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '07fce829-f984-4fbf-b6cc-3b7566719bda',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': 'c67dd57f-2db0-427a-9a6f-374c32906bfa',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '17ae34f6-077b-42da-bb27-158e298cea70',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': 'bd77811d-10b9-4137-9627-a4f8bf0325d9',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '649a63b0-ea76-4a01-a96b-466c32410aa8',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '0a1b0d57-79d2-4c73-ac31-dde7a94543c7',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': 'a4514da0-8a02-436c-a737-0806ffde91b3',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': 'dcdc4b39-35aa-4a0c-9ff6-94b71b7d9789',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '52aac7d6-85cd-40dd-8be5-42aa88bb80d5',
            'major': 55,
            'minor': 55
          },
          {
            'uuid': '025fe329-ceb9-4fc8-b37a-178b6d207bbf',
            'major': 55,
            'minor': 55
          },
        ];
        int counter = 0;
        for (var beacon in dataReceived) {
          BeaconsPlugin.addRegionForIOS(
            beacon['uuid'], // String
            beacon['major'], // int,
            beacon['minor'], // int
            counter.toString(), // String
          );
          counter++;
        }
        print('counter:');
        print(counter);
        //    BeaconsPlugin.addRegionForIOS(
        //      '58A97DEC-7CD7-44CB-9DA8-F02DC3466165',
        //      55,
        //      66,
        //      'BeaconType1',
        //    );
        // BeaconsPlugin.addRegionForIOS(
        //     '6eca0817-b5dd-4556-8a4c-748dfbd1ed1d', 55, 55, 'BeaconType2');
        await BeaconsPlugin.startMonitoring();
        // setState(() {
        //   isRunning = true;
        // });
      }
    } catch (e) {
      print('ERRORRR');
      print(e);
    }

    if (!mounted) return;
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
                      print("Stop");
                      await BeaconsPlugin.stopMonitoring();
                    } else {
                      print("Start");
                      initPlatformState();
                      //await BeaconsPlugin.startMonitoring();
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
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ThemeLabelValue(
                          label: 'UUID',
                          value: _results[index]['uuid'],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ThemeLabelValue(
                          label: 'Major:',
                          value: _results[index]['major'],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ThemeLabelValue(
                          label: 'Minor:',
                          value: _results[index]['minor'],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ThemeLabelValue(
                          label: 'Distance:',
                          value: _results[index]['distance'],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ThemeLabelValue(
                          label: 'Proximity:',
                          value: _results[index]['proximity'],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ThemeLabelValue(
                          label: 'RSSI:',
                          value: _results[index]['rssi'],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ThemeLabelValue(
                          label: 'macAddress:',
                          value: _results[index]['macAddress'],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: ThemeLabelValue(
                          label: 'txPower:',
                          value: _results[index]['txPower'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );

          final item3 = Card(
            //!Adding this style.
            color: Colors.grey[100],
            elevation: 50,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2)),
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'iBeacon',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color.fromARGB(255, 7, 199, 233)),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'UUID',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(_results[index]['uuid'],
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 86, 183, 235),
                    //thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Major',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(_results[index]['major'],
                                style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Minor',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(_results[index]['minor'],
                                style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Mac Address',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(_results[index]['macAddress'],
                                style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'RSSI',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(_results[index]['rssi'],
                                style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Distance',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(_results[index]['distance'],
                                style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Proximity',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(_results[index]['proximity'],
                                style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Tx',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(_results[index]['txPower'],
                                style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
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
