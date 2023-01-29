// ignore: file_names
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class FlightData extends ChangeNotifier {
  String jsonString = '';
  List<Room> rooms = <Room>[];
  int amountCalled = 0;
  bool active = false;
  List<Flight> flights = <Flight>[];

  FlightData() {
    //start a timer to get the flights every 5 minutes
    Timer.periodic(const Duration(minutes: 5), (timer) {
      getFlights();
    });
  }

  Future<void> deleteroom(String roomnumber, String flightHash) async {
    bool success = false;
    try {
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      success = true;
    } catch (e) {
      print(e);
    } finally {
      if (success) {
        print("Firebase initialized");
      }
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    //delete the room from firestore where the flighthash and the roomnumber match
    var room = await firestore
        .collection("rooms")
        .where("FlightHash", isEqualTo: flightHash)
        .where("RoomNumber", isEqualTo: roomnumber)
        .get();

    room.docs.forEach((element) {
      element.reference.delete();
    });

    notifyListeners();
    //
  }

  Future<void> addRoom(String roomnumber, String flighthash) async {
    bool success = false;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      success = true;
    } catch (e) {
      print(e);
    } finally {
      if (success) {
        print("Firebase initialized");
      }
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("rooms").add({
      "RoomNumber": roomnumber,
      "FlightHash": flighthash,
    });

    notifyListeners();
  }

  Future<List<Room>> getRooms(Flight flight) async {
    bool success = false;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      success = true;
    } catch (e) {
      print(e);
    } finally {
      if (success) {
        print("Firebase initialized");
      }
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    //Get all the rooms that has the same flight hash as the flight
    QuerySnapshot<Map<String, dynamic>> roomsstore = await firestore
        .collection("rooms")
        .where("FlightHash", isEqualTo: flight.flightHash)
        .get();
    List<Room> temprooms =
        roomsstore.docs.map((e) => Room.fromJson(e.data())).toList();
    return temprooms;
  }

  Future<void> getFlights() async {
    bool success = false;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      success = true;
    } catch (e) {
      print(e);
    } finally {
      if (success) {
        print("Firebase initialized");
      }
    }

    //create a client for firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    //get all the flights from firestore that has a timestamp that is today
    QuerySnapshot<Map<String, dynamic>> flightsstore = await firestore
        .collection("flights")
        .where("Planned",
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1))))
        .where("Planned",
            isLessThanOrEqualTo:
                Timestamp.fromDate(DateTime.now().add(Duration(days: 1))))
        .get();
    //foreach flight in the querysnapshot, create a flight object and add it to the list
    List<Flight> tempflights =
        flightsstore.docs.map((e) => Flight.fromJson(e.data())).toList();
    //sort the list by planned time
    tempflights.sort((a, b) => a.planned.compareTo(b.planned));
    //set the flights to the list
    flights = tempflights;

    notifyListeners();
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();

    amountCalled++;

    /*var url = Uri.parse(
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
      );*/
  }
}

class Room {
  late String roomNumber;
  late String flightHash;

  Room.fromJson(Map<String, dynamic> json) {
    roomNumber = json['RoomNumber'];
    flightHash = json['FlightHash'];
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
    Timestamp ts = json['Planned'];
    planned = ts.toDate();
    if (json['Estimated'] != null) {
      Timestamp t = json['Estimated'];
      estimated = t.toDate();
    }
    if (json['Actual'] != null) {
      Timestamp t = json['Actual'];
      actual = t.toDate();
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
