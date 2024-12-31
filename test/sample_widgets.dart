import 'package:flutter/material.dart';
import 'package:notification_hub/notification_hub.dart';
import 'package:provider/provider.dart';

// The callback is used specifically for testing purposes.
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

    NotificationHub.instance.addSubscriber<String>(
      notificationChannel: "ChannelA",
      object: this,
      onData: (data) {
        widget.callback?.call(data);
      },
    );
  }

  @override
  void dispose() {
    NotificationHub.instance.removeSubscriber(object: this);
    super.dispose();
  }
}

// The callback is used specifically for testing purposes.
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

    NotificationHub.instance.addSubscriber<String>(
      notificationChannel: "ChannelA",
      object: this,
      onData: (data) {
        widget.callback?.call(data);
      },
    );
  }

  @override
  void dispose() {
    NotificationHub.instance.removeSubscriber(object: this);
    super.dispose();
  }
}

// The callback is used specifically for testing purposes.
class SampleC extends StatelessWidget {
  const SampleC({super.key, this.callback});
  final void Function(String)? callback;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SampleCChangeNotifier(),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<SampleCChangeNotifier>(builder: (context, counter, child) {
      // callback?.call(
      //     context.read<SampleCChangeNotifier>().textContent ?? 'No Data');
      return Container(
          width: 150.0,
          //height: 60.0,
          padding: const EdgeInsets.only(left: 5, bottom: 10, right: 5, top: 5),
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius:
                BorderRadius.circular(25.0), // Adjust the radius as needed
          ),
          child: Center(
            child: Text(
              '${context.read<SampleCChangeNotifier>().textContent}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w800),
            ),
          ));
    });
  }
}

class SampleCChangeNotifier with ChangeNotifier {
  String? _textContent;
  String? get textContent => _textContent;

  set textContent(String? value) {
    _textContent = value;
    notifyListeners();
  }

  SampleCChangeNotifier() {
    NotificationHub.instance.addSubscriber<String>(
      notificationChannel: "ChannelA",
      object: this,
      onData: (data) {
        textContent = data;
      },
    );
  }

  @override
  void dispose() {
    NotificationHub.instance.removeSubscriber(object: this);
    super.dispose();
  }
}
