import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notification_hub/notification_hub.dart';

class WidgetB extends StatefulWidget {
  const WidgetB({super.key});

  @override
  State<WidgetB> createState() => _WidgetBState();
}

class _WidgetBState extends State<WidgetB> {
  late String textContent = '';

  @override
  void initState() {
    super.initState();

    NotificationHub.instance.addSubscriber<String>(
      "Mammals",
      this,
      onData: (data) {
        textContent = data;
        setState(() {});
      },
    );

    NotificationHub.instance.addSubscriber<String>(
      "Insetcs",
      this,
      onData: (data) {
        textContent = data;
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    NotificationHub.instance.removeSubscriber(object: this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150.0,
        // height: 60.0,
        padding: const EdgeInsets.only(left: 5, bottom: 10, right: 5, top: 5),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius:
              BorderRadius.circular(25.0), // Adjust the radius as needed
        ),
        child: Center(
          child: Text(
            'Widget B subscribes to both Mammals and Insects channel \n\n Will recieve ->  $textContent',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800),
          ),
        ));
  }
}
