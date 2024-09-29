import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:notification_hub/notification_hub.dart';

late StreamSubscription subscriber;
late NotificationHub notificationHub;
void main() {
  group('Subscribe and receive posted notification', () {
    setUp(() {
      notificationHub = NotificationHub.instance;
    });

    tearDown(() {
      notificationHub.removeSubscriber(
          subscription: subscriber); // or subscriber.cancel();
    });

    test('Should add a subscriber and receive posted notification', () async {
      subscriber = notificationHub.addSubscriber(
          channel: 'ChannelOne',
          onData: (data) async {
            expect(data, 10);
          });
      notificationHub.post(channel: 'ChannelOne', data: 10);
    });
  });

  group('Post to non existing channel', () {
    setUp(() {
      notificationHub = NotificationHub.instance;
    });

    tearDown(() {
      notificationHub.removeSubscriber(
          subscription: subscriber); // or subscriber.cancel();
    });

    test('Should not receive notification for non-existent channel', () async {
      // Adding a subscriber to a different channel
      subscriber = notificationHub.addSubscriber(
        channel: "AnotherChannel",
        onData: (event) {
          // This should not be called since we post to "NonExistentChannel"
          fail("Received data from wrong channel");
        },
      );

      // Posting a notification to a non-existent channel
      notificationHub.post(channel: "NonExistentChannel", data: "Some data");
    });
  });

  group('Unsubscribe and stop receiving notifications', () {
    setUp(() {
      notificationHub = NotificationHub.instance;
    });

    tearDown(() {
      notificationHub.removeSubscriber(
          subscription: subscriber); // or subscriber.cancel();
    });

    test('Should remove subscriber and stop receiving notifications', () async {
      // Adding a subscriber to 'TestChannel' channel
      subscriber = notificationHub.addSubscriber(
        channel: "ChannelOne",
        onData: (event) {
          fail("Should not receive data after removal");
        },
        onError: (sad) {
          fail("Should not receive data after removal2");
        },
        onDone: () {
          fail("Should not receive data after removal3");
        },
      );

      expect(true, notificationHub.doesChannelExist(channel: "ChannelOne"));

      notificationHub.removeSubscriber(subscription: subscriber);

      // Post a notification after the subscriber has been removed
      notificationHub.post(channel: "ChannelOne", data: "Some data");
    });

    group('Unsubscribe and stop receiving notifications', () {
      setUp(() {
        notificationHub = NotificationHub.instance;
      });

      tearDown(() {
        notificationHub.removeSubscriber(
            subscription: subscriber); // or subscriber.cancel();
      });

      test('Should remove subscriber and stop receiving notifications',
          () async {
        // Adding a subscriber to 'TestChannel' channel
        subscriber = notificationHub.addSubscriber(
          channel: "ChannelOne",
          onData: (event) {
            fail("Should not receive data after removal");
          },
        );

        expect(true, notificationHub.doesChannelExist(channel: "ChannelOne"));

        // Remove subsriber
        notificationHub.removeSubscriber(subscription: subscriber);

        // Remove channel
        notificationHub.removeChannel(channel: "ChannelOne");
        expect(false, notificationHub.doesChannelExist(channel: "ChannelOne"));

        // Post a notification after the subscriber has been removed
        notificationHub.post(channel: "ChannelOne", data: "Some data");
      });
    });
  });
}
