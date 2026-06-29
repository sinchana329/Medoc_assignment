import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo/main.dart';
 // replace with your actual app package name

void main() {
  testWidgets('App loads LibraryScreen', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Verify that the Library screen is shown
    expect(find.text('Library'), findsOneWidget);

    // Verify that dummy media items appear
    expect(find.text('video'), findsOneWidget);
    expect(find.text('audio'), findsOneWidget);
  });
}
