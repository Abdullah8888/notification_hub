import 'package:flutter/material.dart';
import 'package:notification_hub/notification_hub.dart';

class PostButtonThree extends StatefulWidget {
  const PostButtonThree({super.key});

  @override
  State<PostButtonThree> createState() => _PostButtonThreeState();
}

class _PostButtonThreeState extends State<PostButtonThree> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          NotificationHub.instance
              .post(notificatonChannel: "Insects", data: "Bees");
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Colors.blueAccent), // Set your desired background color
        ),
        child: const Text(
          'Post Bees',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ));
  }
}
