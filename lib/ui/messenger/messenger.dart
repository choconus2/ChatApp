import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats_app/base_bloc/app_bloc.dart';
import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:chats_app/base_statefulWidget/base_statefulWidget.dart';
import 'package:chats_app/ui/messenger/messenger_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../link_url_image.dart';
import '../dialog/dialog_loading.dart';

class MessengerScreen extends BaseStatefulWidget<MessengerBloc> {
  MessengerScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        title: IconButton(
          onPressed: () async{
            print(bloc.token);
            bloc.sendPushMessage();
          },
          icon: const Icon(Icons.call),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 224, 232, 242),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SizedBox(
                    child: StreamBuilder(
                      stream: bloc.messageStream,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text("something is wrong");
                        }
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            bloc.state.sign == MessengerState.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SingleChildScrollView(
                          reverse: true,
                          controller: bloc.controllerScroll,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot qs =
                                  snapshot.data!.docs[index];
                              Timestamp t = qs['timeAt'];
                              DateTime d = t.toDate();
                              bool x = false;
                              bool y = false;

                              if (index < snapshot.data!.docs.length - 1) {
                                x = snapshot.data!.docs[index]["email"] ==
                                    snapshot.data!.docs[index + 1]["email"];

                              }if (index > 0) {
                                Timestamp t2 =
                                snapshot.data!.docs[index]["timeAt"];
                                Timestamp t3 =
                                snapshot.data!.docs[index - 1]["timeAt"];
                                y = (t2.toDate().day == t3.toDate().day);
                              }

                              return messenger(
                                  isEmailConsecutive: x,
                                  isEmail:
                                      AppBloc.instance.userCurrent!.email ==
                                          qs['email'],
                                  content: qs['content'],
                                  isDateTime: y,
                                  dateTime: d);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 60,
                color: Colors.white,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                            height: 1,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            isDense: true, // Added this
                            contentPadding: const EdgeInsets.all(13),
                            filled: true,
                            fillColor: Colors.black12,
                            enabled: true,
                          ),
                          controller: bloc.content,
                          onTap: () {
                            bloc.scrollDown();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: MaterialButton(
                          height: 60,
                          visualDensity: VisualDensity.comfortable,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25)),
                          ),
                          onPressed: () {
                            bloc.createMessage();
                            bloc.sendPushMessage();
                          },
                          child: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  messenger(
      {required bool isEmail,
      required bool isEmailConsecutive,
      required String content,
      required bool isDateTime,
      required DateTime dateTime}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Column(
        crossAxisAlignment:
            isEmail ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          isDateTime
              ? const SizedBox()
              : Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dateTime.day.toString() +
                          "/" +
                          dateTime.month.toString() +
                          "/" +
                          dateTime.year.toString()),
                    ],
                  ),
              ),
          SizedBox(
            width: 250,
            child: Row(
              mainAxisAlignment:
                  isEmail ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                isEmail
                    ? const SizedBox()
                    : isEmailConsecutive
                        ? const SizedBox(
                            width: 30,
                            height: 30,
                          )
                        : CachedNetworkImage(
                            // cacheManager: _CustomCacheManager.instance,
                            imageBuilder: (context, imageProvider) => Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) {
                              return const SizedBox(
                                width: 30,
                                height: 30,
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
                            width: 30,
                            height: 30,
                            fit: BoxFit.fill,
                            imageUrl: bloc.image == ""
                                ? LinkUrlImage.urlImageUserDefault
                                : LinkUrlImage.urlImage(
                                bloc.image),
                          ),
                const SizedBox(
                  width: 2,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isEmail
                        ? const Color.fromARGB(255, 210, 238, 254)
                        : Colors.white,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 70,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        dateTime.hour.toString() +
                            ":" +
                            dateTime.minute.toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  MessengerBloc create() => MessengerBloc();

  @override
  void init(BuildContext context) {
    super.init(context);
    bloc.getIdRoom();
    bloc.getMessenger();
    bloc.getUser();
  }

  @override
  void onStateChange(BuildContext context, BaseState baseState) {
    if (baseState.sign == MessengerState.loading) {
      showDialogLoadingCommon(context);
      return;
    }

    if (baseState.sign == MessengerState.success) {
      Navigator.pop(context);
      return;
    }
  }
}
