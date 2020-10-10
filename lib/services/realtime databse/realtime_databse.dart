import 'package:driver_app/screens/home%20page/home_page_methods.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_core/firebase_core.dart'; not nessecary

class RealtimeDatabase {
  final double long;
  final double lat;
  final String uid;

  RealtimeDatabase({this.lat, this.long, this.uid});

  //Rather then just writing FirebaseDatabase(), get the instance.
  DatabaseReference locationDataReference =
      FirebaseDatabase.instance.reference().child('Onine Drivers');

  DatabaseReference currentDeliveryReference =
      FirebaseDatabase.instance.reference().child('Current Delivery');

  DatabaseReference deliverRequestsReference =
      FirebaseDatabase.instance.reference().child('Delivery Request');

  //get push key
  String getKey() {
    return locationDataReference.push().key;
  }

  void deleteChild(String id, String address) {
    locationDataReference.child(address).child(id).remove();
  }

  //set current locationdata
  void setData(key, String state) {
    LocationDataMy loc = LocationDataMy(lat, long, uid);
    locationDataReference.child(state).child("$key").push().set(loc.toJson());
  }

  //update current locationdata
  void updateData(key, String state) {
    LocationDataMy loc = LocationDataMy(lat, long, uid);
    locationDataReference.child(state).child("$key").update(loc.toJson());
  }

  //set current delivery
  void setCurrentDelivery() {
    CurrentDeliveryData currentDeliveryData = CurrentDeliveryData(uid);
    currentDeliveryReference.child(uid).set(currentDeliveryData.toJson());
  }

  //delete request
  void updateDriverRequest(String _did, String pickUpAddress,
      String dropAddress, double distance, double fare) {
    DeliveryRequest request =
        DeliveryRequest(pickUpAddress, dropAddress, distance, fare);
    deliverRequestsReference
        .child("Drivers")
        .child(_did)
        .update(request.toJson());
  }
}

//create locationData ref class
class LocationDataMy {
  double lat;
  double long;
  String uid;

  LocationDataMy(this.lat, this.long, this.uid);

  LocationDataMy.fromSnapshot(DataSnapshot snapshot)
      : lat = snapshot.value["lat"],
        long = snapshot.value["long"],
        uid = snapshot.value["uid"];

  toJson() {
    return {"lat": lat, "long": long, "uid": uid};
  }
}

class CurrentDeliveryData {
  String uid;

  CurrentDeliveryData(this.uid);

  CurrentDeliveryData.fromSnapshot(DataSnapshot snapshot)
      : uid = snapshot.value["uid"];

  toJson() {
    return {"uid": uid};
  }
}

class DeliveryRequest {
  String pickUpAddress;
  String dropAddress;
  double distance;
  double fare;

  DeliveryRequest(
    this.pickUpAddress,
    this.dropAddress,
    this.distance,
    this.fare,
  );

  DeliveryRequest.fromSnapshot(DataSnapshot snapshot)
      : pickUpAddress = snapshot.value["pickUpAddress"],
        dropAddress = snapshot.value["dropAddress"],
        distance = snapshot.value["distance"],
        fare = snapshot.value["fare"];

  toJson() {
    return {
      'pickUpAddress': pickUpAddress,
      'dropAddress': dropAddress,
      'distance': distance,
      'fare': fare,
    };
  }
}
