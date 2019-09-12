import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_demo/blocs/todos/list/index.dart';

class ToDoList extends StatelessWidget {
  final ToDosListBloc _toDosListBloc;

  ToDoList(this._toDosListBloc);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ToDosListBloc, ToDosListState>(
        bloc: _toDosListBloc,
        builder: (context, state) {
          if (state is ToDosListRefreshed) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Checkbox(
                    value: state.toDosList[index].completed,
                    onChanged: (bool newValue) {},
                  ),
                  title: Text(
                    state.toDosList[index].title,
                    style: TextStyle(
                        decoration: state.toDosList[index].completed
                            ? TextDecoration.lineThrough
                            : null),
                  ),
                );
              },
              itemCount: state.toDosList.length,
            );
          } else if (state is ToDosListLoading) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          } else {
            Center(child: Text((state as ToDosListCouldNotLoad).message));
          }
        },
      ),
    );
  }
}
