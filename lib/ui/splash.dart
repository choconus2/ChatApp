import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/secure_storage_helper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FirebaseAuth.instance.currentUser!.getIdToken().then((value){
            // AuthCredential credential = EmailAuthProvider.credential(
            //     email:  "ack@gmail.com", password:"123456");
            // print(credential.providerId);
            // FirebaseAuth.instance
            //     .signInWithCredential(credential)
            //     .then((value) => print(value))
            //     .onError((error, stackTrace) => print(error));
            FirebaseAuth.instance.signInAnonymously().then((values) => print(values.user!.email));
          });

          // final accessTokenLocal =
          //     await secureStorageHelper.readByKey("credential");
          // print(accessTokenLocal.toString()+"xcxcx");
          // FirebaseAuth.instance
          //     .signInWithCredential(accessTokenLocal as AuthCredential)
          //     .then((value) => print(value))
          //     .onError((error, stackTrace) => print(error));
        },
      ),
    );
  }
}
