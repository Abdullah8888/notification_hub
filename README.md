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

`addSubscriber`: This method is likely used to subscribe an object (in this case, the current object, represented by `this`) to a specific notification channel. The `this` can also be replaced by instance of an object.

`notificationChannel`: **'Greetings'** Specifies the name of the notification channel to which the object is subscribing. In this case, it's **'Greetings'**.

`onData`: This is a callback function that will be executed when new data is received on the 'Greetings' channel. The `event` parameter represents the data received.

`onDone`: This is a callback function that will be executed when the subscription is completed successfully. The `message` parameter represents any message related to the completion.

`onError`: This is a callback function that will be executed if an error occurs during the subscription. The `error` parameter represents the error object.

