import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'mock_notification_hub.dart';
import 'test_widgets/test_widget_a.dart';

late String notificationChannel;
late TestWidgetA obj;
late StreamController controller;
late StreamSubscription subscriber;
void main() {
  group('Map subscriber with an object ID to a notification channel', () {
    setUp(() {
      notificationChannel = 'ChannelOne';
      obj = const TestWidgetA();
    });

    tearDown(() {
      MockNotificationHub.instance.removeSubscriber(object: obj);
      MockNotificationHub.instance.close();
    });

    test('Test should add a subscription with an objectID to a channel',
        () async {
      MockNotificationHub.instance
          .addSubscriber(obj, notificationChannel: notificationChannel);

      final isObjectStored = MockNotificationHub.instance
          .isObjectStored(channelName: notificationChannel, obj: obj);

      final doesChannelExist = MockNotificationHub.instance
          .doesChannelExist(channelName: notificationChannel);
      expect(isObjectStored, true);
      expect(doesChannelExist, true);
    });
  });

  group('Remove subscriber', () {
    setUp(() {
      notificationChannel = 'ChannelOne';
      obj = const TestWidgetA();
    });

    tearDown(() {
      MockNotificationHub.instance.close();
    });

    test('Test should remove subscriber', () async {
      MockNotificationHub.instance
          .addSubscriber(obj, notificationChannel: notificationChannel);

      var isObjectStored = MockNotificationHub.instance
          .isObjectStored(channelName: notificationChannel, obj: obj);

      expect(isObjectStored, true); // Before removing the subscriber

      MockNotificationHub.instance.removeSubscriber(object: obj);

      isObjectStored = MockNotificationHub.instance
          .isObjectStored(channelName: notificationChannel, obj: obj);

      expect(isObjectStored, false); // After removing the subscriber
    });
  });
}
