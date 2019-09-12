import 'package:flutter_bloc_demo/model/User.dart';

abstract class UsersListState{}

class UsersListLoading extends UsersListState{

  @override
  String toString() {
    return 'UsersListState: UsersListLoading{}';
  }
}

class UsersListRefreshed extends UsersListState{
  final List<User> usersList;
  final int selectedUserId;
  UsersListRefreshed(this.usersList,{this.selectedUserId});

  @override
  String toString() {
    return 'UsersListState: UsersListRefreshed{count: ${usersList.length}';
  }

  //Implement copy with functionality
}

class UsersListCouldNotLoad extends UsersListState{
  final String message;
  UsersListCouldNotLoad(this.message);

  @override
  String toString() {
    return 'UsersListState: UsersListCouldNotLoad{message: $message';
  }
}