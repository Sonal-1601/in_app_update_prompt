import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:in_app_update_prompt/in_app_update_prompt.dart';

Future<String?> _doNothing() async {
  return null;
}

void main() {
  group('In app update widget ui', () {
    late UpdateTypeNotifier notifier;

    setUp(() {
      notifier = UpdateTypeNotifier(
        getFlexibleVersion: _doNothing,
        getImmediateVersion: _doNothing,
      );
    });

    tearDown(() {
      notifier.dispose();
    });

    testWidgets('renders InAppUpdatePrompt widget', (tester) async {
      await tester.pumpWidget(
        InAppUpdate(
          notifier: notifier,
          child: const SizedBox(),
        ),
      );

      expect(
        find.byType(InAppUpdate),
        findsOneWidget,
      );
    });
  });
}
