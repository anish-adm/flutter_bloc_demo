import 'package:flutter_bloc_demo/model/User.dart';

class UsersListResult{
  final List<User> users;
  final String message;
  final bool ok;
  UsersListResult(this.users, this.message, this.ok);

  static UsersListResult fromList(List<dynamic> users) {
    try{
      List<User> tempUsers = [];
      List<dynamic> content = users;
      content.forEach((savedItemMap){
        tempUsers.add(User.fromJson(savedItemMap));
      });
      return UsersListResult(tempUsers, null, true);
    }catch(exception){
      print(exception);
      return UsersListResult(null, exception.toString(), false);
    }
  }

}