import 'package:flutter/material.dart';
import 'package:notification_hub/notification_hub.dart';

class PostButtonTwo extends StatefulWidget {
  const PostButtonTwo({super.key});

  @override
  State<PostButtonTwo> createState() => _PostButtonTwoState();
}

class _PostButtonTwoState extends State<PostButtonTwo> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          NotificationHub.instance.post(channelName: "Insects", data: "Bees");
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
