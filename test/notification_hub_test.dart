import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:notification_hub/notification_hub.dart';

import 'notification_hub_extension.dart';

late NotificationHub notificationHub;
void main() {
  group('NotificationHub', () {
    setUp(() {
      notificationHub = NotificationHub.instance;
    });

    tearDown(() {
      notificationHub.removeSubscriber(object: 'Observer1');
      final check = notificationHub.doesSubscriptionExit("Observer1");
      expect(check, false);
    });

    test('should notify observers when a notification is posted', () async {
      // Aarange
      final completer = Completer<void>();

      void observerCallback(String data) {
        completer.complete();
      }

      // Add an observer to "ChannelA"
      notificationHub.addSubscriber<String>(
        notificationChannel: 'ChannelA',
        object: 'Observer1', // Unique identifier for this observer
        onData: (data) {
          observerCallback.call(data);
        },
      );

      // Act
      notificationHub.post<String>(
          notificationChannel: 'ChannelA', data: 'Test Data');

      // Assert
      await expectLater(
        completer.future,
        completes,
        reason: 'The notification was not received within the timeout',
      ).timeout(const Duration(seconds: 2), onTimeout: () {
        throw TimeoutException('Test timed out while waiting for notification');
      });
    });

    // test('Should remove specific subscriptions for an object from a channel',
    //     () {
    //   final notificationHub = NotificationHub.instance;

    //   // Add subscribers
    //   notificationHub.addSubscriber<String>(
    //     object: 'Object1',
    //     notificationChannel: "ChannelA",
    //     onData: (data) {
    //       // Handle data
    //     },
    //   );

    //   notificationHub.addSubscriber<String>(
    //     object: 'Object1',
    //     notificationChannel: "ChannelB",
    //     onData: (data) {
    //       // Handle data
    //     },
    //   );

    //   // Verify subscriptions exist
    //   expect(notificationHub.subscriptions.length, 1);
    //   expect(notificationHub.channels["ChannelA"]?.length, 1);
    //   expect(notificationHub.channels["ChannelB"]?.length, 1);

    //   // Remove from ChannelA
    //   notificationHub.removeSubscriberFromChannel2(
    //     object: 'Object1',
    //     notificationChannel: "ChannelA",
    //   );

    //   // Verify ChannelA is unsubscribed but ChannelB remains
    //   // expect(notificationHub.channels.containsKey("ChannelA"), false);
    //   // expect(notificationHub.channels.containsKey("ChannelB"), true);
    // });

    test('Should remove specific subscriptions for an object from a channel',
        () {
      final notificationHub = NotificationHub.instance;

      // Add subscribers
      notificationHub.addSubscriber<String>(
        object: 'Object1',
        notificationChannel: "ChannelA",
        onData: (data) {
          // Handle data
        },
      );

      notificationHub.addSubscriber<String>(
        object: 'Object2',
        notificationChannel: "ChannelA",
        onData: (data) {
          // Handle data
        },
      );

      notificationHub.removeSubscriber(object: 'Object1');
      final check = notificationHub.doesSubscriptionExit("Object1");
      expect(check, false);
    });
  });
}
