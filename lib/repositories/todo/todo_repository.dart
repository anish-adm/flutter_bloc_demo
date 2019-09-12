import 'package:flutter_bloc_demo/repositories/todo/todos_list_result.dart';
import 'package:flutter_bloc_demo/utils/network/http_client.dart';
import 'package:flutter_bloc_demo/utils/network/http_response.dart';

class ToDoRepository{
  Future<ToDosListResult> getToDos(int page, int limit, {int userId}) async {
    try{
      Map<String, String> queryParameters = {
        '_page' : page.toString(),
        '_limit' : limit.toString()
      };
      if(userId != null){
        queryParameters['userId'] = userId.toString();
      }
      HttpResponse httpResponse = await HttpClient.instance.get("todos", queryParameters: queryParameters);
      print(httpResponse);
      if(httpResponse.ok){
        return ToDosListResult.fromList(httpResponse.data);
      }else{
        return ToDosListResult([],httpResponse.message,false);
      }
    }catch(exception){
      print(exception);
      return ToDosListResult([],"Could not load todos, Please try after some time",false);
    }
  }
}