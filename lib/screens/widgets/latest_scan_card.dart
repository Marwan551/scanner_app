import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/models/scan_result_model.dart';
import 'package:scanner_app/providers/scanner_provider.dart';

class LatestScanCard extends StatelessWidget {
  final bool isInitializing;

  const LatestScanCard({
    super.key,
    required this.isInitializing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Last Scanned Value:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Consumer<ScannerProvider>(
          builder: (context, provider, child) {
            return ValueListenableBuilder<List<ScanResultNormalized>>(
              valueListenable: provider.scannedItemsNotifier,
              builder: (context, items, child) {
                if (items.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(isInitializing ? 'Scanner initializing...' : 'No scans yet. Scan a barcode.'),
                    ),
                  );
                }
                final latest = items.first;
                return Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Code: ${latest.code}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Symbology: ${latest.symbology ?? "Unknown"}'),
                        Text('Timestamp: ${latest.timestamp.toLocal()}'),
                        Text('Scan Service: ${latest.scanService}'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
