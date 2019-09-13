import 'package:flutter_bloc_demo/repositories/user/users_list_result.dart';
import 'package:flutter_bloc_demo/utils/network/http_client.dart';
import 'package:flutter_bloc_demo/utils/network/http_response.dart';

class UserRepository{
  Future<UsersListResult> getUsers() async {
    try{
      HttpResponse httpResponse = await HttpClient.instance.get("users");
      if(httpResponse.ok){
        return UsersListResult.fromList(httpResponse.data);
      }else{
        return UsersListResult([],httpResponse.message,false);
      }
    }catch(exception){
      print(exception);
      return UsersListResult([],"Could not load users, Please try after some time",false);
    }
  }
}