import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:swapfy/app/locale_controller.dart';
import 'package:swapfy/l10n/app_localizations.dart';
import 'package:swapfy/models/skill.dart';
import 'package:swapfy/repositories/fake/fake_skills_repository.dart';
import 'package:swapfy/repositories/fake/fake_users_repository.dart';
import 'package:swapfy/repositories/fake/fake_messages_repository.dart';
import 'package:swapfy/screens/conversation_screen.dart';
import 'package:swapfy/screens/edit_profile_screen.dart';
import 'package:swapfy/screens/explore_screen.dart';
import 'package:swapfy/screens/home_screen.dart';
import 'package:swapfy/screens/messages_screen.dart';
import 'package:swapfy/screens/profile_screen.dart';
import 'package:swapfy/screens/skill_detail_screen.dart';
import 'package:swapfy/main.dart';

Widget testApp(Widget child) {
  return MaterialApp(
    locale: const Locale('fr'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  testWidgets('home renders its learning prompt', (tester) async {
    await tester.pumpWidget(testApp(const HomeScreen()));

    expect(
      find.text('Qu\'aimeriez-vous apprendre aujourd\'hui ?'),
      findsOneWidget,
    );
  });

  testWidgets('explore filters skills by text', (tester) async {
    await tester.pumpWidget(testApp(const ExploreScreen()));
    await tester.enterText(find.byType(TextField), 'Python');
    await tester.pump();

    expect(find.text('Python'), findsNWidgets(2));
    expect(find.text('Flutter'), findsNothing);
  });

  testWidgets('skill detail loads the skill and author from repositories', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        SkillDetailScreen(
          skillId: '1',
          skillsRepository: FakeSkillsRepository(),
          usersRepository: FakeUsersRepository(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Flutter'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Proposer un échange'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Proposer un échange'), findsOneWidget);
  });

  testWidgets('messages renders user contacts', (tester) async {
    await tester.pumpWidget(testApp(const MessagesScreen()));

    expect(find.text('Sarah K.'), findsOneWidget);
    expect(find.text('Alex M.'), findsOneWidget);
  });

  testWidgets('messages list shows persisted conversation data', (
    tester,
  ) async {
    final messagesRepository = FakeMessagesRepository();
    final usersRepository = FakeUsersRepository();
    final conversationId = await messagesRepository.openOrCreateConversation(
      'u1',
    );
    await messagesRepository.sendMessage(conversationId, 'On avance bien');

    await tester.pumpWidget(
      testApp(
        MessagesScreen(
          messagesRepository: messagesRepository,
          usersRepository: usersRepository,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Sarah K.'), findsOneWidget);
    expect(find.text('On avance bien'), findsOneWidget);
    messagesRepository.dispose();
    usersRepository.dispose();
  });

  testWidgets('conversation sends a non-empty message', (tester) async {
    final repository = FakeMessagesRepository();
    await tester.pumpWidget(
      testApp(ConversationScreen(userId: 'u1', messagesRepository: repository)),
    );
    await tester.enterText(find.byType(TextField), 'À demain');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('À demain'), findsOneWidget);
    final conversationId = await repository.openOrCreateConversation('u1');
    expect(
      (await repository.watchMessages(conversationId).first).single.text,
      'À demain',
    );
    repository.dispose();
  });

  testWidgets('edit profile displays required fields', (tester) async {
    await tester.pumpWidget(testApp(const EditProfileScreen()));

    expect(find.text('Nom *'), findsOneWidget);
    expect(find.text('Bio *'), findsOneWidget);
    expect(find.text('Compétences maîtrisées *'), findsOneWidget);
  });

  testWidgets('profile language selector changes the active locale', (
    tester,
  ) async {
    final localeController = LocaleController.instance;
    addTearDown(() => localeController.setLocale(const Locale('fr')));
    localeController.setLocale(const Locale('fr'));
    final usersRepository = FakeUsersRepository();
    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) =>
              ProfileScreen(usersRepository: usersRepository),
        ),
      ],
    );

    await tester.pumpWidget(SwapfyApp(routerConfig: router));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.scrollUntilVisible(
      find.byType(DropdownButton<Locale>),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byType(DropdownButton<Locale>));
    await tester.pump();
    await tester.tap(find.byType(DropdownButton<Locale>));
    await tester.pump();
    await tester.tap(find.text('Anglais').last);
    await tester.pump();

    expect(localeController.locale, const Locale('en'));
    await tester.scrollUntilVisible(
      find.text('I can teach'),
      -100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('I can teach'), findsOneWidget);
    router.dispose();
    usersRepository.dispose();
  });

  testWidgets('edit profile persists changes through its repository', (
    tester,
  ) async {
    final repository = FakeUsersRepository();
    final currentUser = await repository.watchCurrentUser().first;
    final router = GoRouter(
      initialLocation: '/edit',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Home')),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) =>
                  EditProfileScreen(usersRepository: repository),
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('fr'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.enterText(find.byType(TextFormField).at(0), 'Boris Test');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'A learner who enjoys sharing practical skills.',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'Dart, Flutter');
    await tester.enterText(find.byType(TextFormField).at(3), 'English');
    await tester.ensureVisible(
      find.byType(DropdownButtonFormField<SkillLevel>),
    );
    await tester.pump();
    await tester.tap(find.byType(DropdownButtonFormField<SkillLevel>));
    await tester.pump();
    await tester.tap(find.text('Expert').last);
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Enregistrer mon profil'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Enregistrer mon profil'));
    await tester.pump();
    await tester.tap(find.text('Enregistrer mon profil'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final savedUser = await repository.getById(currentUser!.id);
    expect(savedUser?.name, 'Boris Test');
    expect(savedUser?.skillsOffered, ['Dart', 'Flutter']);
    expect(savedUser?.skillsWanted, ['English']);
    expect(savedUser?.skillLevel, SkillLevel.expert);
    router.dispose();
    repository.dispose();
  });
}
