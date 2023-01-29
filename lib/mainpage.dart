import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_app/FirstRunNotifier.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'Esthetics.dart';
import 'FlightAPI.dart' as fa;
import 'package:flutter/material.dart';
import 'package:my_app/CustomWidgets.dart';
import 'package:my_app/FlightAPI.dart';
import 'FlightAPI.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

class TabletHomePage extends StatefulWidget {
  late String randomString;
  TabletHomePage({super.key});

  static double tabletBodySize = 18;
  static double tabletTitleSize = 40;
  static double seperatorWidth = 250;

  @override
  State<TabletHomePage> createState() => _TabletHomePageState();
}

class _TabletHomePageState extends State<TabletHomePage> {
//rerun the build method when the future is updated to rebuild the animation
  late String _storedValue;
  late String _currentValue;

  // Initialize shared preferences

  @override
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).orientation.toString());
    //print the screen width
    print(MediaQuery.of(context).size.width);
    return Consumer<FirstRun>(
      builder: (context, value, child) => Builder(
        builder: (context) {
          if (Provider.of<FlightData>(context).flights.length == 0) {
            return Container(
              color: Colors.transparent,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.accentColor,
                ),
              ),
            );
          } else {
            return AnimationLimiter(
              child: RefreshIndicator(
                onRefresh: () async {
                  Provider.of<FlightData>(context, listen: false).getFlights();
                },
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: Provider.of<FlightData>(context).flights.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 2
                          : 4,
                      mainAxisExtent: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.height /
                              (Provider.of<FlightData>(context).flights.length -
                                  2)
                          : MediaQuery.of(context).size.height / 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    var flight =
                        Provider.of<FlightData>(context).flights[index];

                    return AnimationConfiguration.staggeredGrid(
                      duration: const Duration(milliseconds: 500),
                      position: index,
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          duration: const Duration(milliseconds: 500),
                          child: FlightCard(
                            flight: flight,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
