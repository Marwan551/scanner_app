import 'package:pointmobile_scanner_advanced/pointmobile_scanner_advanced.dart';
import 'package:scanner_app/models/scan_result_model.dart';
import 'package:scanner_app/scanners/scanner_service.dart';
import 'package:flutter/foundation.dart';

class PointMobileScannerService implements ScannerService {
  bool _isInitialized = false;
  void Function(ScanResultNormalized)? _onScan;

  @override
  Future<void> initScan({required void Function(ScanResultNormalized) onScan}) async {
    _onScan = onScan;
    try {
      if (!await PMScanner.isDevicePointMobile()) {
        return;
      }
      await PMScanner.initScanner(
          resultType: ResultType.clipboardKeycodePaste);
      PMScanner.onDecode = _onDecode;
      _isInitialized = true;
      debugPrint("PointMobile Scanner Initialized");
    } catch(e) {
      debugPrint('Error initializing PointMobile Scanner: $e');
    }
  }

  @override
  Future<void> disposeScan() async {
    try {
      PMScanner.triggerOnOff(isOn: false);
    } catch(e) {
      debugPrint('Error disposing PointMobile Scanner: $e');
    }
    PMScanner.onDecode = null;
    _isInitialized = false;
  }

  @override
  Future<void> triggerScan() async {
    if (!_isInitialized) {
      debugPrint('PointMobile Scanner not initialized');
      return;
    }
    try {
      await PMScanner.triggerOnOff(isOn: true);
    } catch(e) {
      debugPrint('Error triggering PointMobile Scanner: $e');
    }
  }

  void _onDecode(Symbology symbology, String barcodeNumber) {
    final item = ScanResultNormalized(
        code: barcodeNumber,
        symbology: symbology.toString(),
        timestamp: DateTime.now(),
        scanService: 'PointMobile',
    );
    _onScan?.call(item);
  }
}
