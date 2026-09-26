import 'dart:async';

import '../../data/users.dart';
import '../../models/user.dart';
import '../users_repository.dart';

class FakeUsersRepository implements UsersRepository {
  List<User> _users;
  final _changes = StreamController<List<User>>.broadcast();

  FakeUsersRepository({List<User>? users})
    : _users = List.of(users ?? MockUsers.users);

  @override
  Stream<User?> watchCurrentUser() async* {
    yield _findById(MockUsers.currentUserId);
    yield* _changes.stream.map((_) => _findById(MockUsers.currentUserId));
  }

  @override
  Stream<List<User>> watchMatches() async* {
    final matches =
        _users.where((user) => user.id != MockUsers.currentUserId).toList()
          ..sort(
            (a, b) => b.compatibilityPercent.compareTo(a.compatibilityPercent),
          );
    yield List.unmodifiable(matches);
    yield* _changes.stream.map((_) {
      final updatedMatches =
          _users.where((user) => user.id != MockUsers.currentUserId).toList()
            ..sort(
              (a, b) =>
                  b.compatibilityPercent.compareTo(a.compatibilityPercent),
            );
      return List.unmodifiable(updatedMatches);
    });
  }

  @override
  Future<User?> getById(String id) async => _findById(id);

  @override
  Future<void> saveProfile(User user) async {
    _users = [
      for (final existing in _users)
        if (existing.id == user.id) user else existing,
    ];
    _changes.add(List.unmodifiable(_users));
  }

  User? _findById(String id) {
    for (final user in _users) {
      if (user.id == id) return user;
    }
    return null;
  }

  void dispose() {
    _changes.close();
  }
}
