import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('user can sign in and open Explore', (tester) async {
    await resetSession();
    await pumpSwapfy(tester);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'boris@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(
      find.text('Qu\'aimerais-tu apprendre aujourd\'hui ?'),
      findsOneWidget,
    );
    testRouter.goNamed('explore');
    await tester.pumpAndSettle();
    expect(find.text('Explorer les compétences'), findsOneWidget);
  });
}
