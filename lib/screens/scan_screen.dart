import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/providers/scanner_provider.dart';
import 'package:scanner_app/scanners/scanner_factory.dart';
import 'package:scanner_app/screens/widgets/scanner_dropdown_selector.dart';
import 'package:scanner_app/screens/widgets/scan_trigger_button.dart';
import 'package:scanner_app/screens/widgets/latest_scan_card.dart';
import 'package:scanner_app/screens/widgets/scan_history_list.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ScannerType _selectedType = ScannerType.scanwedge;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initScanner(_selectedType);
    });
  }

  Future<void> _initScanner(ScannerType type) async {
    setState(() {
      _isInitializing = true;
      _selectedType = type;
    });
    try {
      await context.read<ScannerProvider>().initializeScanner(type);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing scanner: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Scanner App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScannerDropdownSelector(
              selectedType: _selectedType,
              isInitializing: _isInitializing,
              onChanged: (type) {
                if (type != null) {
                  _initScanner(type);
                }
              },
            ),
            const SizedBox(height: 16),
            ScanTriggerButton(
              isInitializing: _isInitializing,
              onPressed: () {
                context.read<ScannerProvider>().triggerScan();
              },
            ),
            const SizedBox(height: 24),
            LatestScanCard(isInitializing: _isInitializing),
            const SizedBox(height: 24),
            Expanded(
              child: ScanHistoryList(isInitializing: _isInitializing),
            ),
          ],
        ),
      ),
    );
  }
}
