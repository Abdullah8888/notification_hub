import 'package:flutter/material.dart';
import '../notification_hub_wrapper.dart';

class TestWidgetA extends StatefulWidget {
  const TestWidgetA({super.key});

  @override
  State<TestWidgetA> createState() => _TestWidgetAState();
}

class _TestWidgetAState extends State<TestWidgetA> {
  late String textContent;
  @override
  void initState() {
    super.initState();
    NotificationHubWrapper.instance.addSubscriber(this,
        notificationChannel: "ChannelOne", onData: (event) {
      setState(() {
        textContent = '$event';
      });
    }, onDone: (message) {
      debugPrint("$message");
    }, onError: (error) {
      debugPrint(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TestObjectOne {
  late String textContent;
  TestObjectOne(this.textContent);

  void start() {
    NotificationHubWrapper.instance.addSubscriber(this,
        notificationChannel: "ChannelOne",
        onData: (event) {}, onDone: (message) {
      debugPrint("$message");
    }, onError: (error) {
      debugPrint(error.toString());
    });
  }
}
