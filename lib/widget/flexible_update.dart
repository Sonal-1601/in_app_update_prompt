import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher_string.dart';

void showDefaultFlexibleUpdateSnackbar(
  BuildContext context,
  GlobalKey<NavigatorState>? navigatorKey,
  Uri? updateUrl,
) {
  SnackBarAction? action;
  if (updateUrl != null) {
    action = SnackBarAction(
      label: 'Update',
      onPressed: () async {
        final canLaunch = await url_launcher.canLaunchUrl(updateUrl);
        if (canLaunch) {
          url_launcher.launchUrl(
            updateUrl,
            mode: LaunchMode.externalApplication,
          );
        }
      },
    );
  }

  final snackbar = SnackBar(
    behavior: SnackBarBehavior.floating,
    duration: const Duration(seconds: 10),
    content: const Text(
      'New version is available',
    ),
    action: action,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
