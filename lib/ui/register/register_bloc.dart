import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:chats_app/ui/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum RegisterState {
  registerWrongEmailFormat,
  loading,
  registerError,
  registerSuccess
}

class RegisterBloc extends BaseBloc {
  TextEditingController email = TextEditingController();
  String? errorEmail;

  TextEditingController password = TextEditingController();
  String? errorPassword;
  final auth = FirebaseAuth.instance;
  final fs = FirebaseFirestore.instance;
  signUp(BuildContext context) async {
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
    if (errorEmail == null && errorPassword == null) {
      call(() => RegisterState.loading);
      try {
        await auth
            .createUserWithEmailAndPassword(
                email: email.text.trim(), password: password.text.trim())
            .then((value) {
          call(() => RegisterState.registerSuccess);
          fs.collection("User").doc(value.user!.uid).set({
            "email": value.user!.email,
            "uid": value.user!.uid,
            "avatar": "",
            "room": [],
            "tokenNotification": "",
          });
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "invalid-email") {
          call(() => RegisterState.registerWrongEmailFormat);
        } else {
          call(() => RegisterState.registerError);
        }
      }
    }
  }
}
