import 'package:flutter_bloc_demo/model/Todo.dart';

abstract class ToDosListState {}

class ToDosListLoading extends ToDosListState {
  @override
  String toString() {
    return 'ToDosListState: ToDosListLoading{}';
  }
}

class ToDosListRefreshed extends ToDosListState {
  final List<Todo> toDosList;

  ToDosListRefreshed(this.toDosList);

  ToDosListRefreshed copyWith(List<Todo> tempToDosList) {
    return ToDosListRefreshed(tempToDosList ?? toDosList);
  }

  @override
  String toString() {
    return 'ToDosListState: ToDosListRefreshed{count: ${toDosList.length}';
  }
}

class ToDosListCouldNotLoad extends ToDosListState {
  final String message;

  ToDosListCouldNotLoad(this.message);

  @override
  String toString() {
    return 'ToDosListState: ToDosListCouldNotLoad{message: $message';
  }
}
