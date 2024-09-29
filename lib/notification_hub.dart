import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:notification_hub/code_environment.dart';

class NotificationHub {
  static NotificationHub? _instance;
  static NotificationHub get instance {
    _instance = (CodeEnvironment.isRunningUnitTests)
        ? NotificationHub._internal()
        : _instance ??= NotificationHub._internal();
    return _instance!;
  }

  NotificationHub._internal();

  final Map<String, StreamController> _channelControllers = {};

  /// Post a notification to a specific channel
  void post({required String channel, dynamic data}) {
    if (_channelControllers.containsKey(channel)) {
      _channelControllers[channel]?.add(data);
    }
  }

  /// Add a subscriber to a specific channel
  StreamSubscription<dynamic> addSubscriber({
    required String channel,
    Function(dynamic)? onData,
    Function? onError,
    void Function()? onDone,
  }) {
    if (!_channelControllers.containsKey(channel)) {
      _channelControllers[channel] = StreamController.broadcast();
    }
    return _channelControllers[channel]!
        .stream
        .listen(onData, onError: onError, onDone: onDone);
  }

  bool doesChannelExist({required String channel}) {
    return _channelControllers.containsKey(channel);
  }

  /// Remove a specific subscriber (subscription)
  void removeSubscriber({required StreamSubscription<dynamic> subscription}) {
    subscription.cancel();
  }

  /// Remove a channel
  void removeChannel({required String channel}) {
    if (!_channelControllers.containsKey(channel)) {
      return;
    }
    _channelControllers.remove(channel);
  }

  /// Remove all subscribers for a specific channel
  void removeAllSubscribersFromChannel(String channel) {
    if (_channelControllers.containsKey(channel)) {
      _channelControllers[channel]?.close();
      _channelControllers.remove(channel); // Remove the channel
    }
  }

  /// Remove all subscribers across all channels
  void removeAllSubscribers() {
    _channelControllers.forEach((_, controller) => controller.close());
    _channelControllers.clear();
  }
}
