import 'package:flutter_bloc_demo/model/Todo.dart';

abstract class ToDosListEvent{}

class FetchToDos extends ToDosListEvent{
  FetchToDos();

  @override
  String toString() {
    return 'ToDosListEvent: FetchToDos';
  }
}

class ResetAndFetchToDos extends ToDosListEvent{
  final userId;
  ResetAndFetchToDos({this.userId});

  @override
  String toString() {
    return 'ToDosListEvent: ResetAndFetchToDos{userId: $userId}';
  }
}

class RefreshToDos extends ToDosListEvent{
  final List<Todo> toDos;
  RefreshToDos(this.toDos);

  @override
  String toString() {
    return 'ToDosListEvent: ResetAndFetchToDos{count: ${toDos.length}}';
  }
}