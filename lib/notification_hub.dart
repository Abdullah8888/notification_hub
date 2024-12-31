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

  final Map<String, List<StreamController>> _channels = {}; // Channel map
  final Map<String, List<StreamSubscription>> subscriptions =
      {}; // Subscriptions map

  // Add observer to a channel
  void addSubscriber<T>(
      {required Object object,
      required String notificationChannel,
      void Function(T)? onData}) {
    final widgetId = '${object.runtimeType}_${object.hashCode}';
    debugPrint('widgetId in addObserver is $widgetId');
    // Create a new StreamController if none exists for the channel
    final controller = _channels
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
  }

  // Post a notification to a channel
  void post<T>({required String notificationChannel, required T data}) {
    // Check if there are listeners for the channel
    final controllers = _channels[notificationChannel];
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
  }

  // Remove all subscriptions for a specific channel
  void removeChannel({required String notificationChannel}) {
    final controllers = _channels[notificationChannel];
    if (controllers != null) {
      for (var controller in controllers) {
        controller.close();
      }
      _channels.remove(notificationChannel);
    }
  }
}
