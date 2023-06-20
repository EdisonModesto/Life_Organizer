import 'package:cloud_firestore/cloud_firestore.dart';

import 'AuthService.dart';

class FirestoreService{
  void createUser(){
    FirebaseFirestore.instance.collection("Users").doc(AuthService().getID()).set({
      "Name": "User",
      "Photo": "",
    });
  }

  void updateUser(id, name, photo){
    FirebaseFirestore.instance.collection("Users").doc(id).update({
      "Name": name,
      "Photo": photo,
    });
  }


  void addRecord(DateTime startDate, DateTime endDate, String eventName, String eventNote, List<String> eventImage){
    FirebaseFirestore.instance.collection("Users").doc(AuthService().getID()).collection("Events").add({
      "StartDate": startDate,
      "EndDate": endDate,
      "EventName": eventName,
      "EventNote": eventNote,
      "EventPicture": eventImage,
    });
  }

  void updateRecord(DateTime startDate, DateTime endDate, String eventName, String eventNote, List<String> eventImage, id){
    FirebaseFirestore.instance.collection("Users").doc(AuthService().getID()).collection("Events").doc(id).update({
      "StartDate": startDate,
      "EndDate": endDate,
      "EventName": eventName,
      "EventNote": eventNote,
      "EventPicture": eventImage,
    });
  }

  void deleteRecord(id){
    FirebaseFirestore.instance.collection("Users").doc(AuthService().getID()).collection("Events").doc(id).delete();
  }
}