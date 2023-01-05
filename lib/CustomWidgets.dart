import 'dart:ui';
import 'Esthetics.dart';
import 'package:flutter/material.dart';
import 'package:my_app/FlightAPI.dart';
import 'FlightAPI.dart';
import 'package:intl/intl.dart';
import 'package:flip_card/flip_card.dart';
import 'package:animations/animations.dart';

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
    return Container(
      margin: EdgeInsets.all(8),
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
          back: BackSideofCard(),
        ),
      ),
    );
  }
}

class BackSideofCard extends StatefulWidget {
  const BackSideofCard({super.key});

  @override
  State<BackSideofCard> createState() => _BackSideofCardState();
}

class _BackSideofCardState extends State<BackSideofCard> {
  List<String> rooms = [];
  TextEditingController roomController = TextEditingController();

  void addRoom(String room) {
    setState(() {
      rooms.add(room);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.accentColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: roomController,
              onFieldSubmitted: (value) {
                addRoom(value);
                roomController.clear();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Enter a room: ',
                hintStyle: TextStyle(fontSize: 13),
                prefixIcon: Icon(Icons.bed),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                //return a list tile with the room name and a delete button
                return ListTile(
                  title: Text("• ${rooms[index]}"),
                  trailing: GestureDetector(
                    child: IconButton(
                      //Change the color to red when the icon is pressed
                      color: Colors.red,
                      iconSize: 15,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          rooms.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
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
  final double bodySize = 15;
  final double titleSize = 12;
  final Flight flight;

  @override
  Widget build(BuildContext context) {
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
                          style: TextStyle(
                              fontSize: constraints.maxWidth / titleSize),
                        ),
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
                    LayoutBuilder(
                      builder: (context, constraints) => Text(
                        "Dest. ${flight.arrivalAirport}",
                        style: TextStyle(
                            fontSize: constraints.maxWidth / bodySize),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    Center(
                      child: LayoutBuilder(
                        builder: (p0, constraints) => Text(
                          "Planned: ${DateFormat('kk:mm').format(flight.planned)}",
                          style: TextStyle(
                              fontSize: constraints.maxWidth / bodySize),
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
                              style: TextStyle(
                                  fontSize: constraints.maxWidth / bodySize),
                            );
                          },
                        ),
                      ),
                    Center(
                      child: Text(
                        "Bus departure: ${DateFormat('kk:mm').format(flight.planned.add(const Duration(minutes: -90)))}",
                        style: TextStyle(
                            fontSize: constraints.maxWidth / bodySize),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          if (flight.status.en == "Delayed" || flight.status.en == "Cancelled")
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      flight.status.en == "Delayed" ? Colors.amber : Colors.red,
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
