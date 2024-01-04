import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'notification_hub_wrapper.dart';
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
      NotificationHubWrapper.instance.removeSubscriber(object: obj);
      NotificationHubWrapper.instance.close();
    });

    test('Test should add a subscription with an objectID to a channel',
        () async {
      NotificationHubWrapper.instance
          .addSubscriber(obj, notificationChannel: notificationChannel);

      final isObjectStored = NotificationHubWrapper.instance
          .isObjectStored(channelName: notificationChannel, obj: obj);

      final doesChannelExist = NotificationHubWrapper.instance
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
      NotificationHubWrapper.instance.close();
    });

    test('Test should remove subscriber', () async {
      NotificationHubWrapper.instance
          .addSubscriber(obj, notificationChannel: notificationChannel);

      var isObjectStored = NotificationHubWrapper.instance
          .isObjectStored(channelName: notificationChannel, obj: obj);

      expect(isObjectStored, true); // Before removing the subscriber

      NotificationHubWrapper.instance.removeSubscriber(object: obj);

      isObjectStored = NotificationHubWrapper.instance
          .isObjectStored(channelName: notificationChannel, obj: obj);

      expect(isObjectStored, false); // After removing the subscriber
    });
  });
}
