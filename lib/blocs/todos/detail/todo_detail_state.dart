import 'package:flutter_bloc_demo/model/Todo.dart';

abstract class ToDoDetailState {}

class ToDoDetailUninitialized extends ToDoDetailState{
  @override
  String toString() => "{ToDoDetailState: ToDoDetailUninitialized}";
}

class ToDoDetailRefreshed extends ToDoDetailState {
  final Todo toDo;
  ToDoDetailRefreshed(this.toDo);
  @override
  String toString() =>
      "{ToDoDetailState : ToDoDetailRefreshed :{title: ${toDo.title}, completed: ${toDo.completed}, userId:${toDo.userId}";
}

class ToDoDetailLoading extends ToDoDetailState{
  @override
  String toString() => "{ToDoDetailState: ToDoDetailLoading}";
}

class ToDoDetailCouldNotLoad extends ToDoDetailState{
  @override
  String toString() => "{ToDoDetailState: ToDoDetailCouldNotLoad}";
}
