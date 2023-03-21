import 'package:chats_app/base_bloc/app_bloc.dart';
import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import '../../helper/secure_storage_helper.dart';
import '../../model/user.dart';

enum LoginState { loginSuccess, loginError }

class LoginBloc extends BaseBloc {
  TextEditingController email = TextEditingController();
  String? errorEmail;

  TextEditingController password = TextEditingController();
  String? errorPassword;

  login() async {
    call(() => null);
    if (email.text.isEmpty) {
      errorEmail = "không được để trống";
    } else {
      errorEmail = null;
    }
    if (password.text.isEmpty) {
      errorPassword = "không được để trống";
    } else {
      errorPassword = null;
    }
    if (errorEmail == null && errorPassword == null) {}
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      )
          .then((value) {
        AppBloc.instance.userCurrent = Users(
          uid: value.user!.uid,
          name: "",
          email: value.user!.email ?? "",
          image: value.user!.photoURL ?? "",
          rooms: [],
        );
        FirebaseMessaging.instance.getToken().then((values) {
          FirebaseFirestore.instance
              .collection("User")
              .doc(value.user!.uid)
              .update({
            "tokenNotification": values,
          });
        });
      });
      call(() => LoginState.loginSuccess);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
