abstract class UsersListEvent{}

class FetchUsers extends UsersListEvent{
  @override
  String toString() {
    return 'UsersListEvent: FetchUsers{}';
  }
}

class SelectUser extends UsersListEvent{
  final int userId;
  SelectUser(this.userId);
  @override
  String toString() {
    return 'UsersListEvent: SelectUser{id:$userId}';
  }
}