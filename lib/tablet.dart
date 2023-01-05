import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_app/FirstRunNotifier.dart';
import 'package:provider/provider.dart';
import 'Esthetics.dart';
import 'package:flutter/material.dart';
import 'package:my_app/CustomWidgets.dart';
import 'package:my_app/FlightAPI.dart';

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
    return Consumer<FirstRun>(
      builder: (context, value, child) => Builder(
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
                      mainAxisExtent: 250,
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
