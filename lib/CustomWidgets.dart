import 'dart:ui';
import 'package:provider/provider.dart';

import 'Esthetics.dart';
import 'package:flutter/material.dart';
import 'package:my_app/FlightAPI.dart';
import 'FlightAPI.dart';
import 'package:intl/intl.dart';
import 'package:flip_card/flip_card.dart';
import 'package:animations/animations.dart';
import 'dart:math';

class FlightCard extends StatelessWidget {
  const FlightCard({
    super.key,
    required this.flight,
  });

  final Flight flight;

//Q: why isn't the hero working?

  @override
  Widget build(BuildContext context) {
    //print the width of the screen

    return Container(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlipCard(
          onFlip: () => {FocusManager.instance.primaryFocus?.unfocus()},
          fill: Fill.fillBack,
          front: OpenContainer(
            transitionDuration: const Duration(milliseconds: 300),
            transitionType: ContainerTransitionType.fadeThrough,
            tappable: false,
            closedBuilder: (context, action) => GestureDetector(
              onLongPress: () => action(),
              child: ClosedFlightCard(flight: flight),
            ),
            openBuilder: (context, action) => FlightInformationPage(
              flight: flight,
            ),
          ),
          back: BackSideofCard(
            flight: flight,
            context: context,
          ),
        ),
      ),
    );
  }
}

class BackSideofCard extends StatefulWidget {
  final Flight flight;

  final BuildContext context;

  const BackSideofCard(
      {super.key, required this.flight, required this.context});

  @override
  State<BackSideofCard> createState() => _BackSideofCardState();
}

class _BackSideofCardState extends State<BackSideofCard> {
  TextEditingController roomController = TextEditingController();

  void addRoom(String room) {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    print("Card width ${MediaQuery.of(context).size.width}");

    return Container(
      color: AppTheme.accentColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: roomController,
              onFieldSubmitted: (value) {
                //Check if value is can be parsed into an int
                if (int.tryParse(value) == null) {
                  //Show a snackbar if the value is not a number
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a number"),
                    ),
                  );

                  //Clear the textfield
                  roomController.clear();
                } else {
                  Provider.of<FlightData>(context, listen: false)
                      .addRoom(value, widget.flight.flightHash);
                  roomController.clear();
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Enter a room: ',
                hintStyle: const TextStyle(fontSize: 13),
                prefixIcon: const Icon(Icons.bed),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<FlightData>(context, listen: false)
                  .getRooms(widget.flight),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].roomNumber),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              Provider.of<FlightData>(context, listen: false)
                                  .deleteroom(snapshot.data![index].roomNumber,
                                      snapshot.data![index].flightHash);
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("No rooms"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ClosedFlightCard extends StatelessWidget {
  const ClosedFlightCard({super.key, required this.flight});

  //The variables are gonna be divided by the width of the screen, so that the text size is relative to the screen size
  //That means that the bigger the number is, the smaller the text will be
  final Flight flight;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buildcontext, constraints) {
      String flightNumber = flight.rute.toString();
      String bodyText =
          "Dest. ${flight.arrivalAirport} \nPlanned: ${DateFormat('kk:mm').format(flight.planned)}";
      bodyText += flight.estimated != null
          ? "\nEstimated: ${DateFormat('kk:mm').format(flight.estimated!)}"
          : "";

      double constraintsvalue =
          min(constraints.maxHeight, constraints.maxWidth);
      double characterslength = bodyText.length.toDouble();
      double bodySize = constraintsvalue / (characterslength * 0.5);

      double titleSize = constraintsvalue / (flightNumber.length);
      double seperatorWidth = constraints.maxWidth * 0.7;
      return Expanded(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: AppTheme.accentColor,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Center(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      Center(
                        child: LayoutBuilder(
                          builder: (context, constraints) => Text(
                            flight.rute.toString(),
                            style: TextStyle(fontSize: titleSize),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 1,
                          color: Colors.black,
                          width: seperatorWidth,
                        ),
                      ),
                      const Center(child: SizedBox(height: 10)),
                      LayoutBuilder(
                        builder: (context, constraints) => Text(
                          "Dest. ${flight.arrivalAirport}",
                          style: TextStyle(fontSize: bodySize),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                      Center(
                        child: LayoutBuilder(
                          builder: (p0, constraints) => Text(
                            "Planned: ${DateFormat('kk:mm').format(flight.planned)}",
                            style: TextStyle(fontSize: bodySize),
                          ),
                        ),
                      ),
                      if (flight.estimated != null &&
                          flight.estimated != flight.planned)
                        Center(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Text(
                                "Estimated: ${DateFormat('kk:mm').format(flight.estimated as DateTime)}",
                                style: TextStyle(fontSize: bodySize),
                              );
                            },
                          ),
                        ),
                      Center(
                        child: Text(
                          "Bus departure: ${DateFormat('kk:mm').format(flight.planned.add(const Duration(minutes: -90)))}",
                          style: TextStyle(fontSize: bodySize),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            if (flight.status.en == "Delayed" ||
                flight.status.en == "Cancelled")
              Positioned(
                top: 0,
                right: constraints.maxWidth,
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
      );
    });
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
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.accentColor,
        title: Text(flight.rute.toString()),
        centerTitle: true,
      ),
      backgroundColor: AppTheme.accentColor,
      //Make a bottom navigation bar that will allow the user to pop the page
      //and return to the previous page

      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlightInformationPage(
                  flight: flight,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  flight.rute.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Destination: ${flight.arrivalAirport}",
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  "Planned: ${DateFormat('kk:mm').format(flight.planned)}",
                  style: const TextStyle(fontSize: 15),
                ),
                if (flight.estimated != null &&
                    flight.estimated != flight.planned)
                  Text(
                    "Estimated: ${DateFormat('kk:mm').format(flight.estimated as DateTime)}",
                    style: const TextStyle(fontSize: 15),
                  ),
                Text(
                  "Bus departure: ${DateFormat('kk:mm').format(flight.planned.add(const Duration(minutes: -90)))}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),

      //Make a column that shows all the fields of flight
    );
  }
}
