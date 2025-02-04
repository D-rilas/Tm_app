import 'package:flutter_test/flutter_test.dart';

import 'package:tm_app/main.dart';

void main() {
  testWidgets('PDF Viewer app loads successfully', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the initial page loads with the correct title.
    expect(find.text('PDF Viewer'), findsOneWidget);

    // You can add more checks here, e.g., for the presence of specific UI elements.
  });
}
