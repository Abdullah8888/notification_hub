import 'package:notification_hub/notification_hub.dart';

extension NotificationHubExtension on NotificationHub {
  bool? doesSubscriptionExit(Object widget) {
    List<String>? matchingKeys = subscriptions.keys
        .where((key) => key.contains(widget.toString()))
        .toList();

    return matchingKeys.isEmpty ? false : true;
  }
}
