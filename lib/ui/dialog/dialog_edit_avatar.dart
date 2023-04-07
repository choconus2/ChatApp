import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats_app/ui/dialog/dialog_success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../base_bloc/app_bloc.dart';
import '../../link_url_image.dart';
import 'dialog_loading.dart';

Future<void> dialogEditAvatar(BuildContext context) async {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  File? file;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('Edit avatar'),
        content: StatefulBuilder(
          builder: (context, setState) {
            print(AppBloc.instance.userCurrent!.image);
            return Column(
              children: [
                const Text("Avatar"),
                const SizedBox(
                  height: 10,
                ),
                file == null
                    ? CachedNetworkImage(
                        // cacheManager: _CustomCacheManager.instance,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) {
                          return const SizedBox(
                            width: 100,
                            height: 100,
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
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                        imageUrl: AppBloc.instance.userCurrent!.image == ""
                            ? LinkUrlImage.urlImageUserDefault
                            : LinkUrlImage.urlImage(
                                AppBloc.instance.userCurrent!.image),
                      )
                    : Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // border: Border.all(width: 1),
                            image: DecorationImage(
                              image: FileImage(file!) as ImageProvider,
                              fit: BoxFit.fill,
                            )),
                      ),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  onPressed: () async {
                    image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(
                      () {
                        if (image != null) {
                          file = File(image!.path);
                        }
                      },
                    );
                  },
                  child: const Text("Choose Avatar"),
                ),
              ],
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Save'),
            onPressed: () async {
              if (image != null) {
                final path = "files/${image!.name}";
                var res = FirebaseStorage.instance.ref().child(path);
                try {
                  showDialogLoadingCommon(context);
                  await res.putFile(file!).then((p0) async {
                    await FirebaseAuth.instance.currentUser!
                        .updatePhotoURL(p0.ref.name);
                    await FirebaseFirestore.instance
                        .collection("User")
                        .doc(AppBloc.instance.userCurrent!.uid)
                        .update({
                      "avatar": p0.ref.name.toString(),
                    }).then((value) {
                      AppBloc.instance.userCurrent!.image = p0.ref.name;
                    });
                    Navigator.pop(context);
                    showDialogSuccessCommon(context,
                        successText: "Change avatar successfully");
                  });
                } catch (e) {
                  Navigator.pop(context);
                  showDialogSuccessCommon(context,
                      successText: "Change avatar error");
                }
              }
            },
          ),
        ],
      );
    },
  );
}
