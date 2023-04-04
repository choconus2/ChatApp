import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:chats_app/base_statefulWidget/base_statefulWidget.dart';
import 'package:chats_app/link_url_image.dart';
import 'package:chats_app/ui/home/home_bloc.dart';
import 'package:chats_app/ui/home/menu.dart';
import 'package:chats_app/ui/search/search_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base_bloc/app_bloc.dart';
import '../../model/room.dart';
import '../../model/user.dart';
import '../messenger/messenger.dart';

class HomeScreen extends BaseStatefulWidget<HomeBloc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white, // <-- SEE HERE
          statusBarIconBrightness:
              Brightness.dark, //<-- For Android SEE HERE (dark icons)
          statusBarBrightness:
              Brightness.light, //<-- For iOS SEE HERE (dark icons)
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          "Chat",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchUserScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.search,
                    color: Colors.black12,
                  ),
                  Text(
                    "Search",
                    style: TextStyle(color: Colors.black12),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder(
              stream: bloc.roomStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("something is wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                AppBloc.instance.userCurrent!.rooms = [];
                AppBloc.instance.userRoom = [];
                for (var element in snapshot.data!.docs) {
                  AppBloc.instance.userCurrent!.rooms!
                      .add(Room.fromFirebaseSnapshot(element));
                }
                if (AppBloc.instance.userCurrent!.rooms!.isEmpty) {
                  List<Users> s = [];
                  bloc.counterController.add(s);
                  return const SizedBox();
                }
                AppBloc.instance.userCurrent!.rooms!.sort(
                  (a, b) => b.timeCreateMessengerPresent!
                      .compareTo(a.timeCreateMessengerPresent!),
                );
                for(int i=0;i<AppBloc.instance.userCurrent!.rooms!.length;i++){
                  bloc.getUser(
                      AppBloc.instance.userCurrent!.rooms![i].member.singleWhere((element) =>
                      element != AppBloc.instance.userCurrent!.uid),
                      AppBloc.instance.userCurrent!.rooms!.length);
                }


                // return SizedBox();
                return StreamBuilder(
                  stream: bloc.counterStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("something is wrong");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(),
                      );
                    }
                    if(snapshot.hasData){
                      List<Users> p = snapshot.data as List<Users>;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: p.length,
                        itemBuilder: (context, index) {
                          Timestamp t = AppBloc.instance.userCurrent!
                              .rooms![index].timeCreateMessengerPresent!;
                          DateTime d = t.toDate();
                          return OutlinedButton(
                              onPressed: () {
                                AppBloc.instance.uidSearch = p[index].uid;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessengerScreen(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 15),
                                side: const BorderSide(
                                    width: 0, color: Colors.white),
                              ),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    // cacheManager: _CustomCacheManager.instance,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          width: 80.0,
                                          height: 80.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                    placeholder: (context, url) {
                                      return const SizedBox(
                                        width: 50,
                                        height: 50,
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
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fill,
                                    imageUrl: p[index].image == ""
                                        ? LinkUrlImage.urlImageUserDefault
                                        : LinkUrlImage.urlImage(p[index].image),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          p[index].email,
                                          style: const TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              AppBloc
                                                  .instance
                                                  .userCurrent!
                                                  .rooms![index]
                                                  .createMessengerAt ==
                                                  AppBloc.instance
                                                      .userCurrent!.uid
                                                  ? "Bạn: "
                                                  : "",
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              AppBloc
                                                  .instance
                                                  .userCurrent!
                                                  .rooms![index]
                                                  .messengerPresent! +
                                                  "  " +
                                                  d.hour.toString() +
                                                  ":" +
                                                  d.minute.toString(),
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ));
                        },
                      );
                    }
                    return SizedBox();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  HomeBloc create() => HomeBloc();

  @override
  void init(BuildContext context) {
    super.init(context);
    bloc.counterStream.asBroadcastStream();
    bloc.get();
  }

  @override
  void onStateChange(BuildContext context, BaseState baseState) {
    // TODO: implement onStateChange
  }
}
