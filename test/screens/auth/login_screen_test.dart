import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swapfy/repositories/fake/fake_auth_repository.dart';
import 'package:swapfy/screens/auth/login_screen.dart';

void main() {
  testWidgets('login displays an error for invalid credentials', (
    tester,
  ) async {
    final repository = FakeAuthRepository();

    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(authRepository: repository)),
    );
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'wrong@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong12');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Identifiants invalides'), findsOneWidget);
    repository.dispose();
  });
}
