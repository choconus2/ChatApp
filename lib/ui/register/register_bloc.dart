import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:chats_app/ui/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterBloc extends BaseBloc {
  TextEditingController email = TextEditingController();
  String? errorEmail;

  TextEditingController password = TextEditingController();
  String? errorPassword;
  final auth = FirebaseAuth.instance;
  final fs = FirebaseFirestore.instance;
  signUp(BuildContext context) async {
    await auth
        .createUserWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim())
        .whenComplete(() {
          fs.collection("User").doc(auth.currentUser!.uid).set({
            "email":auth.currentUser!.email,
            "uid":auth.currentUser!.uid,
            "avatar":"",
            "room":[],
            "tokenNotification":"",
          });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    });
  }
}
