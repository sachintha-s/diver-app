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
// const LatLng SOURCE_LOCATION = LatLng(6.864908099999999, 79.89967890000003);
// const LatLng DEST_LOCATION = LatLng(6.841165200000001, 79.9654324);

class DeliveryTrackingPage extends StatefulWidget {
  final LatLng pickUpLocation;

  const DeliveryTrackingPage({Key key, @required this.pickUpLocation})
      : super(key: key);
  @override
  _DeliveryTrackingPageState createState() => _DeliveryTrackingPageState();
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  //create markers array
  Set<Marker> _markers = Set<Marker>();

  //create instance of google map controller
  Completer<GoogleMapController> _googleMapController = Completer();

  //create polylines array
  Set<Polyline> _polylines = Set<Polyline>();
  PolylinePoints polylinePoints;

  //create polylineCoordinates array
  List<LatLng> polylineCoordinates = [];

  //create icons variables for custom marker pins
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  //create auth variable
  Auth auth;
  String uid;

  String address = "temp";

  double distance;

  //user's initial location and the current location as it moves
  LocationData currentLocation;
  RealtimeDatabase database;

  //crate globalkey of form
  GlobalKey<FormState> _formKey = GlobalKey();

  Location location;

  StreamSubscription<LocationData> locationSubscription;

  bool isOnline = false;

  LatLng driverCurrentLocation;
  LatLng pickUpLocation;

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
      print("testinng");
    });
    location = new Location();
    pickUpLocation = widget.pickUpLocation;
    showPinsOnMap();
    // setPolylines(driverCurrentLocation, pickUpLocation, polylinePoints,
    //     polylineCoordinates, _polylines);
  }

  void showPinsOnMap() {
    pickUpLocation =
        LatLng(widget.pickUpLocation.latitude, widget.pickUpLocation.longitude);

    // get a LatLng out of the LocationData object
    var destPosition = pickUpLocation;

    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));

    locationSubscription =
        location.onLocationChanged.listen((LocationData cLoc) async {
      // cLoc contains the lat and long of the current user's position in real time, so we're holding on to it
      currentLocation = cLoc;

      driverCurrentLocation = LatLng(cLoc.latitude, cLoc.longitude);

      var pinPosition = driverCurrentLocation;

      // add the initial source location pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition,
          icon: sourceIcon));

      // set the route lines on the map from source to destination for more info follow this tutorial
      setState(() {
        setPolylines(driverCurrentLocation, pickUpLocation, polylinePoints,
            polylineCoordinates, _polylines);
      });
    });
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

      PolylineId id = PolylineId("poly");
      _polylines.add(Polyline(
          width: 5, // set the width of the polylines
          polylineId:id,
          visible: true,
          jointType: JointType.round,
          startCap: Cap.buttCap,
          endCap: Cap.buttCap,
          geodesic: true,
          color: Colors.black,
          points: polylineCoordinates));
    }
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: widget.pickUpLocation);

    // if (driverCurrentLocation != null) {
    //   distance = GeolocatorPlatform.instance.distanceBetween(
    //       driverCurrentLocation.latitude,
    //       driverCurrentLocation.longitude,
    //       pickUpLocation.latitude,
    //       pickUpLocation.longitude);
    //   setState(() {
    //     initialCameraPosition = CameraPosition(
    //         target: LatLng(driverCurrentLocation.latitude,
    //             driverCurrentLocation.longitude),
    //         zoom: distance * 0.00001,
    //         tilt: CAMERA_TILT,
    //         bearing: CAMERA_BEARING);
    //   });
    // }

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
              showPinsOnMap();
            }),
        FlatButton(
            onPressed: () {
              print(widget.pickUpLocation);
            },
            child: Container(
              height: 50,
              width: 100,
            ))
      ],
    ));
  }
}
