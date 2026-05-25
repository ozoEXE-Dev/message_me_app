import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/users_repository.dart';
import '../../data/web_services/auth_service.dart';
import '../../data/web_services/users_web_services.dart';
import '../widgets/chat_line.dart';
import 'welcome_screen.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.chatID});

  static const String screenRoute = "chat_screen";
  String chatID;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  UsersRepository usersRepository = UsersRepository(UsersWebServices());

  final TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 1440),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.orange[800],
            title: Row(
              children: [
                Image.asset("assets/images/logo.png", height: 30),
                SizedBox(width: 10),
                Text("MessageMe", style: TextStyle(color: Colors.white)),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    WelcomeScreen.screenRoute,
                    (route) => false,
                  );
                },
                icon: Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: usersRepository.getMessagesStream(widget.chatID),
                  builder: (context, snapshot) {
                    List<MessageLine> messages = [];

                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    for (var doc in snapshot.data!.docs) {
                      String messageText = doc.get("text");
                      String messageSender = doc.get("sender");
                      MessageLine messageWidget = MessageLine(
                        text: messageText,
                        sender: messageSender,
                        isMe:
                            messageSender ==
                            FirebaseAuth.instance.currentUser!.email,
                      );
                      messages.add(messageWidget);
                    }

                    return Expanded(child: ListView(children: messages));
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.orange, width: 2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: message,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            hintText: "Enter your message",
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          usersRepository.sendMessage(
                            widget.chatID,
                            message.text,
                            AuthRepository(AuthService()).getCurrentUserEmail(),
                          );
                          message.clear();
                        },
                        child: Text(
                          "Send",
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
