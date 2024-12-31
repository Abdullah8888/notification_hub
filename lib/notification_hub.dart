import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notification_hub/code_environment.dart';

class NotificationHub {
  static NotificationHub? _instance;

  // Factory constructor to return the same instance
  static NotificationHub get instance {
    // Only create a new instance if it hasn't been created yet
    if (_instance == null) {
      if (CodeEnvironment.isRunningUnitTests) {
        // Return a fresh instance for unit tests
        _instance = NotificationHub._internal();
      } else {
        // Return a singleton instance for non-test environments
        _instance ??= NotificationHub._internal();
      }
    }
    return _instance!;
  }

  NotificationHub._internal();

  final Map<String, List<StreamController>> channels = {}; // Channel map
  final Map<String, List<StreamSubscription>> subscriptions =
      {}; // Subscriptions map

  final Map<String, StreamSubscription> objIdWithChannelName = {};

  // Add observer to a channel
  void addSubscriber<T>(
      {required Object object,
      required String notificationChannel,
      void Function(T)? onData}) {
    final widgetId = '${object.runtimeType}_${object.hashCode}';
    debugPrint('widgetId in addObserver is $widgetId');
    // Create a new StreamController if none exists for the channel
    final controller = channels
        .putIfAbsent(
          notificationChannel,
          () => [StreamController<T>.broadcast()],
        )
        .first;

    // Listen for the notification
    final subscription = controller.stream.listen((data) {
      onData?.call(data);
    });

    // Track the subscription for the widget using widgetId
    subscriptions.putIfAbsent(widgetId, () => []).add(subscription);
    // trackSubscriptionAttachToChannel(
    //     "$widgetId$notificationChannel", subscription);
  }

  void trackSubscriptionAttachToChannel(
      String id, StreamSubscription subscription) {
    objIdWithChannelName[id] = subscription;
  }

  void removeSubscriberFromChannel2({
    required Object object,
    required String notificationChannel,
  }) {
    final widgetId = '${object.runtimeType}_${object.hashCode}';
    final widgetIdWithChannel = '$widgetId$notificationChannel';
    if (objIdWithChannelName.containsKey(widgetIdWithChannel)) {
      final subscription = objIdWithChannelName[widgetIdWithChannel];

      subscription?.cancel();
      objIdWithChannelName.remove(widgetIdWithChannel);

      debugPrint(
          'Finished removing subscriptions for $widgetId from $notificationChannel.');
    }
  }

  // Post a notification to a channel
  void post<T>({required String notificationChannel, required T data}) {
    // Check if there are listeners for the channel
    final controllers = channels[notificationChannel];
    if (controllers != null && controllers.isNotEmpty) {
      for (var controller in controllers) {
        // Only add data to the stream once per post
        if (!controller.isClosed) {
          controller.add(data); // Post the notification
        }
      }
    }
  }

  // Remove a widget's subscriptions when it is disposed
  void removeSubscriber({required Object object}) {
    final widgetId = '${object.runtimeType}_${object.hashCode}';
    debugPrint('widgetId in addObserver is $widgetId');
    final subscriptions = this.subscriptions[widgetId];
    if (subscriptions != null) {
      for (var subscription in subscriptions) {
        subscription.cancel();
      }
      this.subscriptions.remove(widgetId);
    }

    // Clean up empty channels
    channels.removeWhere((key, controllers) {
      controllers.removeWhere((controller) => !controller.hasListener);
      return controllers.isEmpty;
    });

    debugPrint('Remaining channels: ${channels.keys}');
  }

  // Remove all subscriptions for a specific channel
  void removeChannel({required String notificationChannel}) {
    final controllers = channels[notificationChannel];
    if (controllers != null) {
      for (var controller in controllers) {
        controller.close();
      }
      channels.remove(notificationChannel);
    }
  }

  void removeSubscriberFromChannel({
    required Object object,
    required String notificationChannel,
  }) {
    final widgetId = '${object.runtimeType}_${object.hashCode}';
    debugPrint(
        'Removing subscriptions for $widgetId from channel $notificationChannel');

    // Ensure the widget has subscriptions
    final subscriptions = this.subscriptions[widgetId];
    if (subscriptions == null || subscriptions.isEmpty) {
      debugPrint('No subscriptions found for $widgetId.');
      return;
    }

    // Check if the channel exists
    final controllers = channels[notificationChannel];
    if (controllers == null || controllers.isEmpty) {
      debugPrint(
          'Channel $notificationChannel does not exist or has no active controllers.');
      return;
    }

    // Cancel subscriptions tied to this channel
    subscriptions.removeWhere((subscription) {
      try {
        final isSubscribedToChannel = controllers.any((controller) {
          // Verify if the subscription is associated with the current controller
          return controller
              .hasListener; // `hasListener` confirms active subscriptions
        });

        if (isSubscribedToChannel) {
          debugPrint("loko1111");
          subscription.cancel();
        }
        return isSubscribedToChannel;
      } catch (e) {
        debugPrint('Error while removing subscription: $e');
        return false; // Retain the subscription if an error occurs
      }
    });

    // Cleanup widget subscriptions
    if (subscriptions.isEmpty) {
      debugPrint("loko");
      this.subscriptions.remove(widgetId);
    }

    debugPrint(
        'Finished removing subscriptions for $widgetId from $notificationChannel.');
  }
}
