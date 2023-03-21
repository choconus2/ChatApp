// import 'package:chats_app/base_bloc/app_bloc.dart';
// import 'package:chats_app/base_bloc/base_bloc.dart';
// import 'package:chats_app/base_statefulWidget/base_statefulWidget.dart';
// import 'package:chats_app/main_bloc.dart';
// import 'package:chats_app/ui/login/login.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   return runApp(MaterialApp(
//     home: App(),
//   ));
// }
//
// class App extends BaseStatefulWidget<MainBloc> {
//   final fs = FirebaseFirestore.instance;
//   final Stream<QuerySnapshot> _messageStream =
//       FirebaseFirestore.instance.collection('dem').snapshots();
//   @override
//   Widget build(BuildContext context) {
//     // return StreamBuilder(
//     //   stream: _messageStream,
//     //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
//     //     return Scaffold(
//     //       body: Center(child: Text(bloc.cong.toString(),style: const TextStyle(color: Colors.red))),
//     //       floatingActionButton: FloatingActionButton(
//     //         onPressed: () async {
//     //           // bloc.call(() => null);
//     //           var userCredential = await FirebaseAuth.instance;
//     //           var x=[1,0];
//     //           var y=[0,1];
//     //           x.sort();
//     //           y.sort();
//     //           print(listEquals(x, y));
//     //           // UserCredential c =
//     //           // await FirebaseAuth.instance.signInWithEmailAndPassword(
//     //           //   email: "abc@gmail.com",
//     //           //   password: "123456",
//     //           // );
//     //           // print(userCredential.currentUser!.photoURL.toString()+"cvc");
//     //           // userCredential.currentUser?.updatePhotoURL("https://icon2.cleanpng.com/20180408/edw/kisspng-user-computer-icons-gravatar-blog-happy-woman-5aca6d038826d9.7357010215232156195577.jpg");
//     //           // fs.collection('Show').doc().set({
//     //           //   'title': "vcxvcx"
//     //           //
//     //           // });
//     //
//     //         },
//     //       ),
//     //     );
//     //   },
//     // );
//     return BlocListener<AppBloc, BaseState>(
//       bloc: AppBloc.instance,
//       listener: (BuildContext context, state) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LoginScreen(),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   MainBloc create() => MainBloc();
//
//   @override
//   void onStateChange(BuildContext context, BaseState baseState) {
//     // TODO: implement onStateChange
//   }
// }
import 'package:chats_app/ui/login/login.dart';
import 'package:chats_app/ui/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'base_bloc/app_bloc.dart';
import 'base_bloc/base_bloc.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_importance_channel",
    "High Importance Notifications",
    "this channel is used for important notifications.",
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessaging(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("ssasd ${message.messageId}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessaging);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  return runApp( MaterialApp(
    home: const App(),
    navigatorKey: navigatorKey,
  ));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher'),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A new onMessage");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(notification.title.toString()),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(notification.body.toString()),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, BaseState>(
      bloc: AppBloc.instance,
      builder: (BuildContext context, state) {
        return SplashScreen();
      },
    );
  }
}
