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
  });
}
