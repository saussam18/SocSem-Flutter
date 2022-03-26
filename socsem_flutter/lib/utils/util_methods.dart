import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showMessage(BuildContext context, String title, String e) {
  bool isIos = Platform.isIOS;
  showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return isIos
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(e),
                actions: [
                    CupertinoDialogAction(
                      child: const Text("Ok"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ])
            : AlertDialog(
                title: Text(title),
                content: Text(e),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(builderContext).pop();
                    },
                  )
                ],
              );
      });
}
