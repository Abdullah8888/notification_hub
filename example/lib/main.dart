import 'package:example/post_btns.dart/post_btn_one.dart';
import 'package:example/post_btns.dart/post_btn_three.dart';
import 'package:example/post_btns.dart/post_btn_two.dart';
import 'package:example/widget_a.dart';
import 'package:example/widget_b.dart';
import 'package:example/widget_c.dart';
import 'package:example/widget_d.dart';
import 'package:flutter/material.dart';
import 'package:notification_hub/notification_hub.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    NotificationHub.instance.addSubscriber(this, notificationName: "channelOne",
        onData: (event) {
      print("event is $event");
    }, onDone: (message) {
      print("$message");
    }, onError: (error) {
      print("$error");
    });
  }

  @override
  void dispose() {
    NotificationHub.instance.removeSubscriber(object: this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
              WidgetA(),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 150.0, // Set your desired width
                  height: 60.0,
                  child: WidgetB()),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 150.0, // Set your desired width
                  height: 60.0,
                  child: WidgetC()),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 150.0, // Set your desired width
                  height: 60.0,
                  child: WidgetD()),
              SizedBox(
                height: 150,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [PostButtonOne(), PostButtonTwo(), PostButtonThree()],
              )
            ],
          ),
        ),
      ),
    );
  }
}
