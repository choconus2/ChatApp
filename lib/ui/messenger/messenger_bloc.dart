import 'dart:convert';

import 'package:chats_app/base_bloc/app_bloc.dart';
import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../model/room.dart';

enum MessengerState{
  loading, error, success
}

class MessengerBloc extends BaseBloc {
  TextEditingController content = TextEditingController();

  final fs = FirebaseFirestore.instance;
  bool? alikeUid;
  String idRoom = "a";
  List<Room> listRoom = [];
  late Stream<QuerySnapshot> messageStream;
  final ScrollController controllerScroll = ScrollController();
  var token;
  String image="";

  Future<void> sendPushMessage() async {
    if(token==null){
      return;
    }
    try {
      http.Response response= await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':"key=AAAAU1DTW-k:APA91bH3La7dVKAYNKm5I0fCLQP-W3rtDzbwS0sXdVzzIjv1JsvneGX3-XxyA0oSGJwU5uxVGfx9JTjYCYS1gN5n0phObPDWvfC6HGrqaRB1L2Y0B8utUs-vd11wZagIPIZOFSxcgDjD"
        },
        body:  jsonEncode({
          'priority':'high',
          'data': {
            "session_id": "abc1234567890",  // Server record id about communication b/w users
            "caller_name": "User A", // Any String to show Caller's name
            "caller_id": "123456", // Callers id or phone number
            "type": "VOICE_CALL", // Type of call to handle in dart code
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
          },
          'notification': {
            'title': AppBloc.instance.userCurrent?.email,
            'body': content.text,
          },
          'to':AppBloc.instance.userCurrent!.tokenNotification,
        }),
      );
      response;
    } catch (e) {
      print(e);
    }
  }


  void scrollDown() {
    controllerScroll.jumpTo(controllerScroll.position.minScrollExtent);
  }

  void onScrollEvent() {
    final extentAfter = controllerScroll.position.extentAfter;
  }

  getUser() async {
    await fs.collection("User").doc(AppBloc.instance.uidSearch).get().then((value) {
      token=value.data()!["tokenNotification"];
      image=value.data()!["avatar"];
    });
  }

  createRoom() async {
    if (alikeUid != true) {
      if (AppBloc.instance.userCurrent!.rooms!.isEmpty) {
        alikeUid = false;
      } else {
        for (int i = 0; i < AppBloc.instance.userCurrent!.rooms!.length; i++) {
          if (AppBloc.instance.userCurrent!.rooms![i].member
              .contains(AppBloc.instance.uidSearch)) {
            alikeUid = true;
            break;
          }
          alikeUid = false;
        }
      }
    }
    if (alikeUid == false) {
      call(() => MessengerState.loading);
      var doc = fs.collection("Room").doc();
      await doc.set({
        "members": [
          AppBloc.instance.userCurrent!.uid,
          AppBloc.instance.uidSearch
        ],
        "id": doc.id,
        "messengerPresent": content.text,
        "timeCreateMessengerPresent": DateTime.now(),
        "createMessengerAt": AppBloc.instance.userCurrent!.uid,
      }).then((value) async {
        idRoom = doc.id;
        await doc.get().then((value) {
          AppBloc.instance.userCurrent!.rooms!.add(
            Room.fromFirebase(value.data()!),
          );
          AppBloc.instance.userCurrent!.rooms!.sort(((a, b) => a
              .timeCreateMessengerPresent!
              .compareTo(b.timeCreateMessengerPresent!)));
        });

        await fs
            .collection("User")
            .doc(AppBloc.instance.userCurrent!.uid)
            .update({
          "room": FieldValue.arrayUnion([doc.id]),
        });
        fs.collection("User").doc(AppBloc.instance.uidSearch).update({
          "room": FieldValue.arrayUnion([doc.id]),
        });
        call(() => MessengerState.success);
        getMessenger();
      });
    }
  }

  getIdRoom() {
    if (AppBloc.instance.userCurrent!.rooms!.isNotEmpty) {
      for (int i = 0; i < AppBloc.instance.userCurrent!.rooms!.length; i++) {
        if (AppBloc.instance.userCurrent!.rooms![i].member
            .contains(AppBloc.instance.uidSearch)) {
          idRoom = AppBloc.instance.userCurrent!.rooms![i].idRoom;
          break;
        }
      }
      return;
    } else {
      idRoom = "a";
    }
  }

  createMessage() async {
    String textContent=content.text;
    if (alikeUid != true) {
      await createRoom();
    }
    content.text="";
    await fs.collection("Messenger").doc(idRoom).collection("messenger").add({
      "content": textContent,
      "email": AppBloc.instance.userCurrent!.email,
      "avatar":AppBloc.instance.userCurrent!.image,
      "timeAt": DateTime.now(),
    });
    fs.collection("Room").doc(idRoom).update({
      "messengerPresent": textContent,
      "timeCreateMessengerPresent": DateTime.now(),
      "createMessengerAt": AppBloc.instance.userCurrent!.uid,
    });

  }

  Stream<QuerySnapshot> getMessenger() {
    messageStream = FirebaseFirestore.instance
        .collection("Messenger")
        .doc(idRoom)
        .collection("messenger")
        .orderBy("timeAt")
        .snapshots();
    return messageStream;
  }
}
