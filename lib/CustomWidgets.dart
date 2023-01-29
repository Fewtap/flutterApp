import 'package:animations/animations.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Esthetics.dart';
import 'FlightAPI.dart';
import 'package:flutter_html/flutter_html.dart';

class FlightCard extends StatefulWidget {
  final Flight flight;
  const FlightCard({super.key, required this.flight});

  @override
  State<FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<FlightCard> {
  late final FlipCardController flipController;
  final double? bodySize = 12;

  @override
  void initState() {
    super.initState();
    flipController = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        closedColor: AppTheme.accentColor,
        closedShape: //return a rounded rectangle with a shadow
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tappable: false,
        closedBuilder: (context, action) {
          return Container(
            margin: const EdgeInsets.all(8),
            child: Stack(children: [
              Positioned.fill(
                child: FlipCard(
                    onFlipDone:
                        (isFront) => //Unfocus the card when it is flipped
                            !isFront ? FocusScope.of(context).unfocus() : null,
                    direction: FlipDirection.VERTICAL,
                    fill: Fill.fillBack,
                    flipOnTouch: true,
                    controller: flipController,
                    front: Center(
                      child: GestureDetector(
                        onLongPress: () => action(),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //This is the title of the card

                              Text(widget.flight.rute,
                                  style: const TextStyle(fontSize: 26)),
                              //add a seperator
                              Container(
                                width: 75,
                                height: 1,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 10),
                              //This is the planned departure time
                              Text(
                                  "Departure: ${DateFormat.Hm().format(widget.flight.planned)}",
                                  style: TextStyle(fontSize: bodySize)),
                              if (widget.flight.estimated != null)
                                Text(
                                  "Estimated: ${DateFormat.Hm().format(widget.flight.estimated!)}",
                                  style: TextStyle(fontSize: bodySize),
                                ),
                              //This is the planned arrival time
                              Text(
                                widget.flight.estimated != null
                                    ? "Bus Departure: ${DateFormat.Hm().format(widget.flight.estimated!.subtract(const Duration(minutes: 90)))}"
                                    : "Bus Departure: ${DateFormat.Hm().format(widget.flight.planned)}",
                                style: TextStyle(fontSize: bodySize),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    back: const CardBack()),
              ),
            ]),
          );
        },
        openBuilder: (context, action) => Scaffold(
              body: Container(
                height: 200,
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Html(data: """
                            <iframe width="650" height="450"
        src="https://embed.windy.com/embed2.html?lat=68.544&lon=-49.219&detailLat=65.413&detailLon=-52.895&width=100&height=50&zoom=5&level=surface&overlay=wind&product=ecmwf&menu=&message=true&marker=&calendar=now&pressure=&type=map&location=coordinates&detail=true&metricWind=default&metricTemp=default&radarRange=-1"
        frameborder="0"></iframe>"""),
                    ],
                  ),
                ),
              ),
            ));
  }
}

class CardBack extends StatelessWidget {
  const CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: Column(
          children: [
            //A FormTextField with a label and a controller
            TextFormField(
                onTap: () => print("Textfield tapped"),
                decoration: const InputDecoration(
                    labelText: "Enter room: ", icon: Icon(Icons.bed))),
          ],
        ),
      ),
    ]);
  }
}
