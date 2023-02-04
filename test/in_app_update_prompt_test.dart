import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:in_app_update_prompt/in_app_update_prompt.dart';

void main() {
  group('In app update widget ui', () {
    testWidgets('renders InAppUpdatePrompt widget', (tester) async {
      await tester.pumpWidget(const InAppUpdatePrompt(child: SizedBox()));

      expect(
        find.byType(InAppUpdatePrompt),
        findsOneWidget,
      );
    });
  });
}
