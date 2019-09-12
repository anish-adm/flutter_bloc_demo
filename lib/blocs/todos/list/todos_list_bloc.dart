import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_demo/blocs/users/list/users_list_bloc.dart';
import 'package:flutter_bloc_demo/repositories/todo/todo_repository.dart';
import 'package:flutter_bloc_demo/repositories/todo/todos_list_result.dart';
import 'package:flutter_bloc_demo/blocs/todos/list/todos_list_state.dart';
import 'package:flutter_bloc_demo/blocs/todos/list/todos_list_event.dart';

class ToDosListBloc extends Bloc<ToDosListEvent, ToDosListState>{
  int _page = 1;
  int _limit = 15;
  UserListBloc userListBloc;


  ToDosListBloc({this.userListBloc}){
//    this.userListBloc.onTransition((Transition<UsersListEvent, UsersListState> transition){
//
//    });
  }

  @override
  ToDosListState get initialState => ToDosListLoading();

  @override
  Stream<ToDosListState> mapEventToState(ToDosListEvent event) async* {
    if(event is FetchToDos){
      try{
        ToDosListResult toDosListResult = await ToDoRepository().getToDos(_page, _limit);
        if(toDosListResult.ok){
          yield ToDosListRefreshed(toDosListResult.toDos);
        }else{
          yield ToDosListCouldNotLoad(toDosListResult.message);
        }
      }catch(exception){
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