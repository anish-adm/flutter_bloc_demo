import 'package:flutter_bloc_demo/model/Todo.dart';

abstract class ToDoDetailEvent {}

class Load extends ToDoDetailEvent{
  final Todo todo;
  Load(this.todo);
  @override
  String toString() => "{ToDoDetailEvent: Load}";
}

class Fetch extends ToDoDetailEvent{
  final int id;
  Fetch(this.id);
  @override
  String toString() => "{ToDoDetailEvent: Fetch}";
}

class Update extends ToDoDetailEvent{
  final Todo todo;
  Update(this.todo);
  @override
  String toString() => "{ToDoDetailEvent: Update}";
}