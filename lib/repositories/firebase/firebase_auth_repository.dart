import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../models/user.dart';
import '../auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth _auth;

  FirebaseAuthRepository({firebase_auth.FirebaseAuth? auth})
    : _auth = auth ?? firebase_auth.FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges().map(_mapUser);

  @override
  Future<User> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(credential.user)!;
  }

  @override
  Future<User> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapUser(credential.user)!;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  User? _mapUser(firebase_auth.User? user) {
    if (user == null) return null;
    return User(
      id: user.uid,
      name: user.displayName ?? user.email ?? 'Swapfy user',
      avatarUrl: user.photoURL ?? '',
      location: '',
      bio: '',
      skillsOffered: const [],
      skillsWanted: const [],
    );
  }
}
