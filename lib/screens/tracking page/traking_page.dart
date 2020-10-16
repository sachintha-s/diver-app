import 'dart:async';
import 'package:driver_app/screens/home%20page/home_page.dart';
import 'package:driver_app/services/auth/auth.dart';
import 'package:driver_app/services/auth/auth_provider.dart';
import 'package:driver_app/services/database/database.dart';
import 'package:driver_app/services/realtime%20databse/realtime_database.dart';
import 'package:driver_app/shared/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  final String disance;
  final String fare;
  final String dropAddress;
  final String pickupAddress;

  const DeliveryTrackingPage(
      {Key key,
      @required this.pickUpLocation,
      this.disance,
      this.fare,
      this.dropAddress,
      this.pickupAddress})
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

  bool isConfirm = false;
  bool isCompleate = false;
  String currentDeleveryId;

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
          polylineId: id,
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
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
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
          ),
          Positioned(
            bottom: 25,
            child: _confirmOrCompleateBtn(),
          )
        ],
      ),
    );
  }

  Widget _confirmOrCompleateBtn() {
    return InkWell(
      onTap: () {
        //dtabase query for store delivery data
        if (!isConfirm) {
          showSheet("Are You Sure?",
                  "If you have accept order from user please Comfirm.")
              .then((value) {
            if (value) {
              Database(uid: uid)
                  .setDeliveryData(widget.disance, widget.dropAddress,
                      widget.pickupAddress, widget.fare, true, false)
                  .then((value) {
                currentDeleveryId = value.id;
              });
              setState(() {
                isConfirm = true;
              });
              //now we should change driver and user map
            }
          });
        } else {
          showSheet(
                  "Are You Sure?", "If you have Completed order Please Confirm.")
              .then((value) {
            if (value) {
              //data base query for update
              Database(uid: uid).updateDeliverState(currentDeleveryId);
              setState(() {
                isCompleate = true;
              });
              //send massage to user for inform the delivery has compleated.


              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DriverHomePage()));
            }
          });
        }
      },
      child: !(isConfirm && isCompleate)
          ? Container(
              alignment: Alignment.center,
              child: Text(
                !isConfirm
                    ? "Confirm Document"
                    : !isCompleate
                        ? "Completed"
                        : "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 50,
              width: 250,
            )
          : SizedBox(),
    );
  }

  Future showSheet(String title, String des) async {
    return await showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10,),
                    child: Text(
                      des,
                      softWrap: true,
                    )),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: RaisedButton(
                            child: Text(
                              "CONFIRM",
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: RaisedButton(
                            child: Text(
                              "CANCEL",
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
