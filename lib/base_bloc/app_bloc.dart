import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:chats_app/model/user.dart';

class AppBloc extends BaseBloc{
  static AppBloc? _instance;

  AppBloc._();

  static AppBloc get instance {
    _instance ??= AppBloc._();
    return _instance!;
  }

  String? accessToken;
  Users? userCurrent;
  String? uidSearch;
  String? idRoomPresent;
  List<Users> userRoom=[];

  // void get checkAuthentication async {
  //
  //   final accessTokenLocal =
  //   await secureStorageHelper.readByKey("user_access_Token");
  // }
}