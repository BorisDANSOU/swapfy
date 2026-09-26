import 'package:go_router/go_router.dart';
import '../repositories/auth_repository.dart';
import '../repositories/messages_repository.dart';
import '../repositories/skills_repository.dart';
import '../repositories/users_repository.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../services/session_service.dart';
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
  final AuthRepository instanceAuthRepository;
  final MessagesRepository instanceMessagesRepository;
  final SkillsRepository? instanceSkillsRepository;
  final UsersRepository? instanceUsersRepository;
  late final SessionService session = SessionService(instanceAuthRepository);
  late final GoRouter goRouter = _buildRouter();

  AppRouter({
    required this.instanceAuthRepository,
    required this.instanceMessagesRepository,
    this.instanceSkillsRepository,
    this.instanceUsersRepository,
  });

  GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: session,
      redirect: (context, state) {
        final isPublicRoute =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';
        final isSignedIn = session.currentUser != null;

        if (!isSignedIn && !isPublicRoute) return '/login';
        if (isSignedIn && isPublicRoute) return '/';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => LoginScreen(
            authRepository: instanceAuthRepository,
            onAuthenticated: () => context.goNamed('home'),
          ),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => RegisterScreen(
            authRepository: instanceAuthRepository,
            onRegistered: () => context.goNamed('home'),
          ),
        ),
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => HomeScreen(
            skillsRepository: instanceSkillsRepository,
            usersRepository: instanceUsersRepository,
          ),
        ),
        GoRoute(
          path: '/explore',
          name: 'explore',
          builder: (context, state) =>
              ExploreScreen(skillsRepository: instanceSkillsRepository),
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
            return SkillDetailScreen(
              skillId: skillId,
              skillsRepository: instanceSkillsRepository,
              usersRepository: instanceUsersRepository,
            );
          },
        ),
        GoRoute(
          path: '/matches',
          name: 'matches',
          builder: (context, state) =>
              MatchesScreen(usersRepository: instanceUsersRepository),
        ),
        GoRoute(
          path: '/messages',
          name: 'messages',
          builder: (context, state) => MessagesScreen(
            messagesRepository: instanceMessagesRepository,
            usersRepository: instanceUsersRepository,
          ),
        ),
        //Écran de conversation individuelle : même mécanisme de
        //paramètre dynamique, mais avec l'id de l'utilisateur cette fois.
        GoRoute(
          path: '/messages/:userId',
          name: 'conversation',
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return ConversationScreen(
              userId: userId,
              messagesRepository: instanceMessagesRepository,
              usersRepository: instanceUsersRepository,
            );
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) =>
              ProfileScreen(usersRepository: instanceUsersRepository),
        ),
        GoRoute(
          path: '/profile/edit',
          name: 'editProfile',
          builder: (context, state) =>
              EditProfileScreen(usersRepository: instanceUsersRepository),
        ),
      ],
    );
  }
}
