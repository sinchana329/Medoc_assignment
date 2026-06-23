import 'package:flutter_test/flutter_test.dart';
import 'package:expensetracker/main.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const ExpenseTrackerApp());
    expect(find.text('Expense Tracker'), findsOneWidget);
  });
}
