import 'package:driver_app/screens/home%20page/home_page_methods.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_core/firebase_core.dart'; not nessecary

class RealtimeDatabase {
  final String driverId;

  RealtimeDatabase({this.driverId});

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
  void setData(lat, long, key, String state) {
    DriverLocationData loc = DriverLocationData(lat, long, driverId);
    locationDataReference.child(state).child("$key").push().set(loc.toJson());
  }

  //update current locationdata
  void updateData(lat, long, key, String state) {
    DriverLocationData loc = DriverLocationData(lat, long, driverId);
    locationDataReference.child(state).child("$key").update(loc.toJson());
  }

  //set current delivery
  void setCurrentDelivery(String userId) {
    CurrentDeliveryData currentDeliveryData =
        CurrentDeliveryData(driverId, userId);
    currentDeliveryReference.child(userId).set(currentDeliveryData.toJson());
  }

  //delete request
  void deleteDriverRequest(
    String driverId,
  ) {
    deliverRequestsReference.child("Drivers").child(driverId).remove();
  }

  //delete request
  void updateDriverRequest(
      String driverId,
      String pickUpAddress,
      String dropAddress,
      double distance,
      double fare,
      double pickLat,
      double pickLong,
      double destLat,
      double destLong,
      String userId) {
    DeliveryRequest request = DeliveryRequest(pickUpAddress, dropAddress,
        distance, fare, pickLat, pickLong, destLat, destLong, userId);
    deliverRequestsReference
        .child("Drivers")
        .child(driverId)
        .update(request.toJson());
  }
}

//create locationData ref class
class DriverLocationData {
  double lat;
  double long;
  String uid;

  DriverLocationData(this.lat, this.long, this.uid);

  DriverLocationData.fromSnapshot(DataSnapshot snapshot)
      : lat = snapshot.value["lat"],
        long = snapshot.value["long"],
        uid = snapshot.value["uid"];

  toJson() {
    return {"lat": lat, "long": long, "uid": uid};
  }
}

class CurrentDeliveryData {
  String driverId;
  String userId;

  CurrentDeliveryData(this.driverId, this.userId);

  CurrentDeliveryData.fromSnapshot(DataSnapshot snapshot)
      : driverId = snapshot.value["driverId"],
        userId = snapshot.value["userId"];

  toJson() {
    return {"driverId": driverId, "userId": userId};
  }
}

class DeliveryRequest {
  String pickUpAddress;
  String dropAddress;
  double distance;
  double fare;
  double pickLat;
  double pickLong;
  double destLat;
  double destLong;
  String userId;

  DeliveryRequest(
      this.pickUpAddress,
      this.dropAddress,
      this.distance,
      this.fare,
      this.pickLat,
      this.pickLong,
      this.destLat,
      this.destLong,
      this.userId);

  DeliveryRequest.fromSnapshot(DataSnapshot snapshot)
      : pickUpAddress = snapshot.value["pickUpAddress"],
        dropAddress = snapshot.value["dropAddress"],
        distance = snapshot.value["distance"],
        fare = snapshot.value["fare"],
        pickLat = snapshot.value["pickLat"],
        pickLong = snapshot.value["pickLong"],
        destLat = snapshot.value["destLat"],
        destLong = snapshot.value["destLong"],
        userId = snapshot.value["userId"];

  toJson() {
    return {
      'pickUpAddress': pickUpAddress,
      'dropAddress': dropAddress,
      'distance': distance,
      'fare': fare,
      'pickLat': pickLat,
      'pickLong': pickLong,
      'destLat': destLat,
      'destLong': destLong,
      'userId': userId
    };
  }
}
