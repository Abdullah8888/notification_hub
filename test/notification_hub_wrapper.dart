import 'dart:async';

import 'package:notification_hub/notification_hub.dart';

class NotificationHubWrapper {
  NotificationHubWrapper._();

  static NotificationHubWrapper? _instance;

  static NotificationHubWrapper get instance {
    _instance ??=
        NotificationHubWrapper._(); // If instance is null, create a new one
    return _instance!;
  }

  final notificationHub = NotificationHub.newInstance();

  void addSubscriber(Object obj,
      {required String notificationChannel,
      void Function(dynamic)? onData,
      Function? onError,
      void Function(String?)? onDone,
      bool? cancelOnError}) {
    notificationHub.addSubscriber(obj,
        notificationName: notificationChannel,
        onData: onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError);
  }

  void storeObject(
      String notificationChannel, Object obj, StreamSubscription subscriber) {
    notificationHub.storeObject(notificationChannel, obj, subscriber);
  }

  bool isObjectStored({required String channelName, required Object obj}) {
    return notificationHub.isObjectStored(channelName: channelName, obj: obj);
  }

  bool doesChannelExist({required String channelName}) {
    return notificationHub.doesChannelExist(channelName: channelName);
  }

  void printAllSubscribers() {
    notificationHub.printAllSubscribers();
  }

  void post({required String notificatonChannel, dynamic data}) {
    notificationHub.post(notificatonChannel: notificatonChannel, data: data);
  }

  void removeChannelName(
      {required String notificationName, required Object object}) {
    notificationHub.removeSubsriberFromChannel(
        notificationName: notificationName, object: object);
  }

  void removeSubscriber({required Object object}) {
    notificationHub.removeSubscriber(object: object);
  }

  void close() {
    notificationHub.close();
  }
}
