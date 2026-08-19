import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/skill_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/matches_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/conversation_screen.dart';

//Centralise toute la configuration de navigation de l'app.
//Chaque route est nommée, ce qui permet de naviguer avec
//context.goNamed('explore') plutôt qu'avec des chemins écrits en dur.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/explore',
        name: 'explore',
        builder: (context, state) => const ExploreScreen(),
      ),
      //Route avec paramètre dynamique : ":id" capture une valeur
      //variable dans l'URL (ex: /skill/1), récupérée via
      //state.pathParameters['id']. C'est le mécanisme central du
      //"passage de paramètres" exigé par la consigne.
      GoRoute(
        path: '/skill/:id',
        name: 'skillDetail',
        builder: (context, state) {
          final skillId = state.pathParameters['id']!;
          return SkillDetailScreen(skillId: skillId);
        },
      ),
      GoRoute(
        path: '/matches',
        name: 'matches',
        builder: (context, state) => const MatchesScreen(),
      ),
      GoRoute(
        path: '/messages',
        name: 'messages',
        builder: (context, state) => const MessagesScreen(),
      ),
      //Écran de conversation individuelle : même mécanisme de
      //paramètre dynamique, mais avec l'id de l'utilisateur cette fois.
      GoRoute(
        path: '/messages/:userId',
        name: 'conversation',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return ConversationScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
}