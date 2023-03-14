import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class BaseEvent {
  final FutureOr<dynamic> Function() onLogic;
  const BaseEvent(this.onLogic);
}

@immutable
class BaseState {
  final dynamic sign;
  const BaseState(this.sign);
}

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc() : super(const BaseState(null)) {
    on<BaseEvent>((event, emit) => emit(BaseState(event.onLogic())));
  }
  void call(FutureOr<dynamic> Function() onLogic) => add(BaseEvent(onLogic));

  //clear resource
  void release() {}
}
