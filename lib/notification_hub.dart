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

  //late StreamSubscription subscriber;

  Map<int, StreamSubscription> _streamSubscriberWithID = {};

  Map<String, Map<int, StreamSubscription>>
      _streamSubscribersGroupedByNotificationName = {};

  String currentNotificatonName = '';

  void addSubscriber(Object obj,
      {required String notificationName,
      void Function(dynamic)? onData,
      Function? onError,
      void Function(String?)? onDone,
      bool? cancelOnError}) {
    //StreamSubscription subscriber;
    StreamSubscription subscriber = _controller.stream.listen(
      (event) {
        if (currentNotificatonName == notificationName) {
          onData!(event);
        }
      },
      onDone: () {
        if (currentNotificatonName == notificationName) {
          onDone!(" ${obj.hashCode} subscriber successfully removed");
        }
      },
      onError: (error) {
        if (currentNotificatonName == notificationName) {
          onError!(error);
        }
      },
    );

    storeObject(notificationName, obj, subscriber);
  }

  void storeObject(
      String notificationName, Object obj, StreamSubscription subscriber) {
    if (_streamSubscribersGroupedByNotificationName
        .containsKey(notificationName)) {
      Map<int, StreamSubscription> streamSubscriberWithID =
          _streamSubscribersGroupedByNotificationName[notificationName]!;
      streamSubscriberWithID = {
        ...streamSubscriberWithID,
        ...{obj.hashCode: subscriber}
      };
      _streamSubscribersGroupedByNotificationName = {
        ..._streamSubscribersGroupedByNotificationName,
        ...{notificationName: streamSubscriberWithID}
      };
    } else {
      _streamSubscriberWithID = {};
      _streamSubscriberWithID = {
        ..._streamSubscriberWithID,
        ...{obj.hashCode: subscriber}
      };

      _streamSubscribersGroupedByNotificationName = {
        ..._streamSubscribersGroupedByNotificationName,
        ...{notificationName: _streamSubscriberWithID}
      };
    }
  }

  bool isObjectStored({required String channelName, required Object obj}) {
    if (_streamSubscribersGroupedByNotificationName[channelName]
            ?[obj.hashCode] !=
        null) {
      return true;
    }
    return false;
  }

  bool isChannelExist({required String channelName}) {
    if (_streamSubscribersGroupedByNotificationName[channelName] != null) {
      return true;
    }
    return false;
  }

  void printAllSubscribers() {
    //print("subscriers are $_streamSubscribersGroupedByNotificationName");
  }

  void post({required String notificationName, dynamic data}) {
    currentNotificatonName = notificationName;
    _controller.add(data);
  }

  void removeChannelName(
      {required String notificationName, required Object object}) {
    final subscribers =
        _streamSubscribersGroupedByNotificationName[notificationName];
    if (subscribers == null || subscribers.isEmpty) {
      _streamSubscribersGroupedByNotificationName.remove(notificationName);
    } else {
      final subscriber = subscribers.remove(object.hashCode);
      subscriber?.cancel();
    }
  }

  void removeSubscriber({required Object object}) {
    List<StreamSubscription> subscribersToBeRemove = [];
    for (int i = 0;
        i < _streamSubscribersGroupedByNotificationName.length;
        i++) {
      final subscribers =
          _streamSubscribersGroupedByNotificationName.values.toList()[i];
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
