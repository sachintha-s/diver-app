import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_app/screens/home%20page/home_page_methods.dart';
import 'package:driver_app/services/auth/auth.dart';
import 'package:driver_app/services/auth/auth_provider.dart';
import 'package:driver_app/services/database/database.dart';
import 'package:driver_app/services/realtime%20databse/realtime_databse.dart';
import 'package:driver_app/shared/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const String GOOGLE_API_KEY = "AIzaSyDsrFjxDz9UJHBVFWYeTY11nli7QOokBGw";
const double CAMERA_ZOOM = 12;
const double CAMERA_TILT = 16;
const double CAMERA_BEARING = 16;
const LatLng SOURCE_LOCATION = LatLng(6.864908099999999, 79.89967890000003);
const LatLng DEST_LOCATION = LatLng(6.841165200000001, 79.9654324);

class DriverHomePage extends StatefulWidget {
  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  //create markers array
  Set<Marker> _markers = Set<Marker>();

  //create instance of google map controller
  Completer<GoogleMapController> _googleMapController = Completer();

  //create polylines array
  Set<Polyline> _polylines = Set<Polyline>();
  PolylinePoints polylinePoints;

  //create polylineCoordinates array
  List<LatLng> polylineCoordinates = [];

  //create boolean varibales for loading states
  bool loadingPickUp = false;
  bool loadingDrop = false;

  //create icons variables for custom marker pins
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  //create variables for grab @pick_up_location and @destination_location address from firestore
  String stringPickupAddress;
  String stringDestinationAddress;

  //create variables for grab @pick_up_location and @destination_location data from firestore
  LatLng pickLocation;
  LatLng destLocation;

  //create variable for get the distance between pickup and destination locations
  double distance;

  //create auth variable
  Auth auth;
  String uid;

  String address = "temp";

  //user's initial location and the current location as it moves
  LocationData currentLocation;
  RealtimeDatabase database;

  //crate globalkey of form
  GlobalKey<FormState> _formKey = GlobalKey();

  Location location;

  StreamSubscription<LocationData> locationSubscription;

  bool isOnline = false;

  @override
  void initState() {
    //create an instance of location
    polylinePoints = PolylinePoints();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //create auth instance
    auth = AuthProvider.of(context).auth;
    auth.currentUser().then((user) {
      uid = user.uid;
      HomePageMethods().getRequest(uid, context);
      print("testinng");
    });

    location = new Location();
  }

  void goOnlineMethod() {
    locationSubscription =
        location.onLocationChanged.listen((LocationData cLoc) async {
      // cLoc contains the lat and long of the current user's position in real time, so we're holding on to it
      currentLocation = cLoc;
      // updatePinOnMap();

      // // set custom marker pins
      // setSourceAndDestinationIcons();
      // // set the initial location
      // setInitialLocation();

      final _coordinates =
          Coordinates(currentLocation.latitude, currentLocation.longitude);

      List<Address> _address =
          await Geocoder.local.findAddressesFromCoordinates(_coordinates);

      if (address == _address[0].locality) {
        try {
          database = RealtimeDatabase(
              lat: cLoc.latitude, long: cLoc.longitude, uid: uid);
          database.updateData(uid, address);
          print(address);
        } catch (e) {
          //create database reference and set data to current location
          database = RealtimeDatabase(
              lat: currentLocation.latitude,
              long: currentLocation.longitude,
              uid: uid);
          database.setData(uid, address);
        }
      } else {
        if (address != 'temp') {
          database = RealtimeDatabase(lat: null, long: null, uid: null);
          database.updateData(uid, address);
        }
        setState(() {
          address = _address[0].locality;
        });
        print("adoooooooooooooo " + address);
      }
    });
  }

  void goOfflineMethod() {
    database = RealtimeDatabase(lat: null, long: null, uid: null);
    database.updateData(uid, address);
    locationSubscription.cancel();
  }

  //create a method to enable button
  bool _isButtonEnabled() {
    if (stringPickupAddress == "Pick Up" ||
        stringDestinationAddress == "Destination" ||
        stringPickupAddress == null ||
        stringDestinationAddress == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);

    if (pickLocation != null) {
      setState(() {
        double targetLat =
            ((pickLocation.latitude - destLocation.latitude) / 2).abs();
        double targetLong =
            ((pickLocation.longitude - destLocation.longitude) / 2).abs();

        initialCameraPosition = CameraPosition(
            target: LatLng(targetLat, targetLong),
            zoom: distance * 0.0011,
            tilt: CAMERA_TILT,
            bearing: CAMERA_BEARING);
      });
    }

    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GoogleMap(
            myLocationEnabled: true,
            compassEnabled: false,
            tiltGesturesEnabled: false,
            markers: _markers,
            polylines: _polylines,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(Utils.mapStyles);
              _googleMapController.complete(controller);
              // my map has completed being created;

              // i'm ready to show the pins on the map
              if (pickLocation != null && destLocation != null) {
                setState(() {
                  HomePageMethods().showPinsOnMap(
                      pickLocation,
                      destLocation,
                      polylinePoints,
                      polylineCoordinates,
                      sourceIcon,
                      destinationIcon,
                      _markers,
                      _polylines);
                });
              }
            }),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white.withOpacity(0.8),
                  child: Center(
                    child: Text(
                      isOnline ? "You're Online" : "You're Offline",
                      style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                    backgroundColor:
                        isOnline ? Colors.white : Colors.tealAccent[400],
                    onPressed: () {
                      if (!isOnline) {
                        goOnlineMethod();
                      } else {
                        goOfflineMethod();
                      }
                      setState(() {
                        isOnline = !isOnline;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      child: Center(
                          child: isOnline
                              ? Text(
                                  "STOP",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  "GO",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: isOnline ? Colors.red : Colors.black,
                              width: 2)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

}
