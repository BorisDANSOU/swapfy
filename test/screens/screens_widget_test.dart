import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swapfy/screens/conversation_screen.dart';
import 'package:swapfy/screens/edit_profile_screen.dart';
import 'package:swapfy/screens/explore_screen.dart';
import 'package:swapfy/screens/home_screen.dart';
import 'package:swapfy/screens/messages_screen.dart';

Widget testApp(Widget child) {
  return MaterialApp(home: child);
}

void main() {
  testWidgets('home renders its learning prompt', (tester) async {
    await tester.pumpWidget(testApp(const HomeScreen()));

    expect(
      find.text('Qu\'aimerais-tu apprendre aujourd\'hui ?'),
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

  testWidgets('messages renders user contacts', (tester) async {
    await tester.pumpWidget(testApp(const MessagesScreen()));

    expect(find.text('Sarah K.'), findsOneWidget);
    expect(find.text('Alex M.'), findsOneWidget);
  });

  testWidgets('conversation sends a non-empty message', (tester) async {
    await tester.pumpWidget(testApp(const ConversationScreen(userId: 'u1')));
    await tester.enterText(find.byType(TextField), 'À demain');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(find.text('À demain'), findsOneWidget);
  });

  testWidgets('edit profile displays required fields', (tester) async {
    await tester.pumpWidget(testApp(const EditProfileScreen()));

    expect(find.text('Nom *'), findsOneWidget);
    expect(find.text('Bio *'), findsOneWidget);
    expect(find.text('Compétences maîtrisées *'), findsOneWidget);
  });
}
