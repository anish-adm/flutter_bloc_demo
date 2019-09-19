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
  final bool hasReachedMax;

  ToDosListRefreshed(this.toDosList, {this.hasReachedMax});

  ToDosListRefreshed copyWith(List<Todo> tempToDosList, {bool hasReachedMax}) {
    return ToDosListRefreshed(tempToDosList ?? toDosList,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() {
    return 'ToDosListState: ToDosListRefreshed{count: ${toDosList.length}, hasReachedMax: $hasReachedMax}';
  }
}

class ToDosListCouldNotLoad extends ToDosListState {
  final String message;

  ToDosListCouldNotLoad(this.message);

  @override
  String toString() {
    return 'ToDosListState: ToDosListCouldNotLoad{message: $message}';
  }
}
