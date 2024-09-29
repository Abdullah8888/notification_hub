import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notification_hub/notification_hub.dart';

class WidgetA extends StatefulWidget {
  const WidgetA({super.key});

  @override
  State<WidgetA> createState() => _WidgetAState();
}

class _WidgetAState extends State<WidgetA> {
  late String textContent = '';
  late StreamSubscription subscriptionToMammalsChannel;
  @override
  void initState() {
    super.initState();
    subscriptionToMammalsChannel = NotificationHub.instance.addSubscriber(
        channel: "Mammals",
        onData: (event) {
          print('pop');
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
          'Widget A subscribes to Mammals channel \n\n Will recieve ->  $textContent',
          textAlign: TextAlign.center,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
