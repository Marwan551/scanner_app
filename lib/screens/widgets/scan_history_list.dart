import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/models/scan_result_model.dart';
import 'package:scanner_app/providers/scanner_provider.dart';

class ScanHistoryList extends StatelessWidget {
  final bool isInitializing;

  const ScanHistoryList({
    super.key,
    required this.isInitializing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Scan History:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Consumer<ScannerProvider>(
            builder: (context, provider, child) {
              return ValueListenableBuilder<List<ScanResultNormalized>>(
                valueListenable: provider.scannedItemsNotifier,
                builder: (context, items, child) {
                  if (items.isEmpty) {
                    return Center(
                      child: Text(isInitializing ? 'Initializing scanner...' : 'History is empty'),
                    );
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final scan = items[index];
                      return ListTile(
                        leading: const Icon(Icons.qr_code),
                        title: Text(scan.code.toString()),
                        subtitle: Text('Symbology: ${scan.symbology ?? "N/A"}  Service: ${scan.scanService ?? "N/A"}'),
                        trailing: Text(
                          '${scan.timestamp.hour}:${scan.timestamp.minute.toString().padLeft(2, '0')}:${scan.timestamp.second.toString().padLeft(2, '0')}',
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
