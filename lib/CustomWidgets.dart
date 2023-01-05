import 'dart:ui';
import 'Esthetics.dart';
import 'package:flutter/material.dart';
import 'package:my_app/FlightAPI.dart';
import 'FlightAPI.dart';
import 'package:intl/intl.dart';
import 'package:flip_card/flip_card.dart';

class FlightCard extends StatelessWidget {
  const FlightCard({
    super.key,
    required this.bodySize,
    required this.titleSize,
    required this.flight,
  });

  final double bodySize;
  final double titleSize;
  final Flight flight;

//Q: why isn't the hero working?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Make the background color transparent
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        //Navigate to the flight details page
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlightInformationPage(
                flight: flight,
              ),
            ),
          );
        },
        child: Hero(
          tag: flight.flightHash,
          child: FlipCard(
            onFlip: () => {FocusManager.instance.primaryFocus?.unfocus()},
            fill: Fill.fillBack,
            front: InkWell(
              splashColor: Colors.transparent,
              child: Stack(
                children: [
                  Card(
                    shadowColor: AppTheme.shadowColor,
                    color: AppTheme.accentColor,
                    margin: const EdgeInsets.all(10),
                    elevation: 10,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Center(
                                child: SizedBox(
                                  height: 20,
                                ),
                              ),
                              Center(
                                child: Text(
                                  flight.rute.toString(),
                                  style: TextStyle(fontSize: titleSize),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: 1,
                                  color: Colors.black,
                                  width: (12 * 6),
                                ),
                              ),
                              const Center(child: SizedBox(height: 10)),
                              Flexible(
                                child: LayoutBuilder(
                                  builder: (context, constraints) => Text(
                                    "Destination: ${flight.arrivalAirport}",
                                    style: TextStyle(
                                        fontSize: constraints.maxWidth / 15),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Planned: ${DateFormat('kk:mm').format(flight.planned)}",
                                  style: TextStyle(fontSize: bodySize),
                                ),
                              ),
                              if (flight.estimated != null &&
                                  flight.estimated != flight.planned)
                                Center(
                                  child: Text(
                                    "Estimated: ${DateFormat('kk:mm').format(flight.estimated as DateTime)}",
                                    style: TextStyle(fontSize: bodySize),
                                  ),
                                ),
                              Center(
                                child: Text(
                                  "Bus departure: ${DateFormat('kk:mm').format(flight.planned.add(const Duration(minutes: -90)))}",
                                  style: TextStyle(fontSize: bodySize),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (flight.status.en == "Delayed" ||
                      flight.status.en == "Cancelled")
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: flight.status.en == "Delayed"
                              ? Colors.amber
                              : Colors.red,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            flight.status.en.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            back: Card(
              shadowColor: AppTheme.shadowColor,
              color: AppTheme.accentColor,
              margin: const EdgeInsets.all(20),
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: //Create a decorated text field that will be used to input the room number
                        DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        border: Border.all(
                          color: AppTheme.shadowColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Room number",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Create a class that will be used to display the flight information from a hero widget
class FlightInformationPage extends StatelessWidget {
  const FlightInformationPage({
    super.key,
    required this.flight,
  });

  final Flight flight;

  //create a page that will display the flight information using the flight hash as a hero tag
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Make a bottom navigation bar that will allow the user to pop the page
        //and return to the previous page
        floatingActionButton: FloatingActionButton(
          enableFeedback: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        body: Center(
          child:
              //Add a widget that makes sure the children is in bounds

              Hero(
            tag: flight.flightHash,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    //Create a text widget that informs that this is not implemented yet
                    Text(
                      "This is not implemented yet",
                      style: TextStyle(
                          fontSize: 30,
                          backgroundColor: Colors.amber,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        //Make a column that shows all the fields of flight
        );
  }
}
