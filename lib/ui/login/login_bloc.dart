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
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      AppBloc.instance.userCurrent = Users(
        uid: userCredential.user!.uid,
        name: "",
        email: userCredential.user!.email ?? "",
        image: userCredential.user!.photoURL ?? "",
        rooms: [],
      );
      FirebaseMessaging.instance.getToken().then((value) {
        FirebaseFirestore.instance.collection("User").doc(userCredential.user!.uid).update({
          "tokenNotification":value,
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
