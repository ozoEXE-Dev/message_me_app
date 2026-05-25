import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/users_repository.dart';
import '../../data/web_services/auth_service.dart';
import '../../data/web_services/users_web_services.dart';
import '../screens/chat_screen.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.name, required this.email});

  final String name;
  final String email;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      onTap: () {
        UsersRepository(UsersWebServices()).createChatDocument(
          getChatID(email, AuthRepository(AuthService()).getCurrentUserEmail()),
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ChatScreen(
                chatID: getChatID(
                  email,
                  FirebaseAuth.instance.currentUser!.email!,
                ),
              );
            },
          ),
        );
      },
      leading: Icon(Icons.person, size: 40, color: Colors.blue[900]),
      title: Text(name, style: TextStyle(color: Colors.black, fontSize: 20)),
      subtitle: Text(
        email,
        style: TextStyle(color: Colors.blue[900], fontSize: 16),
      ),
    );
  }
}

String getChatID(String email1, String email2) {
  List<String> IDS = [email1, email2];
  IDS.sort();
  return IDS.join("_");
}
