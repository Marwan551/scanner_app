import 'package:flutter/material.dart';
import 'package:scanner_app/scanners/scanner_factory.dart';

class ScannerDropdownSelector extends StatelessWidget {
  final ScannerType selectedType;
  final bool isInitializing;
  final ValueChanged<ScannerType?> onChanged;

  const ScannerDropdownSelector({
    super.key,
    required this.selectedType,
    required this.isInitializing,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Select Scanner: ', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButton<ScannerType>(
            value: selectedType,
            isExpanded: true,
            items: ScannerType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.name.toUpperCase()),
              );
            }).toList(),
            onChanged: isInitializing ? null : onChanged,
          ),
        ),
      ],
    );
  }
}
