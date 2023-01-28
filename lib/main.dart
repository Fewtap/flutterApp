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


void main() async {
  //get the platform the app is running on and place it in a variable
  
  WidgetsFlutterBinding.ensureInitialized();
  FlightData flightData = FlightData();
  flightData.getFlights();

  //If the app is not running on windows or macos, initialize firebase

  FirstRun firstRun = FirstRun();
  firstRun.checkFirstRun();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => flightData),
    ChangeNotifierProvider(create: (context) => firstRun)
  ], child: const app()));

  
  }


class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  double r = 20;
  Widget? homePageWidget = MobileHomePage();

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
        
        if (MediaQuery.of(context).size.width > 450) {
          return Scaffold(
            appBar: AppBar(
              foregroundColor: AppTheme.accentColor,
              title: Text("Departures hmm"),
              backgroundColor: AppTheme.primaryColor,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChangeLog()));
                    },
                    icon: Icon(Icons.info))
              ],
            ),
            //Create a drawer with two options
            //one to see the flights and one to see the changelog
            drawer: Drawer(
              //Add a button to access the drawer

              child: ListView(
                children: [
                  ListTile(
                    title: Text("Changelog"),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChangeLog()));
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
              title: Text("Departures Ilulissat"),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.accentColor,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChangeLog()));
                    },
                    icon: Icon(Icons.info))
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
                    title: Text("Changelog"),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChangeLog()));
                    },
                  ),
                ],
              ),
            ),
            backgroundColor: AppTheme.backgroundColor,
            body: Consumer<FlightData>(
              builder: (context, flightData, child) {
                return MobileHomePage();
              },
            ),
          );
        }
      }),
    );
  }

  
}
