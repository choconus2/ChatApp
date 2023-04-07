import 'package:flutter/material.dart';

showDialogSuccessCommon(BuildContext context, {String? successText}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Icon(
          Icons.check,
          color: Colors.green,
          size: 60,
        ),
        content: Center(
            child: Text(
          successText ?? "successfully",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        )),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Ok'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
