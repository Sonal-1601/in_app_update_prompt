import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

enum UpdateType {
  undetermined,
  none,
  flexible,
  immediate,
}

typedef GetVersionStringCallback = Future<String?> Function();

final _logger = Logger('in_app_update_prompt.UpdateTypeController');

Future<String> getCurrentPlatformVersion() async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  return '${info.version}+${info.buildNumber}';
}

class UpdateTypeNotifier extends ValueNotifier<UpdateType> {
  UpdateTypeNotifier({
    this.getCurrentVersion = getCurrentPlatformVersion,
    required this.getFlexibleVersion,
    required this.getImmediateVersion,
  }) : super(UpdateType.undetermined);

  final GetVersionStringCallback getCurrentVersion;
  final GetVersionStringCallback getFlexibleVersion;
  final GetVersionStringCallback getImmediateVersion;

  static Future<Version?> _fetchAndParseVersion(
    GetVersionStringCallback getVersion,
  ) async {
    try {
      final version = await getVersion();
      if (version == null || version.isEmpty) return null;
      return Version.parse(version);
    } catch (e, s) {
      _logger.severe('Failed to get verion', e, s);
      return null;
    }
  }

  Future<UpdateType> getUpdateType() async {
    final currentVersion = await _fetchAndParseVersion(getCurrentVersion);
    if (currentVersion == null) return UpdateType.none;

    final immediateVersion = await _fetchAndParseVersion(getImmediateVersion);
    if (immediateVersion != null && currentVersion < immediateVersion) {
      return UpdateType.immediate;
    }

    final flexibleVersion = await _fetchAndParseVersion(getFlexibleVersion);
    if (flexibleVersion != null && currentVersion < flexibleVersion) {
      return UpdateType.flexible;
    }

    return UpdateType.none;
  }

  Future<void> resolve() async {
    final updateType = await getUpdateType();
    value = updateType;
  }
}
