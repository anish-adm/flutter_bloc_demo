import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_demo/blocs/todos/detail/todo_detail_event.dart';
import 'package:flutter_bloc_demo/blocs/todos/detail/todo_detail_state.dart';
import 'package:flutter_bloc_demo/model/Todo.dart';
import 'package:flutter_bloc_demo/blocs/todos/list/index.dart';

class ToDoDetailBloc extends Bloc<ToDoDetailEvent, ToDoDetailState> {
  final ToDosListBloc toDosListBloc;

  ToDoDetailBloc({this.toDosListBloc});

  @override
  ToDoDetailState get initialState => ToDoDetailUninitialized();

  @override
  Stream<ToDoDetailState> mapEventToState(ToDoDetailEvent event) async* {
    if (event is Load) {
      yield ToDoDetailRefreshed(event.todo);
    } else if (event is Update) {
      yield ToDoDetailRefreshed(event.todo);
      try {
        //      if(toDosListBloc?.state is ToDosListRefreshed){
        List<Todo> tempToDoList =
            (toDosListBloc?.currentState as ToDosListRefreshed).toDosList;
        int index = tempToDoList.indexWhere((todo) {
          return todo.id == event.todo.id;
        });
        tempToDoList[index] = event.todo;
        toDosListBloc?.dispatch(RefreshToDos(tempToDoList));
        //      }
      } catch (exception) {
      }
    }
  }

  @override
  void onTransition(Transition<ToDoDetailEvent, ToDoDetailState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
