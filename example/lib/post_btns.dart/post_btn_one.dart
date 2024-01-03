import 'package:flutter/material.dart';
import 'package:notification_hub/notification_hub.dart';

class PostButtonOne extends StatefulWidget {
  const PostButtonOne({super.key});

  @override
  State<PostButtonOne> createState() => _PostButtonOneState();
}

class _PostButtonOneState extends State<PostButtonOne> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          NotificationHub.instance
              .post(notificatonChannel: "Mammals", data: "Cat");
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Colors.blueAccent), // Set your desired background color
        ),
        child: const Padding(
          padding: EdgeInsets.all(3.0),
          child: Text(
            'Post Cat',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
