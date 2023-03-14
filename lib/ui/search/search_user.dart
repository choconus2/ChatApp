import 'package:chats_app/base_bloc/app_bloc.dart';
import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:chats_app/base_statefulWidget/base_statefulWidget.dart';
import 'package:chats_app/ui/messenger/messenger.dart';
import 'package:chats_app/ui/search/search_user_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchUserScreen extends BaseStatefulWidget<SearchUserBloc> {
   SearchUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: TextField(
          controller: bloc.searchText,
          decoration: const InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
          ),
          onChanged: (value){
            bloc.search();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: bloc.users.length,
        itemBuilder: (context, index) {
          return OutlinedButton(
            onPressed: () {
              AppBloc.instance.uidSearch=bloc.users[index].uid;
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => MessengerScreen(),),);
            },
            child: Row(
              children: [
                Text(bloc.users[index].email),
              ],
            ),
          );
      },),
    );
  }

  @override
  SearchUserBloc create() => SearchUserBloc();

  @override
  void onStateChange(BuildContext context, BaseState baseState) {
    // TODO: implement onStateChange
  }
}
