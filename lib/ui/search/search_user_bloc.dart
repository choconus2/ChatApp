import 'package:chats_app/base_bloc/app_bloc.dart';
import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:chats_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class SearchUserBloc extends BaseBloc {
  List<Users> users = [];
  final fs = FirebaseFirestore.instance;
  TextEditingController searchText = TextEditingController();
  String c = "";
  search() async {
    if (searchText.text.isNotEmpty) {
      final docRef = await fs
          .collection("User")
          .where('email', isGreaterThanOrEqualTo: searchText.text)
          .where('email', isLessThanOrEqualTo: searchText.text + '~')
          .get();
      call(() => null);
      users = [];
      for (var element in docRef.docs) {
        if (element.data()["email"] != AppBloc.instance.userCurrent!.email) {
          users.add(
            Users(
                uid: element.data()["uid"],
                name: "",
                email: element.data()["email"],
                image: ""),
          );
        }
      }
    }
  }
}
