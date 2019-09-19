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
  int _page = 0;
  int _limit = 15;
  final UserListBloc userListBloc;
  int userId;
  StreamSubscription userBlocSubscription;

  ToDosListBloc({this.userListBloc}) {
    userBlocSubscription = this.userListBloc?.state?.listen((newState) {
      if (newState is UsersListRefreshed) {
        UsersListRefreshed usersListRefreshedState = newState;
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
    if (event is FetchToDos && !_hasReachedMax(currentState)) {
      try {
        _page++;
        ToDosListResult toDosListResult = await ToDoRepository()
            .getToDos(_page, _limit, userId: userId);
        if (toDosListResult.ok) {
          if(currentState is ToDosListLoading){
            if(toDosListResult.toDos.isNotEmpty){
              yield ToDosListRefreshed(toDosListResult.toDos, hasReachedMax: false);
              return;
            }else{
              yield ToDosListCouldNotLoad("List is empty!");
              return;
            }
          }else if(currentState is ToDosListRefreshed){
            List<Todo> existingList = (currentState as ToDosListRefreshed).toDosList;
            if(toDosListResult.toDos.isNotEmpty){
              existingList = existingList+toDosListResult.toDos;
              yield ToDosListRefreshed(existingList, hasReachedMax: false);
              return;
            }else{
              yield (currentState as ToDosListRefreshed).copyWith(existingList, hasReachedMax: true);
              return;
            }
          }
        } else {
          yield ToDosListCouldNotLoad(toDosListResult.message);
        }
      } catch (exception) {
        yield ToDosListCouldNotLoad(exception.toString());
      }
    }
    if (event is ResetAndFetchToDos) {
      try {
        yield ToDosListLoading();
        _page = 0;
        _limit = 15;
        ToDosListResult toDosListResult = await ToDoRepository()
            .getToDos(_page, _limit, userId: event.userId);
        if (toDosListResult.ok) {
          userId = event.userId;
          yield ToDosListRefreshed(toDosListResult.toDos, hasReachedMax: false);
        } else {
          yield ToDosListCouldNotLoad(toDosListResult.message);
        }
      } catch (exception) {
        yield ToDosListCouldNotLoad(exception.toString());
      }
    }
    if(event is RefreshToDos){
      if(event.toDos != null){
        if(currentState is ToDosListRefreshed)
          yield (currentState as ToDosListRefreshed).copyWith(event.toDos);
        else
          yield ToDosListRefreshed(event.toDos);
      }
    }
  }

  bool _hasReachedMax(ToDosListState state) =>
      state is ToDosListRefreshed && state.hasReachedMax;

  @override
  void onTransition(Transition<ToDosListEvent, ToDosListState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
