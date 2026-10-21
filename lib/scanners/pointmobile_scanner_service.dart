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
    debugPrint('PointMobileScannerService: initScan started');
    if (_isInitialized) {
      debugPrint('PointMobileScannerService: Already initialized');
      return;
    }
    try {
      final isPM = await PMScanner.isDevicePointMobile();
      debugPrint('PointMobile isDevicePointMobile: $isPM');
      if (!isPM) {
        debugPrint('PointMobileScannerService: Not a PointMobile device');
        return;
      }

      await PMScanner.initScanner(resultType: ResultType.clipboardKeycodePaste);
      await PMUtils.listenClipboard();
      PMScanner.onDecode = _onDecode;
      _isInitialized = true;
      debugPrint("PointMobile Scanner Initialized successfully");
      debugPrint('------------------------------------------------------------------------');
      debugPrint('PointMobileScannerService: _onDecode registered: ${PMScanner.onDecode != null}');
      debugPrint('------------------------------------------------------------------------');

    } catch (e, stackTrace) {
      debugPrint('Error initializing PointMobile Scanner: $e\n$stackTrace');
    }
  }

  @override
  Future<void> disposeScan() async {
    debugPrint('PointMobileScannerService: disposeScan called');
    try {
      await PMScanner.triggerOnOff(isOn: false);
      await PMUtils.stopListeningClipboard();
      debugPrint('PointMobile Scanner trigger turned off and stopped listening clipboard');
    } catch (e) {
      debugPrint('Error disposing PointMobile Scanner: $e');
    }
    PMScanner.onDecode = null;
    _isInitialized = false;
  }

  @override
  Future<void> triggerScan() async {
    debugPrint('PointMobileScannerService: triggerScan called (_isInitialized: $_isInitialized)');
    if (!_isInitialized) {
      debugPrint('PointMobile Scanner not initialized');
      return;
    }
    try {
      await PMScanner.triggerOnOff(isOn: true);
      debugPrint('PointMobile software trigger turned ON');
    } catch (e, stackTrace) {
      debugPrint('Error triggering PointMobile Scanner: $e\n$stackTrace');
    }
  }

  void _onDecode(Symbology symbology, String barcodeNumber) {
    debugPrint('PointMobile onDecode -> code: $barcodeNumber, symbology: $symbology');
    final item = ScanResultNormalized(
        code: barcodeNumber,
        symbology: symbology.toString(),
        timestamp: DateTime.now(),
        scanService: 'PointMobile',
    );
    _onScan?.call(item);
  }
}
