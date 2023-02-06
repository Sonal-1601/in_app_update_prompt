import 'package:flutter/material.dart';

import 'widget/flexible_update.dart';
import 'widget/immediate_update.dart';

typedef OnUpdatePromptCallback = void Function(
  BuildContext context,
  GlobalKey<NavigatorState>? navigatorKey,
  Uri? updateUrl,
);
typedef GetUpdateUrlCallback = Future<Uri?> Function(BuildContext context);

class InAppUpdatePromptThemeData
    extends ThemeExtension<InAppUpdatePromptThemeData> {
  const InAppUpdatePromptThemeData({
    required this.getUpdateUrl,
    required this.onFlexibleUpdate,
    required this.onImmediateUpdate,
  });

  final OnUpdatePromptCallback onFlexibleUpdate;
  final OnUpdatePromptCallback onImmediateUpdate;
  final GetUpdateUrlCallback getUpdateUrl;

  @override
  InAppUpdatePromptThemeData copyWith({
    GetUpdateUrlCallback? getUpdateUrl,
    OnUpdatePromptCallback? onFlexibleUpdate,
    final OnUpdatePromptCallback? onImmediateUpdate,
  }) {
    return InAppUpdatePromptThemeData(
      getUpdateUrl: getUpdateUrl ?? this.getUpdateUrl,
      onFlexibleUpdate: onFlexibleUpdate ?? this.onFlexibleUpdate,
      onImmediateUpdate: onImmediateUpdate ?? this.onImmediateUpdate,
    );
  }

  factory InAppUpdatePromptThemeData.defaultTheme() {
    return InAppUpdatePromptThemeData(
      getUpdateUrl: (context) => Future<Uri?>.value(null),
      onFlexibleUpdate: showDefaultFlexibleUpdateSnackbar,
      onImmediateUpdate: showDefaultImmediateUpdateSnackbar,
    );
  }

  @override
  InAppUpdatePromptThemeData lerp(
    covariant InAppUpdatePromptThemeData? other,
    double t,
  ) {
    if (other == null) return this;
    return InAppUpdatePromptThemeData.lerp(this, other, t);
  }

  @override
  bool operator ==(Object other) {
    return other is InAppUpdatePromptThemeData &&
        getUpdateUrl == other.getUpdateUrl &&
        onFlexibleUpdate == other.onFlexibleUpdate &&
        onImmediateUpdate == other.onImmediateUpdate;
  }

  @override
  int get hashCode => Object.hashAll([
        getUpdateUrl,
        onFlexibleUpdate,
        onImmediateUpdate,
      ]);

  factory InAppUpdatePromptThemeData.lerp(
    InAppUpdatePromptThemeData a,
    InAppUpdatePromptThemeData b,
    double t,
  ) {
    return InAppUpdatePromptThemeData(
      getUpdateUrl: t < 0.5 ? a.getUpdateUrl : b.getUpdateUrl,
      onFlexibleUpdate: t < 0.5 ? a.onFlexibleUpdate : b.onFlexibleUpdate,
      onImmediateUpdate: t < 0.5 ? a.onImmediateUpdate : b.onImmediateUpdate,
    );
  }
}

class InAppUpdatePromptTheme extends InheritedTheme {
  const InAppUpdatePromptTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final InAppUpdatePromptThemeData data;

  @override
  bool updateShouldNotify(covariant InAppUpdatePromptTheme oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return InAppUpdatePromptTheme(data: data, child: child);
  }

  static InAppUpdatePromptThemeData of(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<InAppUpdatePromptTheme>();
    return widget?.data ?? InAppUpdatePromptThemeData.defaultTheme();
  }
}
