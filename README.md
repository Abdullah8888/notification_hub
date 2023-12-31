<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# notification_center

An event broadcasting mechanism designed for dispatching notifications to registered observers, inspired by the structure of the iOS Notification Center.

# Getting Started

`notification_hub` is available through [pub.dev](https://pub.dev).

## Add the Dependency

To use `notification_hub` in your Flutter project, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  ...
  notification_hub: ^0.0.1
```

# Usage example

For a detailed usage example, check the example folder.

## Subscribe Observer

Create a notification channel (e.g 'Greetings'), subscribe then listen to events. 

```dart
NotificationHub.instance.addSubscriber(this, notificationChannel: 'Greetings', 
onData: (event) {
    print("$event");
}, 
onDone: (message) {
    print("$message");
}, 
onError: (error) {
    print(error.toString());
});
```
Here's a breakdown of each part:

NotificationHub.instance: This suggests that there is a singleton instance of a NotificationHub class. The instance is a common pattern used for creating a single, shared instance of a class.

addSubscriber: This method is likely used to subscribe an object (in this case, the current object, represented by this) to a specific notification channel.

this: Refers to the current instance of the class where this code is located. It implies that the current object is subscribing to the notifications on the 'Greetings' channel.

channelName: 'Greetings': Specifies the name of the channel to which the object is subscribing. In this case, it's 'Greetings'.

onData: This is a callback function that will be executed when new data is received on the 'Greetings' channel. The event parameter represents the data received, and it is printed to the console using print("$event").

onDone: This is a callback function that will be executed when the subscription is completed successfully. The message parameter represents any message related to the completion, and it is printed to the console using print("$message").

onError: This is a callback function that will be executed if an error occurs during the subscription. The error parameter represents the error object, and it is printed to the console using print(error.toString()).

