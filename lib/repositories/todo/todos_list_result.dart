import 'package:flutter_bloc_demo/model/Todo.dart';

class ToDosListResult{
  final List<Todo> toDos;
  final String message;
  final bool ok;
  ToDosListResult(this.toDos, this.message, this.ok);

  static ToDosListResult fromList(List<dynamic> users) {
    try{
      List<Todo> tempToDos = [];
      List<dynamic> content = users;
      content.forEach((savedItemMap){
        tempToDos.add(Todo.fromJson(savedItemMap));
      });
      return ToDosListResult(tempToDos, null, true);
    }catch(exception){
      return ToDosListResult(null, exception.toString(), false);
    }
  }

}