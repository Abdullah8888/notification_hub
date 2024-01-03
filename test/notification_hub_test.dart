import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mock_notification_hub.dart';

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
      MockNotificationHub.instance.removeSubscriber(object: obj);
      MockNotificationHub.instance.close();
    });

    test('Test should return true if object has been stored', () async {
      MockNotificationHub.instance
          .storeObject(notificationName, obj, subscriber);
      final isObjectStored = MockNotificationHub.instance
          .isObjectStored(channelName: notificationName, obj: obj);

      final doesChannelExist = MockNotificationHub.instance
          .doesChannelExist(channelName: notificationName);
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
