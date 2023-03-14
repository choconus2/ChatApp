// ignore_for_file: must_be_immutable
import 'package:flutter/widgets.dart';
import '../base_bloc/base_bloc.dart';
import 'base_bloc_consumer.dart';

abstract class BaseStatefulWidget<T extends BaseBloc> extends StatefulWidget {
  T? _bloc;
  late _UseController useController;
  late BuildContext baseContext;

  BaseStatefulWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BaseState<T>();

  T get bloc => _bloc!;

  T create();

  List<dynamic> createStateBuildWhen() => [];

  List<dynamic> createStateListenerWhen() => [];

  Widget build(BuildContext context);

  void onStateChange(BuildContext context, BaseState baseState);

  void init(BuildContext context) {}

  void onDestroy() {}

  void onResume() {}

  void onPaused() {}
}

class _BaseState<T extends BaseBloc> extends State<BaseStatefulWidget>
    with
        WidgetsBindingObserver,
        SingleTickerProviderStateMixin,
        _UseController {
  bool _didChangeDependencies = false;
  final Map<String, TextEditWrapController> _textEditWrapControllerMap = {};
  final Map<String, AnimationController> _animationControllerMap = {};

  @override
  void initState() {
    super.initState();
    widget._bloc = _BlocCreator.instance.create(T, widget.create);
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didChangeDependencies) {
      // widget._bloc?.addOrSetBlocAccessWidget(
      //   widget,
      //   buildContext: context,
      //   textWrapController: _textEditWrapControllerMap,
      // );
      widget.init(context);
    }
    _didChangeDependencies = true;
  }

  @override
  Widget build(BuildContext context) {
    return BaseBlocConsumer<T>(
      buildBody: widget.build,
      bloc: _attach(),
      onStateChange: widget.onStateChange,
      stateBuildWhen: widget.createStateBuildWhen(),
      stateListenerWhen: widget.createStateListenerWhen(),
    );
  }

  T _attach() {
    widget._bloc ??= _BlocCreator.instance.create(T, widget.create);
    widget.useController = this;
    widget.baseContext = context;
    return widget._bloc as T;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.onResume();
        break;
      case AppLifecycleState.paused:
        widget.onPaused();
        break;
      default:
        super.didChangeAppLifecycleState(state);
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _textEditWrapControllerMap.forEach((key, value) {
      value.textEditingController.dispose();
      value.focusNode.dispose();
    });
    _textEditWrapControllerMap.clear();
    _animationControllerMap.forEach((key, value) {
      value.dispose();
    });
    _animationControllerMap.clear();
    // widget._bloc?.removeBlocAccessWidget(widget);
    _BlocCreator.instance._observableBloc.update(
      T,
          (value) => value - 1,
    );
    if (_BlocCreator.instance._observableBloc[T] == 0) {
      widget._bloc?.close();
      _BlocCreator.instance
        ..release(T)
        .._observableBloc.remove(T);
    }
    widget.onDestroy();
    super.dispose();
  }

  @override
  AnimationController useAnimationController(String key,
      {double? value,
        Duration? duration,
        Duration? reverseDuration,
        String? debugLabel,
        double lowerBound = 0.0,
        double upperBound = 1.0,
        AnimationBehavior animationBehavior = AnimationBehavior.normal}) {
    if (_animationControllerMap.containsKey(key)) {
      return _animationControllerMap[key]!;
    }
    return _animationControllerMap[key] = AnimationController(
      vsync: this,
      value: value,
      duration: duration,
      reverseDuration: reverseDuration,
      debugLabel: debugLabel,
      lowerBound: lowerBound,
      upperBound: upperBound,
      animationBehavior: animationBehavior,
    );
  }

  @override
  TextEditWrapController getTextEditWrapController(String key,
      {String initText = ""}) {
    if (_textEditWrapControllerMap.containsKey(key)) {
      return _textEditWrapControllerMap[key]!;
    }
    return _textEditWrapControllerMap[key] =
        TextEditWrapController(defaultText: initText);
  }
}

abstract class _UseController {
  AnimationController useAnimationController(
      String key, {
        double? value,
        Duration? duration,
        Duration? reverseDuration,
        String? debugLabel,
        double lowerBound = 0.0,
        double upperBound = 1.0,
        AnimationBehavior animationBehavior = AnimationBehavior.normal,
      });

  TextEditWrapController getTextEditWrapController(String key,
      {String initText = ""});
}

class TextEditWrapController {
  final String defaultText;
  late final TextEditingController textEditingController;
  final FocusNode focusNode = FocusNode();
  String? errorText;

  TextEditWrapController({this.defaultText = ""}) {
    textEditingController = TextEditingController(text: defaultText);
  }
}

class _BlocCreator {
  static _BlocCreator? _instance;

  _BlocCreator._();

  static _BlocCreator get instance {
    _instance ??= _BlocCreator._();
    return _instance!;
  }

  final Map<Type, int> _observableBloc = {};
  final Map<Type, BaseBloc> _cacheBaseBloc = {};


  T create<T extends BaseBloc>(Type type, T Function() onCreate) {
    if (_observableBloc.containsKey(type)) {
      _observableBloc.update(type, (value) => value + 1);
    } else {
      _observableBloc.putIfAbsent(type, () => 1);
    }
    if (_cacheBaseBloc.containsKey(type)) {
      return _cacheBaseBloc[type]! as T;
    }
    final bloc = onCreate();
    _cacheBaseBloc[type] = bloc;
    return bloc;
  }

  T? get<T extends BaseBloc>(Type type) => _cacheBaseBloc[type] as T?;

  void release(Type type) {
    if (_cacheBaseBloc.containsKey(type)) {
      _cacheBaseBloc.remove(type);
    }
  }
}

T? getBlocProvider<T extends BaseBloc>() => _BlocCreator.instance.get(T);
