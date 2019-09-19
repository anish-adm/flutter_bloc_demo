import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_demo/blocs/todos/list/index.dart';
import 'package:flutter_bloc_demo/blocs/todos/detail/index.dart';
import 'package:flutter_bloc_demo/model/Todo.dart';

class ToDoList extends StatefulWidget {
  final ToDosListBloc _toDosListBloc;

  ToDoList(this._toDosListBloc);

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final _scrollController = ScrollController();

  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ToDosListBloc, ToDosListState>(
        bloc: widget._toDosListBloc,
        builder: (context, state) {
          if (state is ToDosListRefreshed) {
            return ListView.builder(
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return index >= state.toDosList.length
                    ? BottomLoader()
                    : ToDoListItem(
                        state.toDosList[index], widget._toDosListBloc);
              },
              itemCount: state.hasReachedMax
                  ? state.toDosList.length
                  : state.toDosList.length + 1,
            );
          } else if (state is ToDosListLoading) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          } else {
            return Center(
                child: Text((state as ToDosListCouldNotLoad).message));
          }
        },
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      widget._toDosListBloc.dispatch(FetchToDos());
    }
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class ToDoListItem extends StatelessWidget {
  final Todo _todo;
  final ToDosListBloc _toDosListBloc;

  ToDoListItem(this._todo, this._toDosListBloc);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      leading: Checkbox(
        value: _todo.completed,
        onChanged: (bool newValue) {
          ToDoDetailBloc _toDoDetailBloc =
              ToDoDetailBloc(toDosListBloc: _toDosListBloc);
          Todo tempToDo = _todo;
          _toDoDetailBloc.dispatch(Load(tempToDo));
          tempToDo.completed = newValue;
          _toDoDetailBloc.dispatch(Update(tempToDo));
          _toDoDetailBloc.dispose();
        },
      ),
      title: Text(
        _todo.title,
        style: TextStyle(
            decoration: _todo.completed ? TextDecoration.lineThrough : null),
      ),
    );
  }
}
