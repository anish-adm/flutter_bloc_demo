import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_demo/blocs/users/list/users_list_event.dart';
import 'package:flutter_bloc_demo/blocs/users/list/users_list_state.dart';
import 'package:flutter_bloc_demo/repositories/user/user_repository.dart';
import 'package:flutter_bloc_demo/repositories/user/users_list_result.dart';

class UserListBloc extends Bloc<UsersListEvent, UsersListState> {
  @override
  UsersListState get initialState => UsersListLoading();

  @override
  Stream<UsersListState> mapEventToState(UsersListEvent event) async* {
    if(event is FetchUsers){
      try{
        UsersListResult usersListResult = await UserRepository().getUsers();
        if(usersListResult.ok){
          yield UsersListRefreshed(usersListResult.users);
        }else{
          yield UsersListCouldNotLoad(usersListResult.message);
        }
      }catch(exception){
        yield UsersListCouldNotLoad(exception.toString());
        print(exception);
      }
    }else if(event is SelectUser){
      try{
        UsersListRefreshed tempCurrentState = currentState as UsersListRefreshed;
        yield (tempCurrentState.copyWith(usersList: tempCurrentState.usersList, selectedUserId: event.userId));
      }catch(exception){
        yield currentState;
      }
    }
  }

  @override
  void onTransition(Transition<UsersListEvent, UsersListState> transition) {
    super.onTransition(transition);
    print(transition);
  }

}