import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('user can open a conversation and send a message', (
    tester,
  ) async {
    await resetSession();
    await testAuthRepository.signIn('boris@example.com', 'password');
    await pumpSwapfy(tester);
    testRouter.goNamed('conversation', pathParameters: {'userId': 'u1'});
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.enterText(find.byType(TextField), 'On commence demain ?');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('On commence demain ?'), findsOneWidget);
  });
}
