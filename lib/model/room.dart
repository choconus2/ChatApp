import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String idRoom;
  String? messengerPresent;
  Timestamp? timeCreateMessengerPresent;
  List member;
  String? createMessengerAt;

  Room(
      {required this.idRoom,
      this.messengerPresent,
      this.timeCreateMessengerPresent,
      required this.member,
      this.createMessengerAt});

  factory Room.fromFirebase(Map<dynamic, dynamic> data) => Room(
        idRoom: data["id"],
        messengerPresent: data["messengerPresent"],
        timeCreateMessengerPresent: data["timeCreateMessengerPresent"],
        member: data["members"],
        createMessengerAt: data["createMessengerAt"],
      );

  factory Room.fromFirebaseSnapshot(QueryDocumentSnapshot<Object?> data) =>
      Room(
        idRoom: data["id"],
        messengerPresent: data["messengerPresent"],
        timeCreateMessengerPresent: data["timeCreateMessengerPresent"],
        member: data["members"],
        createMessengerAt: data["createMessengerAt"],
      );
}
