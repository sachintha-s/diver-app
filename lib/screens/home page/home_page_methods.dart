import 'dart:async';

import 'package:driver_app/screens/tracking%20page/traking_page.dart';
import 'package:driver_app/services/database/database.dart';
import 'package:driver_app/services/realtime%20databse/realtime_databse.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const String GOOGLE_API_KEY = "AIzaSyDsrFjxDz9UJHBVFWYeTY11nli7QOokBGw";

class HomePageMethods {
  void showPinsOnMap(
      dynamic pickLocation,
      dynamic destLocation,
      PolylinePoints polylinePoints,
      List<LatLng> polylineCoordinates,
      BitmapDescriptor sourceIcon,
      BitmapDescriptor destinationIcon,
      Set<Marker> _markers,
      Set<Polyline> _polylines) {
    var pinPosition = pickLocation;

    // get a LatLng out of the LocationData object
    var destPosition = destLocation;

    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon));

    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));

    // set the route lines on the map from source to destination for more info follow this tutorial
    setPolylines(pickLocation, destLocation, polylinePoints,
        polylineCoordinates, _polylines);
  }

  void getRequest(
      String uid,
      BuildContext context,
      startTimer,
      _settingModalBottomSheet(
    context,
    String pickUpAddress,
    String dropAddress,
    double distance,
    int fare,
    String uid,
    LatLng pickUpLocation,
  )) {
    try {
      DatabaseReference deliverRequestsReference = FirebaseDatabase.instance
          .reference()
          .child('Delivery Request')
          .child("Drivers");

      bool isNotTriggered = true;

      StreamSubscription<Event> deliverRequestsSubscription;
      deliverRequestsSubscription = deliverRequestsReference
          .child(uid)
          .onChildAdded
          .listen((event) async {
        if (isNotTriggered) {
          print("Request has been sent");
          isNotTriggered = !isNotTriggered;
          DataSnapshot dataSnapshot = await deliverRequestsReference
              .child(uid)
              .once()
              .then((value) => value);

          String pickUpAddress = dataSnapshot.value["pickUpAddress"];
          String dropAddress = dataSnapshot.value["dropAddress"];
          double distance = dataSnapshot.value["distance"];
          int fare = dataSnapshot.value["fare"];

          LatLng pickUpLocation = LatLng(
              dataSnapshot.value["pickLat"], dataSnapshot.value["pickLong"]);
          // LatLng destLocation = LatLng(
          //     dataSnapshot.value["destLat"], dataSnapshot.value["destLong"]);

          _settingModalBottomSheet(
            context,
            pickUpAddress,
            dropAddress,
            distance,
            fare,
            uid,
            pickUpLocation,
          );
        }

        startTimer;

        await Future.delayed(Duration(seconds: 15));
        try {
          if (Navigator.of(context).canPop()) {
            Navigator.pop(context);
            getRequest(uid, context, startTimer, _settingModalBottomSheet);
          }
        } catch (e) {
          print(e);
        }
        isNotTriggered = !isNotTriggered;

        print("Request expired");
      });
    } catch (e) {
      print(e);
    }
  }

  void setPolylines(
      dynamic pickLocation,
      dynamic destLocation,
      PolylinePoints polylinePoints,
      List<LatLng> polylineCoordinates,
      Set<Polyline> _polylines) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_API_KEY,
      PointLatLng(pickLocation.latitude, pickLocation.longitude),
      PointLatLng(destLocation.latitude, destLocation.longitude),
    );

    print(pickLocation.latitude + pickLocation.longitude);
    print(destLocation.latitude + destLocation.longitude);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      _polylines.add(Polyline(
          width: 10, // set the width of the polylines
          polylineId: PolylineId("poly"),
          visible: true,
          color: Colors.black,
          points: polylineCoordinates));
    }
  }

  Future<String> getCurrentAddress(currentLocation) async {
    final _coordinates =
        Coordinates(currentLocation.latitude, currentLocation.longitude);

    List<Address> address =
        await Geocoder.local.findAddressesFromCoordinates(_coordinates);

    return address[0].locality;

    //admin area - califonia
    //feature name -1660
    //locality - mount view
  }

  Widget buttonModel(
      BuildContext context,
      bool _isButtonEnabled(),
      String stringPickupAddress,
      String stringDestinationAddress,
      double distance,
      String uid) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 40,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {},
        //_isButtonEnabled()
        //     ? () async {
        //         await Database().setPickUpData(0, 0, null, null, uid);
        //         await Database().setDestinationData(0, 0, null, null, uid);
        //         Navigator.push(context, MaterialPageRoute(builder: (context) {
        //           return TripDetails(
        //             destination: stringDestinationAddress,
        //             pickup: stringPickupAddress,
        //             distance: distance,
        //             uid: uid,
        //           );
        //         }));
        //       }
        //     : null,
        disabledColor: Colors.grey,
        color: Colors.tealAccent[400],
        child: Text(
          "CONTINUE",
          style: TextStyle(fontSize: 19, letterSpacing: 2, color: Colors.white),
        ),
      ),
    );
  }
}
