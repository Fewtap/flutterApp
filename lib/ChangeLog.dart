import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class ChangeLog extends StatefulWidget {
  const ChangeLog({super.key});

  @override
  State<ChangeLog> createState() => _ChangeLogState();
}

class _ChangeLogState extends State<ChangeLog> {
  String version = "";
  @override
  Widget build(BuildContext context) {
    //Get the version of the app and store it in a string

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                //Center the column
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Changelog",
                    style: TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 50),
                  const Text("• Version 0.1.0"),
                  const Text("• Improved UI"),
                  const Text("• Added a drawer"),
                  const Text("• Added a changelog"),
                  const Text("• Implemented pull to refresh"),
                  const Text(
                      "• Implemented a card expansion by holding the front of the card. (Needs to be polished)"),
                  const Text(
                      "• Implemented adding a room by textfield. (Needs to be polished)"),
                  const Text(
                      "• Implemented room deletion by Button. (Needs to be polished)"),
                  const SizedBox(height: 200),
                  const Text("Created by: Marko Jovic"),
                  Text("Version: $version")
                ]),
          ),
        ),
      ),
    );
  }
}
