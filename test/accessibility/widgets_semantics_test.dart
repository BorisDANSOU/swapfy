import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swapfy/widgets/custom_button.dart';
import 'package:swapfy/widgets/skill_chip.dart';

void main() {
  testWidgets('custom button exposes its action label', (tester) async {
    final semanticsHandle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(label: 'Échanger', onPressed: () {}),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Échanger'), findsOneWidget);
    semanticsHandle.dispose();
  });

  testWidgets('selected skill chip exposes its selected state', (tester) async {
    final semanticsHandle = tester.ensureSemantics();
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SkillChip(label: 'Flutter', isSelected: true)),
      ),
    );

    final semantics = tester.getSemantics(find.byType(SkillChip));
    expect(
      semantics.getSemanticsData().flagsCollection.isSelected,
      ui.Tristate.isTrue,
    );
    expect(semantics.label, contains('Flutter'));
    semanticsHandle.dispose();
  });
}
