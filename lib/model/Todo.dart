import 'package:json_annotation/json_annotation.dart';
part 'Todo.g.dart';
@JsonSerializable()
class Todo{
  int userId;
  int id;
  String title;
  bool completed;

  Todo(this.userId, this.id, this.title, this.completed);

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

}