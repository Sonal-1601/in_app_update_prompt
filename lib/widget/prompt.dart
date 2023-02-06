import 'package:flutter/material.dart';
import 'package:in_app_update_prompt/theme.dart';
import 'package:logging/logging.dart';

import '../notifier.dart';

class InAppUpdate extends StatefulWidget {
  const InAppUpdate({
    super.key,
    required this.child,
    this.navigatorKey,
    required this.notifier,
    this.theme,
  });

  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;
  final UpdateTypeNotifier notifier;
  final InAppUpdatePromptThemeData? theme;

  @override
  State<InAppUpdate> createState() => InAppUpdateState();
}

final _logger = Logger('in_app_update_prompt.InAppUpdateState');

class InAppUpdateState extends State<InAppUpdate> {
  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(onUpdateTypeChange);
    Future(() {
      resolve();
    });
  }

  @override
  void didUpdateWidget(covariant InAppUpdate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notifier != oldWidget.notifier) {
      oldWidget.notifier.removeListener(onUpdateTypeChange);
      widget.notifier.addListener(onUpdateTypeChange);
      Future(() {
        resolve();
      });
    }
  }

  void resolve() async {
    _logger.info('resolving update type from notifier');
    try {
      await widget.notifier.resolve();
    } catch (e, s) {
      _logger.severe('Failed to resolve [UpdateType]', e, s);
    }
  }

  Future<Uri?> _fetchUpdateUrl(InAppUpdatePromptThemeData theme) async {
    try {
      final url = await theme.getUpdateUrl(context);
      return url;
    } catch (e, s) {
      _logger.severe('Failed to fetch update url', e, s);
      return null;
    }
  }

  void onUpdateTypeChange() async {
    final updateType = widget.notifier.value;
    _logger.info('onUpdateTypeChange from notifier: $updateType');
    if (!mounted) return;
    final theme = widget.theme ?? InAppUpdatePromptTheme.of(context);
    switch (updateType) {
      case UpdateType.flexible:
        theme.onFlexibleUpdate(
            context, widget.navigatorKey, await _fetchUpdateUrl(theme));
        break;
      case UpdateType.immediate:
        theme.onImmediateUpdate(
            context, widget.navigatorKey, await _fetchUpdateUrl(theme));
        break;
      default:
      // do nothing
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
