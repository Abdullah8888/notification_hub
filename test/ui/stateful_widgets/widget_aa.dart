import 'package:flutter/material.dart';
import 'package:notification_hub/notification_hub.dart';

class SampleA extends StatefulWidget {
  const SampleA({
    super.key,
    this.callback,
  });
  final void Function(String)? callback;
  @override
  State<SampleA> createState() => _SampleAState();
}

class _SampleAState extends State<SampleA> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  void initState() {
    super.initState();

    NotificationHub.instance.addObserver<String>(
      "ChannelA",
      this,
      (data) {
        widget.callback?.call(data);
      },
    );
  }

  @override
  void dispose() {
    NotificationHub.instance.removeSubscriptions(this);
    super.dispose();
  }
}

class SampleB extends StatefulWidget {
  const SampleB({
    super.key,
    this.callback,
  });
  final void Function(String)? callback;
  @override
  State<SampleB> createState() => _SampleBState();
}

class _SampleBState extends State<SampleB> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  void initState() {
    super.initState();

    NotificationHub.instance.addObserver<String>(
      "ChannelA",
      this,
      (data) {
        widget.callback?.call(data);
      },
    );
  }

  @override
  void dispose() {
    NotificationHub.instance.removeSubscriptions(this);
    super.dispose();
  }
}
