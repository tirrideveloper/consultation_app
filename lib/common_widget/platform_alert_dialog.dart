import 'dart:io';

import 'package:consultation_app/common_widget/platform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String content;
  final String buttonText;
  final String button2Text;

  PlatformAlertDialog(
      {@required this.title,
      @required this.content,
      @required this.buttonText,
      this.button2Text});

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context, builder: (context) => this)
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtons(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtons(context),
    );
  }

  List<Widget> _dialogButtons(BuildContext context) {
    final buttons = <Widget>[];

    if (Platform.isIOS) {
      if (button2Text != null) {
        buttons.add(
          CupertinoDialogAction(
            child: Text(button2Text),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }
      buttons.add(
        CupertinoDialogAction(
          child: Text(
            buttonText,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (button2Text != null) {
        buttons.add(
          TextButton(
            child: Text(button2Text,
                style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }
      buttons.add(
        TextButton(
          child: Text(buttonText,
              style: TextStyle(color: Theme.of(context).primaryColor)),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    }
    return buttons;
  }
}
