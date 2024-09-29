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
  late StreamSubscription subscriptionToMammalsChannel;
  late StreamSubscription subscriptionToInsectsChannel;

  @override
  void initState() {
    super.initState();

    subscriptionToMammalsChannel = NotificationHub.instance.addSubscriber(
        channel: "Mammals",
        onData: (event) {
          setState(() {
            textContent = '$event';
          });
        },
        onDone: () {
          debugPrint("done");
        },
        onError: (error) {
          debugPrint(error.toString());
        });

    subscriptionToInsectsChannel = NotificationHub.instance.addSubscriber(
        channel: "Insects",
        onData: (event) {
          setState(() {
            textContent = '$event';
          });
        },
        onDone: () {
          debugPrint("done");
        },
        onError: (error) {
          debugPrint(error.toString());
        });
  }

  @override
  void dispose() {
    NotificationHub.instance
        .removeSubscriber(subscription: subscriptionToMammalsChannel);
    NotificationHub.instance
        .removeSubscriber(subscription: subscriptionToInsectsChannel);
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
