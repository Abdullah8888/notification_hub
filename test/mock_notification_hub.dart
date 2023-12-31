import 'dart:async';

import 'package:notification_hub/notification_hub.dart';

class MockNotificationHub {
  // final NotificationHub notificationHub;
  // const MockNotificationHub({required this.notificationHub});
  MockNotificationHub._();

  static MockNotificationHub? _instance;

  static MockNotificationHub get instance {
    _instance ??=
        MockNotificationHub._(); // If instance is null, create a new one
    return _instance!;
  }

  final notificationHub = NotificationHub.newInstance();

  void addSubscriber(Object obj,
      {required String notificationName,
      void Function(dynamic)? onData,
      Function? onError,
      void Function(String?)? onDone,
      bool? cancelOnError}) {
    notificationHub.addSubscriber(obj,
        notificationName: notificationName,
        onData: onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError);
  }

  void storeObject(
      String notificationName, Object obj, StreamSubscription subscriber) {
    print("lal is ${notificationHub.hashCode}");
    notificationHub.storeObject(notificationName, obj, subscriber);
  }

  bool isObjectStored({required String channelName, required Object obj}) {
    print("lal2 is ${notificationHub.hashCode}");
    return notificationHub.isObjectStored(channelName: channelName, obj: obj);
  }

  bool isChannelExist({required String channelName}) {
    print("lal3 is ${notificationHub.hashCode}");
    return notificationHub.isChannelExist(channelName: channelName);
  }

  void printAllSubscribers() {
    notificationHub.printAllSubscribers();
  }

  void post({required String notificatonChannel, dynamic data}) {
    notificationHub.post(notificatonChannel: notificatonChannel, data: data);
  }

  void removeChannelName(
      {required String notificationName, required Object object}) {
    notificationHub.removeChannelName(
        notificationName: notificationName, object: object);
  }

  void removeSubscriber({required Object object}) {
    notificationHub.removeSubscriber(object: object);
  }

  void close() {
    notificationHub.close();
    print("lal4 is ${notificationHub.hashCode}");
  }
}
