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

# notification_hub

An event broadcasting mechanism designed for dispatching notifications to registered observers, inspired by the structure of the iOS Notification Center.

# Video demo showcasing its usage

<img src="https://github.com/Abdullah8888/notification_hub/blob/main/sample_video.gif" alt="Video demo" style="width:250px;height:500px;"/>

# Explanation
There are three notification channels: `Mammals`, `Insects`, and `Birds`.

- `Widget A` subscribes to the Mammals notification channel.
- `Widget B` subscribes to the Insects notification channel.
- `Widget C` subscribes to the Insects notification channel.
- `Widget D` subscribes to both the Mammals and Birds notification channels.

When a <b>Dog</b> is posted, `Widget A and D` will receive it.
When <b>Bees</b> are posted, `Widget B and C` will receive the notification.
If an <b>Owl</b> is posted, only `Widget D` will receive the notification.

# Getting Started

`notification_hub` is available through [pub.dev](https://pub.dev).

## Add the Dependency

To use `notification_hub` in your Flutter project, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  ...
  notification_hub: ^0.0.5
```

# Usage example

For a detailed usage example, check the [example folder](https://github.com/Abdullah8888/notification_hub/tree/main/example).

## Subscribe Observer (Subscribe to a single notification channel)

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

`addSubscriber`: This method is likely used to subscribe an object (in this case, the current object, represented by `this`) to a specific notification channel. The `this` can also be replaced by an instance of an object.

`notificationChannel`: **'Greetings'** Specifies the name of the notification channel to which the object is subscribing. In this case, it's **'Greetings'**.

`onData`: This is a callback function that will be executed when new data is received on the 'Greetings' channel. The `event` parameter represents the data received.

`onDone`: This is a callback function that will be executed when the subscription is completed successfully. The `message` parameter represents any message related to the completion.

`onError`: This is a callback function that will be executed if an error occurs during the subscription. The `error` parameter represents the error object.

## Subscribe Observer (Subscribe to multiple notificaiton channels)
```dart
NotificationHub.instance.addSubscriber(this, notificationChannel: 'Morning', 
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

```dart
NotificationHub.instance.addSubscriber(this, notificationChannel: 'Afternoon', 
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

## Unsubscribe 

Unsubscribe by caling `removeSubscriber`. You can also unsubscribe from a specified notification channel, assuming the object or widget has subscribed to more than one notification channels.


<h6> Unsubscribe from All notification channels </h6>

```dart
NotificationHub.instance.removeSubscriber(object: this);
```

<h6> Unsubscribe from a specified notification channel </h6>

```dart
NotificationHub.instance.removeSubscriber(object: this, notificationChannel: 'Greetings');
```

## Post notification

```dart
NotificationHub.instance.post(notificationChannel:'Greetings', data: 'Hello');
```

