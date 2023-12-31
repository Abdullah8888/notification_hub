library notification_hub;

import 'dart:async';

class NotificationHub {
  NotificationHub._();

  static NotificationHub? _instance;

  static NotificationHub get instance {
    _instance ??= NotificationHub._(); // If instance is null, create a new one
    return _instance!;
  }

  final StreamController _controller = StreamController.broadcast();

  Map<int, StreamSubscription> _subscriberWithID = {};

  Map<String, Map<int, StreamSubscription>>
      _subscribersGroupedByNotificationChannel = {};

  String currentNotificatonChannel = '';

  /// This will be used only in unit test.
  factory NotificationHub.newInstance() {
    return NotificationHub._();
  }

  /// `addSubscriber` is used to map an object id to a streamSubscription then
  /// map the result to a notification channel.
  /// final notificaionChannel = 'Greetings';
  /// ```dart
  ///  NotificationHub.instance.addSubscriber(this, notificationChannel: notificaionChannel,
  ///     onData: (event) {
  ///   print("event is $event");
  /// }, onDone: (message) {
  ///   print("$message");
  /// });
  /// ```
  void addSubscriber(Object obj,
      {required String notificationName,
      void Function(dynamic)? onData,
      Function? onError,
      void Function(String?)? onDone,
      bool? cancelOnError}) {
    //StreamSubscription subscriber;
    StreamSubscription subscriber = _controller.stream.listen(
      (event) {
        if (currentNotificatonChannel == notificationName) {
          onData!(event);
        }
      },
      onDone: () {
        if (currentNotificatonChannel == notificationName) {
          onDone!(" ${obj.hashCode} subscriber successfully removed");
        }
      },
      onError: (error) {
        if (currentNotificatonChannel == notificationName) {
          onError!(error);
        }
      },
    );

    storeObject(notificationName, obj, subscriber);
  }

  void storeObject(
      String notificationName, Object obj, StreamSubscription subscriber) {
    if (_subscribersGroupedByNotificationChannel
        .containsKey(notificationName)) {
      Map<int, StreamSubscription> streamSubscriberWithID =
          _subscribersGroupedByNotificationChannel[notificationName]!;
      streamSubscriberWithID = {
        ...streamSubscriberWithID,
        ...{obj.hashCode: subscriber}
      };
      _subscribersGroupedByNotificationChannel = {
        ..._subscribersGroupedByNotificationChannel,
        ...{notificationName: streamSubscriberWithID}
      };
    } else {
      _subscriberWithID = {};
      _subscriberWithID = {
        ..._subscriberWithID,
        ...{obj.hashCode: subscriber}
      };

      _subscribersGroupedByNotificationChannel = {
        ..._subscribersGroupedByNotificationChannel,
        ...{notificationName: _subscriberWithID}
      };
    }
  }

  bool isObjectStored({required String channelName, required Object obj}) {
    if (_subscribersGroupedByNotificationChannel[channelName]?[obj.hashCode] !=
        null) {
      return true;
    }
    return false;
  }

  bool isChannelExist({required String channelName}) {
    if (_subscribersGroupedByNotificationChannel[channelName] != null) {
      return true;
    }
    return false;
  }

  void printAllSubscribers() {}

  void post({required String notificatonChannel, dynamic data}) {
    currentNotificatonChannel = notificatonChannel;
    _controller.add(data);
  }

  void removeChannelName(
      {required String notificationName, required Object object}) {
    final subscribers =
        _subscribersGroupedByNotificationChannel[notificationName];
    if (subscribers == null || subscribers.isEmpty) {
      _subscribersGroupedByNotificationChannel.remove(notificationName);
    } else {
      final subscriber = subscribers.remove(object.hashCode);
      subscriber?.cancel();
    }
  }

  void removeSubscriber({required Object object}) {
    List<StreamSubscription> subscribersToBeRemove = [];
    for (int i = 0; i < _subscribersGroupedByNotificationChannel.length; i++) {
      final subscribers =
          _subscribersGroupedByNotificationChannel.values.toList()[i];
      if (subscribers.containsKey(object.hashCode)) {
        final subscriber = subscribers.remove(object.hashCode);
        subscribersToBeRemove.add(subscriber!);
      }
    }

    for (int i = 0; i < subscribersToBeRemove.length; i++) {
      subscribersToBeRemove[i].cancel();
    }
  }

  void close() {
    _controller.close();
  }
}
