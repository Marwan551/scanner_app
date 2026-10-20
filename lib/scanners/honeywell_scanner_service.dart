import 'package:flutter/foundation.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:scanner_app/models/scan_result_model.dart';
import 'package:scanner_app/scanners/scanner_service.dart';

class HoneywellScannerService
    implements ScannerService, ScannerCallback {
  final HoneywellScanner _scanner = HoneywellScanner();
  void Function(ScanResultNormalized)? _onScan;

  @override
  Future<void> initScan({required void Function(ScanResultNormalized) onScan}) async {
    _onScan = onScan;
    _scanner.setScannerCallback(this);

    final supported = await _scanner.isSupported();
    debugPrint('Honeywell isSupported: $supported');

    if (!supported) {
      throw Exception('Honeywell scanner is not supported on this device');
    }

    List<CodeFormat> codeFormats = [];

    codeFormats.addAll(CodeFormatUtils.ALL_1D_FORMATS);
    codeFormats.addAll(CodeFormatUtils.ALL_2D_FORMATS);

    Map<String, dynamic> properties =
    CodeFormatUtils.getAsPropertiesComplement(codeFormats);

    properties['DEC_CODABAR_START_STOP_TRANSMIT'] = true;
    properties['DEC_EAN13_CHECK_DIGIT_TRANSMIT'] = true;

    _scanner.setProperties(properties);

    await _scanner.startScanner();
    debugPrint('Honeywell scanner started successfully.');
  }

  @override
  void onDecoded(ScannedData? scannedData) {
    if (scannedData == null) {
      debugPrint('Honeywell onDecoded: scannedData is null');
      return;
    }

    final code = scannedData.code?.toString() ?? '';
    debugPrint('Honeywell onDecoded -> code: $code, codeId: ${scannedData.codeId}');

    if (code.isEmpty) return;

    ScanResultNormalized item = ScanResultNormalized(
      code: code,
      symbology: scannedData.codeId?.toString(),
      timestamp: DateTime.now(),
      scanService: 'HoneyWell',
    );

    _onScan?.call(item);
  }

  @override
  void onError(Exception error) {
    debugPrint('Honeywell scanner error: $error');
  }

  @override
  Future<void> triggerScan() async {
    debugPrint('Honeywell triggerScan called');
    try {
      await _scanner.startScanning();
    } catch (e) {
      debugPrint('Honeywell triggerScan error: $e');
    }
  }

  @override
  Future<void> disposeScan() async {
    debugPrint('Honeywell disposeScan called');
    try {
      await _scanner.disposeScanner();
    } catch (e) {
      debugPrint('Honeywell disposeScan error: $e');
    }
  }
}
