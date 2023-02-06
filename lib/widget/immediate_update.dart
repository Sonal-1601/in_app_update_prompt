import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher.dart';

void showDefaultImmediateUpdateSnackbar(
  BuildContext context,
  GlobalKey<NavigatorState>? navigatorKey,
  Uri? updateUrl,
) {
  showDialog(
    barrierDismissible: false,
    context: navigatorKey?.currentState?.context ?? context,
    builder: (BuildContext context) => WillPopScope(
      onWillPop: () => Future.value(false),
      child: ImmediateUpdateDialog(
        updateUrl: updateUrl,
      ),
    ),
  );
}

class ImmediateUpdateDialog extends StatelessWidget {
  final Uri? updateUrl;

  const ImmediateUpdateDialog({super.key, this.updateUrl});

  void _onUpdateButtonPress(context) async {
    final url = updateUrl;
    if (url == null) return null;
    if (await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update this App?'),
      content: const Text('To use the App, update to the latest version'),
      actions: [
        if (updateUrl != null)
          ElevatedButton(
            onPressed: () => _onUpdateButtonPress(context),
            child: const Text('UPDATE'),
          ),
      ],
    );
  }
}
