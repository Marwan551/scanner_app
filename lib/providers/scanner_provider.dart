import 'package:flutter/foundation.dart';
import 'package:scanner_app/models/scan_result_model.dart';
import 'package:scanner_app/scanners/scanner_service.dart';
import 'package:scanner_app/scanners/scanner_factory.dart';

class ScannerProvider extends ChangeNotifier {

  ScannerService? _scannerService;
  ScannerService? get scannerService => _scannerService;

  final ValueNotifier<List<ScanResultNormalized>> scannedItemsNotifier =
      ValueNotifier([]);

  Future<void> initializeScanner(ScannerType type) async {
    await _scannerService?.disposeScan();
    _scannerService = ScannerFactory.createScanner(type);
    await _scannerService!.initScan(
      onScan: (item) {
        addListItem(item);
      },
    );
    notifyListeners();
  }

  void addListItem(ScanResultNormalized item) {
    final currentList = List<ScanResultNormalized>.from(scannedItemsNotifier.value);
    if (currentList.length >= 50) {
      currentList.removeLast();
    }
    currentList.insert(0, item);
    scannedItemsNotifier.value = currentList;
    notifyListeners();
  }

  Future<void> triggerScan() async {
    await _scannerService?.triggerScan();
  }

  @override
  void dispose() {
    _scannerService?.disposeScan();
    scannedItemsNotifier.dispose();
    super.dispose();
  }
}
