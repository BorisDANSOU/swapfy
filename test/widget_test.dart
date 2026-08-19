import 'package:flutter_test/flutter_test.dart';
import 'package:swapfy/main.dart';

//Test de base : vérifie que l'application se lance sans planter
//et que l'écran d'accueil (Home) s'affiche correctement.
void main() {
  testWidgets('L\'application Swapfy se lance correctement', (WidgetTester tester) async {
    //Construit l'app et déclenche un premier rendu.
    await tester.pumpWidget(const SwapfyApp());

    //Vérifie qu'un élément attendu de l'écran d'accueil est bien présent.
    expect(find.textContaining('Bonjour'), findsOneWidget);
  });
}