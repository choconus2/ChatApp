import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats_app/base_bloc/app_bloc.dart';
import 'package:chats_app/ui/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../link_url_image.dart';
import '../dialog/dialog_edit_avatar.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10),
        child: Column(
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  // cacheManager: _CustomCacheManager.instance,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) {
                    return const SizedBox(
                      width: 60,
                      height: 60,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcATop,
                        ),
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return const Icon(
                      Icons.error,
                    );
                  },
                  width: 60,
                  height: 60,
                  fit: BoxFit.fill,
                  imageUrl: AppBloc.instance.userCurrent!.image == ""
                      ? LinkUrlImage.urlImageUserDefault
                      : LinkUrlImage.urlImage(
                      AppBloc.instance.userCurrent!.image),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  AppBloc.instance.userCurrent!.email,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    dialogEditAvatar(context);
                    // FirebaseStorage.instance.ref().child(path)
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const Expanded(
              child: Text(""),
            ),
            OutlinedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().whenComplete(
                      () {
                        FirebaseFirestore.instance.collection("User").doc(AppBloc.instance.userCurrent!.uid).update({
                          "tokenNotification":"",
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                        },
                    );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Log Out"),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.logout),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
