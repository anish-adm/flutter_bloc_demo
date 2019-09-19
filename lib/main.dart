import 'package:flutter/material.dart';
import 'package:flutter_bloc_demo/blocs/todos/list/index.dart';
import 'package:flutter_bloc_demo/blocs/users/list/users_list_bloc.dart';
import 'package:flutter_bloc_demo/blocs/users/list/index.dart';
import 'package:flutter_bloc_demo/utils/constants/urls.dart';
import 'package:flutter_bloc_demo/utils/network/http_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/todo/todo_list.dart';
import 'components/user/user_selection_dropdown.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Users'),
    );
  }

  MyApp() {
    HttpClient httpClient = new HttpClient(baseUrl, true, 'https');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserListBloc _userListBloc;
  ToDosListBloc _toDosListBloc;


  _MyHomePageState(){
    _userListBloc = UserListBloc();
    _toDosListBloc = ToDosListBloc(userListBloc: _userListBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {
            _userListBloc.dispatch(SelectUser(null));
          })
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            UserSelectionDropdown(_userListBloc),
            Divider(
              height: 4.0,
            ),
            Expanded(
              child: ToDoList(_toDosListBloc),
            )
          ],
        )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    super.initState();
    _userListBloc.dispatch(FetchUsers());
    _toDosListBloc.dispatch(FetchToDos());
  }

  @override
  void dispose() {
    _userListBloc.dispose();
    _toDosListBloc.dispose();
    super.dispose();
  }
}
