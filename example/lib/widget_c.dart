import 'package:flutter/material.dart';
import 'package:notification_hub/notification_hub.dart';

class WidgetC extends StatefulWidget {
  const WidgetC({super.key});

  @override
  State<WidgetC> createState() => _WidgetCState();
}

class _WidgetCState extends State<WidgetC> {
  late String textContent = 'Widget C';

  @override
  void initState() {
    super.initState();
    NotificationHub.instance.addSubscriber(this, notificationName: "Insects",
        onData: (event) {
      setState(() {
        textContent = 'Widget C -> Bees';
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
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800),
          ),
        ));
  }
}
