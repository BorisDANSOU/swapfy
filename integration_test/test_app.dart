import 'package:flutter_test/flutter_test.dart';
import 'package:swapfy/app/router.dart';
import 'package:swapfy/main.dart';
import 'package:swapfy/repositories/fake/fake_auth_repository.dart';
import 'package:swapfy/repositories/fake/fake_messages_repository.dart';
import 'package:swapfy/repositories/fake/fake_skills_repository.dart';
import 'package:swapfy/repositories/fake/fake_users_repository.dart';

final testAuthRepository = FakeAuthRepository();
final testMessagesRepository = FakeMessagesRepository();
final testSkillsRepository = FakeSkillsRepository();
final testUsersRepository = FakeUsersRepository();
final testRouter = AppRouter(
  instanceAuthRepository: testAuthRepository,
  instanceMessagesRepository: testMessagesRepository,
  instanceSkillsRepository: testSkillsRepository,
  instanceUsersRepository: testUsersRepository,
).goRouter;

Future<void> pumpSwapfy(WidgetTester tester) async {
  await tester.pumpWidget(SwapfyApp(routerConfig: testRouter));
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

Future<void> resetSession() async {
  await testAuthRepository.signOut();
  testRouter.goNamed('login');
}
