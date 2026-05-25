import 'package:cloud_firestore/cloud_firestore.dart';

class UsersWebServices {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<List> getAllUsers() async {
    QuerySnapshot snapshot = await fireStore.collection("users").get();
    List<QueryDocumentSnapshot> users = snapshot.docs;
    return users;
  }

  Future<void> addUser(String displayName, String email, String uID) async {
    DocumentSnapshot doc = await fireStore.collection("users").doc(uID).get();

    if (!doc.exists) {
      await fireStore.collection("users").doc(uID).set({
        "displayName": displayName.trim(),
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> isDisplayNameUnique(String displayName) async {
    try {
      QuerySnapshot snapshot = await fireStore
          .collection("users")
          .where("displayName", isEqualTo: displayName)
          .get();
      return !snapshot.docs.first.exists;
    } catch (e) {
      print(e.toString());
      return true;
    }
  }

  Stream<QuerySnapshot> getMessagesStream(String id) {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(id)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future sendMessage(String id, String message, String sender) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(id)
        .collection("messages")
        .add({
          "text": message,
          "sender": sender,
          "time": FieldValue.serverTimestamp(),
        });
  }

  Future createChatDocument(String chatID) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection("chats")
        .doc(chatID);
    DocumentSnapshot doc = await docRef.get();
    if (!doc.exists) {
     await docRef.set({
        "timeCreated": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
}
