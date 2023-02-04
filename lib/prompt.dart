import 'package:flutter/material.dart';

class InAppUpdatePrompt extends StatefulWidget {
  const InAppUpdatePrompt({super.key, required this.child});

  final Widget child;

  @override
  State<InAppUpdatePrompt> createState() => _InAppUpdatePromptState();
}

class _InAppUpdatePromptState extends State<InAppUpdatePrompt> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
