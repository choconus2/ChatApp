import 'package:chats_app/main.dart';
import 'package:chats_app/ui/home/home.dart';
import 'package:chats_app/ui/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../base_bloc/app_bloc.dart';
import '../helper/secure_storage_helper.dart';
import '../model/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
        );
      } else {
        AppBloc.instance.userCurrent = Users(
          uid: user.uid,
          name: "",
          email: user.email ?? "",
          image: user.photoURL ?? "",
          rooms: [],
        );
        FirebaseMessaging.instance.getToken().then((values) {
          FirebaseFirestore.instance
              .collection("User")
              .doc(user.uid)
              .update({
            "tokenNotification": values,
          });
        });
        Navigator.pushReplacement(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
        );
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return const Scaffold(
    );
  }
}
