import 'package:flutter/material.dart';

class GlobalMethods {
  static Future<void> showLogoutDialog(
      {required BuildContext context,
      required String title,
      required String content,
      required String actionText,
      required VoidCallback onPressed}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            TextButton(
              onPressed: onPressed,
              child: Text(actionText),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showErrorDialog(
      {required BuildContext context,
        required String content}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}
