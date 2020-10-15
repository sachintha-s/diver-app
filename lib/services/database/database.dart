import "package:cloud_firestore/cloud_firestore.dart";

class Database {
  String uid;

  Database({this.uid});

  final CollectionReference customerData =
      FirebaseFirestore.instance.collection('Driver');

  Future setUserData(
      String firstName,
      String lastName,
      String addressLine1,
      String addressLine2,
      String addressLine3,
      String email,
      var mobile) async {
    await customerData.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'addressLine3': addressLine3,
      'mobileNo': mobile,
      'email': email,
      'uid': uid,
    });
  }

  Future updateUserName(String userName) async {
    return await customerData.doc(uid).update({
      'userName': userName,
    });
  }

  //add delivery data to driver
  Future setDeliveryData(String distance, String dropAddress,String pickup,
      String fare, bool isDocumentAccept, bool isComplete) async {
    return await customerData.doc(uid).collection("deliveryData").add({
     
        "distance":distance,
        "dropAddress":dropAddress,
        "pickupAddress":pickup,
        "fare":fare,
        "isDocumentAccept":isDocumentAccept,
        "isComplete":isComplete,
    });
  }

  Future<QuerySnapshot> searchUserData(String firstName) async {
    return await customerData.where('firstName', isEqualTo: firstName).get();
  }

  Future<QuerySnapshot> getUserData() async {
    return await customerData.get();
  }

  Future<QuerySnapshot> getMobileData(String uid) async {
    return await customerData.where('uid', isEqualTo: uid).get();
  }

  //get delivery request
  Future<QuerySnapshot> getTripRequest(String uid) async {
    return await customerData.doc(uid).collection("deliveryRequest").get();
  }
}
