
import 'package:chats_app/model/room.dart';

class Users {
  String uid;
  String name;
  String email;
  String image;
  String? tokenNotification;
  List<Room>? rooms;
  Users(
      {required this.uid,
      required this.name,
      required this.email,
      required this.image,this.rooms,this.tokenNotification});


}
