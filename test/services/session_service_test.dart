import 'package:flutter_test/flutter_test.dart';
import 'package:swapfy/repositories/fake/fake_auth_repository.dart';
import 'package:swapfy/services/session_service.dart';

void main() {
  test('session service forwards authentication state', () async {
    final repository = FakeAuthRepository();
    final service = SessionService(repository);

    expect(await service.userChanges.first, isNull);
    await service.signIn('boris@example.com', 'password');
    expect(service.currentUser?.id, 'u0');

    service.dispose();
    repository.dispose();
  });
}
