import 'package:flutter_test/flutter_test.dart';
import 'package:swapfy/app/router.dart';
import 'package:swapfy/main.dart';
import 'package:swapfy/repositories/fake/fake_auth_repository.dart';
import 'package:swapfy/repositories/fake/fake_messages_repository.dart';

final testAuthRepository = FakeAuthRepository();
final testMessagesRepository = FakeMessagesRepository();
final testRouter = AppRouter(
  instanceAuthRepository: testAuthRepository,
  instanceMessagesRepository: testMessagesRepository,
).goRouter;

Future<void> pumpSwapfy(WidgetTester tester) async {
  await tester.pumpWidget(SwapfyApp(routerConfig: testRouter));
  await tester.pumpAndSettle();
}

Future<void> resetSession() async {
  await testAuthRepository.signOut();
  testRouter.goNamed('login');
}
