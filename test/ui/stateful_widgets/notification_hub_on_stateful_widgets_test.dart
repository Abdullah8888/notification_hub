import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notification_hub/notification_hub.dart';

import '../../notification_hub_extension.dart';
import 'widget_aa.dart';

void main() {
  group('Notification Hub on Stateful Widgets', () {
    // Test that widget receives the notification when posted
    testWidgets('should receive data when notification is posted',
        (WidgetTester tester) async {
      // Arrange (Pump the widget into the widget tree)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SampleA(
              callback: (data) {
                //Assert
                expect(data, 'Test Data');
              },
            ),
          ),
        ),
      );

      // Wait for initState and addObserver to complete
      await tester.pumpAndSettle();

      final check = NotificationHub.instance.doesSubscriptionExit('SampleA');
      expect(check, true);
      // Post notification to "ChannelA" and verify widget receives it
      NotificationHub.instance
          .post<String>(notificationChannel: 'ChannelA', data: 'Test Data');
    });

    testWidgets('should stop receive data when popped out',
        (WidgetTester tester) async {
      // Arrange (Pump the widget into the widget tree)

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SampleA(
              callback: (data) {
                //Assert
                debugPrint('data is $data');
                //expect(data, 'Test Data');
              },
            ),
          ),
        ),
      );

      // Wait for initState and addObserver to complete
      await tester.pumpAndSettle();

      // This is simulate the call to dispose WidgetAA
      await tester.pumpWidget(Container());

      // Post notification to "ChannelA" and verify widget receives it
      NotificationHub.instance
          .post<String>(notificationChannel: 'ChannelA', data: 'Test Data');

      final check = NotificationHub.instance.doesSubscriptionExit('SampleA');
      expect(check, false);
    });

    testWidgets(
        'SampleA and SampleB should receive the same data when notification is posted',
        (WidgetTester tester) async {
      // Arrange (Pump the widgets into the widget tree)

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SampleA(
                    callback: (data) {
                      // Assert for WidgetAA
                      expect(data, 'Test Data');
                    },
                  ),
                  SampleB(
                    callback: (data) {
                      // Assert for WidgetBB
                      expect(data, 'Test Data');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Wait for initState and addObserver to complete
      await tester.pumpAndSettle();

      // Assert that subscriptions exist
      final sampleACheck =
          NotificationHub.instance.doesSubscriptionExit('SampleA');
      final sampleBCheck =
          NotificationHub.instance.doesSubscriptionExit('SampleB');
      expect(sampleACheck, true);
      expect(sampleBCheck, true);

      // Act (Post notification to "ChannelA")
      NotificationHub.instance
          .post<String>(notificationChannel: 'ChannelA', data: 'Test Data');

      // Wait to ensure callbacks are executed
      await tester.pumpAndSettle();
    });
  });
}
