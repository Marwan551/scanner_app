import 'package:flutter/material.dart';

class ScanTriggerButton extends StatelessWidget {
  final bool isInitializing;
  final VoidCallback onPressed;

  const ScanTriggerButton({
    super.key,
    required this.isInitializing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isInitializing ? null : onPressed,
      icon: const Icon(Icons.qr_code_scanner),
      label: Text(isInitializing ? 'Initializing...' : 'Trigger Scan'),
    );
  }
}
