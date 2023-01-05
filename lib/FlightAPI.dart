// ignore: file_names
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class FlightData extends ChangeNotifier {
  String jsonString = '';

  int amountCalled = 0;
  bool active = false;
  List<Flight> flights = <Flight>[];

  FlightData();

  Future<void> getFlights() async {
    flights = [];
    notifyListeners();
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();

    List<Flight> tempflights = <Flight>[];
    amountCalled++;
    print("Amount called $amountCalled");

    var url = Uri.parse(
        "https://www.mit.gl/wp-content/themes/mitgl/webservice.php?type=Departures&icao=BGJN");

    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.statusCode);
      active = false;

      if (response.body != '[]') {
        List<dynamic> json = jsonDecode(response.body);
        tempflights = json.map((e) => Flight.fromJson(e)).toList();
        print("body OK");

        print(amountCalled.toString());
        tempflights = tempflights
            .where((element) => element.planned.day == DateTime.now().day)
            .toList();

        tempflights.forEach((element) {
          element.planned = element.planned.toLocal();
          if (element.estimated != null) {
            element.estimated = element.estimated!.toLocal();
          }
        });
        active = false;
        stopwatch.stop();
        print("Elapsed time: ${stopwatch.elapsedMilliseconds}");
        flights = tempflights;
        notifyListeners();
        //print how many listeners are listening to the notifier
        print("Listeners: ${this.hasListeners}");
      }
    } else {
      var statusCode = response.statusCode;
      var content = response.body;
      throw Future.error(
        StatusNotOKException(
            "Status code is not ok, Status code: $statusCode\nBody: $content "),
      );
    }
  }
}

class Flight {
  late String rute;
  late String departureAirport;
  late String arrivalAirport;
  late DateTime planned;
  DateTime? estimated;
  DateTime? actual;
  late Status status;
  late String flightHash;
  late String arrivalICAO;
  late String departureICAO;

  Flight.fromJson(Map<String, dynamic> json) {
    rute = json['Rute'];
    departureAirport = json['DepartureAirport'];
    arrivalAirport = json['ArrivalAirport'];
    planned = DateTime.parse(json['Planned']);
    if (json['Estimated'] != null) {
      estimated = DateTime.parse(json['Estimated']);
    }
    if (json['Actual'] != null) {
      actual = DateTime.parse(json['Actual']);
    }
    status = (json['Status'] != null ? Status.fromJson(json['Status']) : null)!;
    flightHash = json['FlightHash'];
    arrivalICAO = json['ArrivalICAO'];
    departureICAO = json['DepartureICAO'];
  }
  Map<String, dynamic> toJson() {
    var json = {
      'Rute': rute,
      'DepartureAirport': departureAirport,
      'ArrivalAirport': arrivalAirport,
      'Planned': planned.toIso8601String(),
    };

    json['Estimated'] = estimated?.toIso8601String() ?? "";

    json['Actual'] = actual?.toIso8601String() ?? "";

    json['Status'] = status.toJson();

    json['FlightHash'] = flightHash;
    json['ArrivalICAO'] = arrivalICAO;
    json['DepartureICAO'] = departureICAO;
    return json;
  }

  @override
  String toString() {
    return "$rute $arrivalAirport \n$planned";
  }
}

class Status {
  String kl = '';
  String en = '';
  String da = '';

  Status(this.kl, this.en, this.da);

  Status.fromJson(Map<String, dynamic> json) {
    kl = json['kl'];
    en = json['en'];
    da = json['da'];
  }

  String toJson() {
    var json = {'kl': kl, 'en': en, 'da': da};
    return jsonEncode(json);
  }
}

class StatusNotOKException implements Exception {
  final String message;
  StatusNotOKException(this.message);

  @override
  String toString() {
    return "StatusNotOKException: $message";
  }
}
