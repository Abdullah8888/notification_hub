library notification_hub;

import 'dart:async';

class NotificationHub {
  NotificationHub._();

  static NotificationHub? _instance;

  static NotificationHub get instance {
    _instance ??= NotificationHub._(); // If instance is null, create a new one
    return _instance!;
  }

  /// This will be used only in unit test.
  final StreamController _controller = StreamController.broadcast();

  /// Subscribers associated with an object ID
  Map<int, StreamSubscription> _subscriberWithID = {};

  /// Subscribers associated with a notification channel
  Map<String, Map<int, StreamSubscription>>
      _subscribersGroupedByNotificationChannel = {};

  String currentNotificatonChannel = '';

  /// This will be used only in unit test.
  factory NotificationHub.newInstance() {
    return NotificationHub._();
  }

  /// The `addSubscriber` function is employed to associate an object ID with a StreamSubscription,
  /// mapping the resulting information to a notification channel,
  /// and subsequently initiating the listening process for an event.
  ///
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

  /// It is used to check if object has been mapped to a subscriber (i.e stream subscription)
  bool isObjectStored({required String channelName, required Object obj}) {
    if (_subscribersGroupedByNotificationChannel[channelName]?[obj.hashCode] !=
        null) {
      return true;
    }
    return false;
  }

  /// It is used to check if notification channel exist
  bool doesChannelExist({required String channelName}) {
    if (_subscribersGroupedByNotificationChannel[channelName] != null) {
      return true;
    }
    return false;
  }

  void printAllSubscribers() {}

  /// This is used for posting events
  void post({required String notificatonChannel, dynamic data}) {
    currentNotificatonChannel = notificatonChannel;
    _controller.add(data);
  }

  void removeSubsriberFromChannel(
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

  /// The `removeSubscriber` function is utilized to gracefully unsubscribe an object.
  /// It disassociates the object from all notification channels if the list is empty
  /// else, it specifically unsubscribes the object from the specified notification channels.
  void removeSubscriber(
      {required Object object, String notificationChannel = ''}) {
    if (notificationChannel.isNotEmpty) {
      removeSubsriberFromChannel(
          notificationName: notificationChannel, object: object);
      return;
    }
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
