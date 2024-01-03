import 'package:flutter/material.dart';
import 'package:notification_hub/notification_hub.dart';

class WidgetD extends StatefulWidget {
  const WidgetD({super.key});

  @override
  State<WidgetD> createState() => _WidgetDState();
}

class _WidgetDState extends State<WidgetD> {
  late String textContent = 'Widget D';

  @override
  void initState() {
    super.initState();
    NotificationHub.instance.addSubscriber(this, notificationName: "Mammals",
        onData: (event) {
      setState(() {
        textContent = 'Widget D -> $event';
      });
    }, onDone: (message) {
      debugPrint("$message");
    }, onError: (error) {
      debugPrint(error.toString());
    });

    NotificationHub.instance.addSubscriber(this, notificationName: "Birds",
        onData: (event) {
      setState(() {
        textContent = 'Widget D -> $event';
      });
    }, onDone: (message) {
      debugPrint("$message");
    }, onError: (error) {
      debugPrint(error.toString());
    });
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
      height: 60.0,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius:
            BorderRadius.circular(25.0), // Adjust the radius as needed
      ),
      child: Center(
        child: Text(
          textContent,
          textAlign: TextAlign.center,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
