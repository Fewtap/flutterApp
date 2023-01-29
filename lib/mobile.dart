import 'dart:math';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_app/CustomWidgets.dart';

import 'Esthetics.dart';
import 'package:flutter/material.dart';
import 'package:my_app/FlightAPI.dart';
import 'package:provider/provider.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

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
        if (Provider.of<FlightData>(context).flights.isEmpty) {
          return Container(
            color: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.accentColor,
              ),
            ),
          );
        } else {
          //return a gridview builder with the flights
          return RefreshIndicator(
              onRefresh: () async {
                Provider.of<FlightData>(context, listen: false).getFlights();
              },
              child: Container(
                color: Colors.transparent,
                margin: const EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 200,
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: Provider.of<FlightData>(context).flights.length,
                  itemBuilder: (context, index) {
                    var flight =
                        Provider.of<FlightData>(context).flights[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 2,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                            child: //Create a random container with a random color
                                FlightCard(flight: flight)),
                      ),
                    );
                  },
                ),
              ));
        }
      },
    );
  }

  Color randomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}
