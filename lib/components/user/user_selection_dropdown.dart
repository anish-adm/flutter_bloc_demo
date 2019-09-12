import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_demo/blocs/users/list/index.dart';
import 'package:flutter_bloc_demo/model/User.dart';

class UserSelectionDropdown extends StatefulWidget {
  final UserListBloc userListBloc;

  UserSelectionDropdown(this.userListBloc);

  @override
  _UserSelectionDropdownState createState() => _UserSelectionDropdownState();
}

class _UserSelectionDropdownState extends State<UserSelectionDropdown> {

  int selectedUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.0,left: 16.0, right: 16.0, top: 8.0),
      child: BlocBuilder<UserListBloc, UsersListState>(
        bloc: widget.userListBloc,
        builder: (context, state) {
          if (state is UsersListLoading) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
            ));
          } else if (state is UsersListRefreshed) {
            selectedUser = state.selectedUserId;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Select User: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 250),
                  child: DropdownButton<int>(
                    value: selectedUser,
                    isExpanded: true,
                    onChanged: (int newValue) {
                      widget.userListBloc.dispatch(SelectUser(newValue));
                      setState(() {
                        selectedUser = newValue;
                      });
                    },
                    items: state.usersList.map<DropdownMenuItem<int>>((User user) {
                      return DropdownMenuItem<int>(
                        value: user.id,
                        child: Text(user.name+" (${user.username})", maxLines: 3 , overflow: TextOverflow.clip,),
                      );
                    }).toList(),
                  ),
                ),

              ],
            );
          } else {
            return Center(child: Text((state as UsersListCouldNotLoad).message));
          }
        },
      ),
    );
  }
}
