import 'package:app/main.dart';
import 'package:app/util/shared_preference.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonUtil {

  /// Format server date strings into human readable format
  static getServerDateToString(String dateTime) {
    return DateFormat('dd MMM yyyy').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime));
  }

  static openUrl(String url) async {
    var uri = Uri.parse(Uri.encodeFull(url));
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

  static logoutUser(BuildContext context) {
    SharedPref.instance.deleteValue(SharedPref.keyUserInfo);
    SharedPref.instance.deleteValue(SharedPref.keySessionToken);
    SharedPref.instance.deleteValue(SharedPref.keyUserId);
    Navigator.pushNamedAndRemoveUntil(context, loginRoute, (r) => false);
  }
}
