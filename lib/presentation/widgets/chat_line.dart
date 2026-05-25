import 'package:flutter/material.dart';

class MessageLine extends StatelessWidget {
  MessageLine({super.key, required this.text, required this.sender, required this.isMe});

  final String text;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(color: Colors.yellow[900], fontSize: 12)),
          Material(
            borderRadius: isMe? BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ) : BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ) ,
            elevation: 5,
            color: isMe? Colors.blue[800] : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(text, style: TextStyle(color: isMe? Colors.white : Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}