import 'package:chats_app/base_bloc/base_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseBlocConsumer<T extends BaseBloc> extends StatelessWidget {
  final Widget Function(BuildContext context) buildBody;
  final void Function(BuildContext context, BaseState baseState) onStateChange;
  final List<dynamic> stateBuildWhen;
  final List<dynamic> stateListenerWhen;
  final T bloc;

  const BaseBlocConsumer({
    Key? key,
    required this.buildBody,
    required this.bloc,
    required this.onStateChange,
    required this.stateBuildWhen,
    required this.stateListenerWhen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<T, BaseState>(
      bloc: bloc,
      listener: onStateChange,
      child: BlocBuilder<T, BaseState>(
        bloc: bloc,
        builder: (ctx, state) {
          return buildBody(ctx);
        },
      ),
    );
  }
}
