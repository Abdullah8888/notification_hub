import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notification_hub/notification_hub.dart';
import 'package:provider/provider.dart';

class WidgetC extends StatefulWidget {
  const WidgetC({super.key});

  @override
  State<WidgetC> createState() => _WidgetCState();
}

class _WidgetCState extends State<WidgetC> {
  late String textContent = '';

  @override
  void initState() {
    super.initState();
    NotificationHub.instance.addSubscriber<String>(
      notificationChannel: "Insects",
      object: this,
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
        //height: 60.0,
        padding: const EdgeInsets.only(left: 5, bottom: 10, right: 5, top: 5),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius:
              BorderRadius.circular(25.0), // Adjust the radius as needed
        ),
        child: Center(
          child: Text(
            'Widget C subscribes to Insects channel \n\n Will recieve ->  $textContent',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800),
          ),
        ));
  }
}

class WidgetCC extends StatelessWidget {
  const WidgetCC({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WidgetChangeNotifierC(),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<WidgetChangeNotifierC>(builder: (context, counter, child) {
      return Container(
          width: 150.0,
          //height: 60.0,
          padding: const EdgeInsets.only(left: 5, bottom: 10, right: 5, top: 5),
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius:
                BorderRadius.circular(25.0), // Adjust the radius as needed
          ),
          child: Center(
            child: Text(
              'Widget C subscribes to Insects channel \n\n Will recieve ->  ${context.read<WidgetChangeNotifierC>().textContent}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w800),
            ),
          ));
    });
  }
}

class WidgetChangeNotifierC with ChangeNotifier {
  String? _textContent;
  String? get textContent => _textContent;

  set textContent(String? value) {
    _textContent = value;
    notifyListeners();
  }

  WidgetChangeNotifierC() {
    debugPrint('object');
    NotificationHub.instance.addSubscriber<String>(
      notificationChannel: "Insects",
      object: this,
      onData: (data) {
        textContent = data;
      },
    );
  }

  @override
  void dispose() {
    NotificationHub.instance.removeSubscriber(object: this);
    super.dispose();
  }
}
