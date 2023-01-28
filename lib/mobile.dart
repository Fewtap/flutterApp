import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:ui';
import 'Esthetics.dart';
import 'FlightAPI.dart' as fa;
import 'package:flutter/material.dart';
import 'package:my_app/CustomWidgets.dart';
import 'package:my_app/FlightAPI.dart';
import 'FlightAPI.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MobileHomePage extends StatefulWidget {
  MobileHomePage({super.key});

  static double bodySize = 12;
  static double titleSize = 18;
  static double seperatorWidth = 250;

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Builder(
      builder: (context) {
        if (Provider.of<FlightData>(context).flights.length == 0) {
          return Container(
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 200,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 0),
                itemBuilder: (context, index) {
                  var flight = Provider.of<FlightData>(context).flights[index];
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: 2,
                    child: SlideAnimation(
                      verticalOffset: 500,
                      horizontalOffset: 200,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: Duration(milliseconds: 1000),
                      child: FlightCard(
                          
                          flight: flight,
                          ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
