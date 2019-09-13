import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_demo/blocs/users/list/users_list_bloc.dart';
import 'package:flutter_bloc_demo/repositories/todo/todo_repository.dart';
import 'package:flutter_bloc_demo/repositories/todo/todos_list_result.dart';
import 'package:flutter_bloc_demo/blocs/todos/list/todos_list_state.dart';
import 'package:flutter_bloc_demo/blocs/todos/list/todos_list_event.dart';
import 'package:flutter_bloc_demo/blocs/users/list/users_list_state.dart';
import 'package:flutter_bloc_demo/model/Todo.dart';

class ToDosListBloc extends Bloc<ToDosListEvent, ToDosListState> {
  int _page = 1;
  int _limit = 15;
  UserListBloc userListBloc;
  int userId;
  StreamSubscription userBlocSubscription;

  ToDosListBloc({this.userListBloc}) {
    userBlocSubscription = this.userListBloc?.state?.listen((newState) {
      print('state change listener called');
      print(newState.runtimeType.toString());
      if (newState is UsersListRefreshed) {
        UsersListRefreshed usersListRefreshedState = newState;
        print(usersListRefreshedState);
        if (usersListRefreshedState.selectedUserId != userId) {
          this.dispatch(ResetAndFetchToDos(
              userId: usersListRefreshedState.selectedUserId));
        }
      }
    });
  }

  @override
  void dispose() {
    userBlocSubscription.cancel();
    super.dispose();
  }

  @override
  ToDosListState get initialState => ToDosListLoading();

  @override
  Stream<ToDosListState> mapEventToState(ToDosListEvent event) async* {
    if (event is FetchToDos) {
      try {
        ToDosListResult toDosListResult = await ToDoRepository()
            .getToDos(_page, _limit, userId: event.userId);
//        List<Todo> oldToDosList = [];
//        if(currentState is ToDosListRefreshed){
//          oldToDosList = (currentState as ToDosListRefreshed).toDosList;
//        }
        if (toDosListResult.ok) {
          yield ToDosListRefreshed(toDosListResult.toDos);
        } else {
          yield ToDosListCouldNotLoad(toDosListResult.message);
        }
      } catch (exception) {
        yield ToDosListCouldNotLoad(exception.toString());
        print(exception);
      }
    }
    if (event is ResetAndFetchToDos) {
      try {
        yield ToDosListLoading();
        _page = 1;
        _limit = 15;
        ToDosListResult toDosListResult = await ToDoRepository()
            .getToDos(_page, _limit, userId: event.userId);
        if (toDosListResult.ok) {
          yield ToDosListRefreshed(toDosListResult.toDos);
        } else {
          yield ToDosListCouldNotLoad(toDosListResult.message);
        }
      } catch (exception) {
        yield ToDosListCouldNotLoad(exception.toString());
        print(exception);
      }
    }
  }

  @override
  void onTransition(Transition<ToDosListEvent, ToDosListState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
