import 'package:flutter_test/flutter_test.dart';
import 'package:store_app/main.dart';

void main() {
  testWidgets('StoreApp opens the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const StoreApp());

    expect(find.text('Clothing Store'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
    expect(find.text("Don't have an account?"), findsOneWidget);
  });
}
