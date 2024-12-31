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
  void addObserver<T>(
    String channelName,
    Object widget,
    void Function(T) callback,
  ) {
    final widgetId = '${widget.runtimeType}_${widget.hashCode}';
    debugPrint('widgetId in addObserver is $widgetId');
    // Create a new StreamController if none exists for the channel
    final controller = _channels
        .putIfAbsent(
          channelName,
          () => [StreamController<T>.broadcast()],
        )
        .first;

    // Listen for the notification
    final subscription = controller.stream.listen((data) {
      callback(data);
    });

    // Track the subscription for the widget using widgetId
    subscriptions.putIfAbsent(widgetId, () => []).add(subscription);
  }

  // Post a notification to a channel
  void post<T>({required String channelName, required T data}) {
    // Check if there are listeners for the channel
    final controllers = _channels[channelName];
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
  void removeSubscriptions(Object widget) {
    final widgetId = '${widget.runtimeType}_${widget.hashCode}';
    debugPrint('widgetId in addObserver is $widgetId');
    final subscriptions = this.subscriptions[widgetId];
    if (subscriptions != null) {
      for (var subscription in subscriptions) {
        subscription.cancel();
      }
      this.subscriptions.remove(widgetId);
    }
  }

  // This is used in unit testing
  // bool? doesSubscriptionExit(Object widget) {
  //   debugPrint(" matchingKeys.isEmpty1  is ${widget.runtimeType.toString()}");
  //   debugPrint(" matchingKeys.isEmpty 2 is ${widget.toString()}");
  //   List<String>? matchingKeys = subscriptions.keys
  //       .where((key) => key.contains(widget.toString()))
  //       .toList();
  //   debugPrint(" matchingKeys.isEmpty  is ${matchingKeys.isEmpty}");
  //   return matchingKeys.isEmpty ? false : true;
  // }

  // bool doesSubscriptionExist() {

  // }

  // Remove all subscriptions for a specific channel
  void removeChannel(String channelName) {
    final controllers = _channels[channelName];
    if (controllers != null) {
      for (var controller in controllers) {
        controller.close();
      }
      _channels.remove(channelName);
    }
  }
}
