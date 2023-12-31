import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notification_hub/notification_hub.dart';

late String notificationName;
late TestWidgetA obj;
late StreamController controller;
late StreamSubscription subscriber;
void main() {
  group('Register subscribers', () {
    setUp(() {
      notificationName = 'NotificationOne';
      obj = const TestWidgetA();
      controller = StreamController();
      subscriber = controller.stream.listen((event) {});
    });

    tearDown(() {
      NotificationHub.instance.removeSubscriber(object: obj);
      NotificationHub.instance.close();
    });

    test('Test should return true if object has been stored', () async {
      NotificationHub.instance.storeObject(notificationName, obj, subscriber);
      final isObjectStored = NotificationHub.instance
          .isObjectStored(channelName: notificationName, obj: obj);

      final doesChannelExist = NotificationHub.instance
          .isChannelExist(channelName: notificationName);
      expect(isObjectStored, true);
      expect(doesChannelExist, true);
    });
  });
}

class TestWidgetA extends StatefulWidget {
  const TestWidgetA({super.key});

  @override
  State<TestWidgetA> createState() => _TestWidgetAState();
}

class _TestWidgetAState extends State<TestWidgetA> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
