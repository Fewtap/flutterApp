import 'package:my_app/Esthetics.dart';
import 'package:my_app/tablet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/mobile.dart';
import 'package:provider/provider.dart';
import 'FirstRunNotifier.dart';
import 'FlightAPI.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:my_app/ChangeLog.dart';
import 'package:flutter_html/flutter_html.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlightData flightData = FlightData();
  flightData.getFlights();

  FirstRun firstRun = FirstRun();
  firstRun.checkFirstRun();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => flightData),
    ChangeNotifierProvider(create: (context) => firstRun)
  ], child: const app()));

  if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    var db = FirebaseFirestore.instance;
  }
}

class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  double r = 20;
  Widget? homePageWidget = const MobileHomePage();

  //Check if the build version in stored preferences is the same as the current build version

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(builder: (context) {
        print(MediaQuery.of(context).size.width);
        if (MediaQuery.of(context).size.width > 450) {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: AppTheme.accentColor,
              title: const Text("Departures Ilulissat"),
              backgroundColor: AppTheme.primaryColor,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangeLog()));
                    },
                    icon: const Icon(Icons.info))
              ],
            ),
            //Create a drawer with two options
            //one to see the flights and one to see the changelog
            drawer: Drawer(
              //Add a button to access the drawer

              child: ListView(
                children: [
                  ListTile(
                    title: const Text("Changelog"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangeLog()));
                    },
                  ),
                ],
              ),
            ),
            backgroundColor: AppTheme.backgroundColor,
            body: Consumer<FlightData>(
              builder: (context, flightData, child) {
                return TabletHomePage();
              },
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Departures Ilulissat"),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.accentColor,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangeLog()));
                    },
                    icon: const Icon(Icons.info))
              ],
            ),
            //Create a drawer with two options
            //one to see the flights and one to see the changelog
            drawer: Drawer(
              //Add a button to access the drawer

              child: ListView(
                children: [
                  ListTile(
                    style: ListTileStyle.drawer,
                    title: const Text("Changelog"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangeLog()));
                    },
                  ),
                  ListTile(
                    style: ListTileStyle.drawer,
                    title: const Text("Weather"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LayoutBuilder(builder: (c, a) {
                            double divider = 1.1;
                            return Scaffold(
                              body: Center(
                                child: Html(
                                    shrinkWrap: true,
                                    data:
                                        """<iframe width="${a.maxWidth / divider}" height="${a.maxHeight / divider}"
                                    src="https://embed.windy.com/embed2.html?lat=63.724&lon=-49.219&detailLat=65.413&detailLon=-52.895&width=${a.maxWidth / divider}&height=${a.maxHeight / divider}&zoom=5&level=surface&overlay=wind&product=ecmwf&menu=&message=true&marker=&calendar=now&pressure=&type=map&location=coordinates&detail=true&metricWind=default&metricTemp=default&radarRange=-1"
                                    frameborder="0"></iframe>"""),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            backgroundColor: AppTheme.backgroundColor,
            body: Consumer<FlightData>(
              builder: (context, flightData, child) {
                return const MobileHomePage();
              },
            ),
          );
        }
      }),
    );
  }

  //Psuedo code
  //if the screen is bigger than 450
  //return a tablet page
  //else
  //return a mobile page
}
