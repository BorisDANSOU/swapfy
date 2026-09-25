import '../../data/users.dart';
import '../../models/user.dart';
import '../users_repository.dart';

class FakeUsersRepository implements UsersRepository {
  List<User> _users;

  FakeUsersRepository({List<User>? users})
    : _users = List.of(users ?? MockUsers.users);

  @override
  Stream<User?> watchCurrentUser() async* {
    yield _findById(MockUsers.currentUserId);
  }

  @override
  Stream<List<User>> watchMatches() async* {
    final matches =
        _users.where((user) => user.id != MockUsers.currentUserId).toList()
          ..sort(
            (a, b) => b.compatibilityPercent.compareTo(a.compatibilityPercent),
          );
    yield List.unmodifiable(matches);
  }

  @override
  Future<void> saveProfile(User user) async {
    _users = [
      for (final existing in _users)
        if (existing.id == user.id) user else existing,
    ];
  }

  User? _findById(String id) {
    for (final user in _users) {
      if (user.id == id) return user;
    }
    return null;
  }

  void dispose() {}
}
