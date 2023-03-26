import 'package:flutter/material.dart';
import '../../widget_common/loading.dart';

showDialogLoadingCommon(BuildContext context, {Widget? widget}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Center(child: widget ?? const Loading()));
    },
  );
}
