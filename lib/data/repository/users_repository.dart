import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../web_services/users_web_services.dart';

class UsersRepository {
  UsersWebServices usersWebServices;

  UsersRepository(this.usersWebServices);

  Future<List<AppUser>> getAllUsers() async {
    List appUsers = await usersWebServices.getAllUsers();
    return appUsers
        .map((element) => AppUser.fromQueryDocumentSnapShot(element))
        .toList();
  }

  Future<void> addUser(String displayName, String email, String uID) async {
    usersWebServices.addUser(displayName, email, uID);
  }

  Future<bool> isDisplayNameUnique(String displayName) async {
    return await usersWebServices.isDisplayNameUnique(displayName);
  }

  Stream<QuerySnapshot> getMessagesStream(String id) {
    return usersWebServices.getMessagesStream(id);
  }

  Future sendMessage(String id, String message, String sender) async {
    usersWebServices.sendMessage(id, message, sender);
  }

  Future createChatDocument(String chatID) async {
    usersWebServices.createChatDocument(chatID);
  }
}
