import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser{
  String? displayName;
  String? email;

  AppUser.fromQueryDocumentSnapShot(QueryDocumentSnapshot snapshot){
    displayName = snapshot["displayName"];
    email = snapshot["email"];
  }

}