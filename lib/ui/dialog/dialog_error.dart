import 'package:flutter/material.dart';

showDialogErrorCommon(BuildContext context, {String? errorText}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        scrollable: true,
        title: Icon(
          Icons.error_outlined,
          color: Colors.red,
          size: 60,
        ),
        content: Center(
            child: Text(
          errorText ?? "has an error",
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
