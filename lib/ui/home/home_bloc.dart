import 'dart:async';

import 'package:chats_app/base_bloc/app_bloc.dart';
import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:chats_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/room.dart';

class HomeBloc extends BaseBloc {
  final fs = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> roomStream;
  StreamController counterController = StreamController<List<Users>>();
  Stream get counterStream => counterController.stream;
  List<Users> listUser = [];

  int x=0;
  get() async {
    roomStream = fs
        .collection("Room")
        .where("members", arrayContains: AppBloc.instance.userCurrent!.uid)
        .snapshots();
  }

  getUser(String id, int count) async {
    var docs = fs.collection("User").doc(id).snapshots().forEach((element) {
      if (AppBloc.instance.userRoom.length != count) {
        AppBloc.instance.userRoom.add(
          Users(
            uid: element["uid"],
            name: "",
            email: element["email"],
            image: element["avatar"],
          ),
        );
      }
      counterController.sink.add(AppBloc.instance.userRoom);
    });
  }
}
