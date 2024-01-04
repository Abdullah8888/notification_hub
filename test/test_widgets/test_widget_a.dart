import 'package:flutter/material.dart';

class TestWidgetA extends StatefulWidget {
  const TestWidgetA({super.key});

  @override
  State<TestWidgetA> createState() => _TestWidgetAState();
}

class _TestWidgetAState extends State<TestWidgetA> {
  // late String textContent;
  // @override
  // void initState() {
  //   super.initState();
  //   print("lalalala");
  //   MockNotificationHub.instance
  //       .addSubscriber(this, notificationName: "ChannelOne", onData: (event) {
  //     setState(() {
  //       textContent = '$event';
  //     });
  //   }, onDone: (message) {
  //     debugPrint("$message");
  //   }, onError: (error) {
  //     debugPrint(error.toString());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
