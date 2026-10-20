import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:scanwedge/scanwedge.dart';
import 'package:scanner_app/scanners/scanner_service.dart';
import 'package:scanner_app/models/scan_result_model.dart';

class ScanWedgeService implements ScannerService {
  Scanwedge? _scanwedge;

  bool _initialized = false;

  final notifierDisableKeystroke = ValueNotifier(true);
  final notifierAimType = ValueNotifier(AimType.trigger);

  @override
  Future<void> initScan({required void Function(ScanResultNormalized) onScan}) async {
    if (_initialized) {
      log('ScanWedge already initialized');
      return;
    }

    try {
      final scanwedge = await Scanwedge.initialize();
      _scanwedge = scanwedge;

      log('Device: ${scanwedge.deviceName}');
      log('Supported device: ${scanwedge.supportedDevice}');
      log('Package: ${scanwedge.packageName}');

      if (scanwedge.supportedDevice != SupportedDevice.zebra) {
        log('This profile requires a Zebra device');
        return;
      }

      scanwedge.stream.listen(
            (scanResult) {
          log(
            'SCAN RECEIVED: ${scanResult.barcode} | '
                'Type: ${scanResult.barcodeType.name} | '
                'Hardware type: ${scanResult.hardwareLabelType}',
          );

          final normalizedResult = ScanResultNormalized(
            code: scanResult.barcode,
            symbology: scanResult.barcodeType.name,
            timestamp: DateTime.now(),
            scanService: 'ScanWedge',
          );

          onScan(normalizedResult);
        },
        onError: (Object error, StackTrace stackTrace) {
          log(
            'ScanWedge stream error',
            error: error,
            stackTrace: stackTrace,
          );
        },
      );

      final success = await scanwedge.createScanProfile(
        ZebraProfileModel(
          profileName: 'ZebraProfile',
          enabledBarcodes: [
            BarcodeConfig(barcodeType: BarcodeTypes.qrCode),
            BarcodeConfig(barcodeType: BarcodeTypes.datamatrix),
            BarcodeConfig(barcodeType: BarcodeTypes.code128),
            BarcodeConfig(barcodeType: BarcodeTypes.code39),
            BarcodeConfig(barcodeType: BarcodeTypes.ean13),
            BarcodeConfig(barcodeType: BarcodeTypes.upca),
            BarcodeConfig(barcodeType: BarcodeTypes.aztec),
            BarcodeConfig(barcodeType: BarcodeTypes.pdf417),
          ],
          enableKeyStroke: !notifierDisableKeystroke.value,
          aimType: notifierAimType.value,
        ),
      );

      log('Profile creation result: $success');

      if (success != true) {
        log('Profile creation failed. Scanner not enabled.');
        return;
      }

      try {
        await scanwedge.enableScanner();
        log('Hardware scanner enabled');
      } catch (e) {
        log('Error enabling scanner: $e');
      }

      _initialized = true;
      log('ScanWedge initialized and scanner enabled');
    } catch (e, stackTrace) {
      log(
        'Error initializing ScanWedge',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> triggerScan() async {
    final scanwedge = _scanwedge;

    if (scanwedge == null || !_initialized) {
      log('Scanner is not initialized');
      return;
    }

    try {
      await scanwedge.enableScanner();
      log('Scanner enabled; sending software trigger');

      final result = await scanwedge.toggleScanning();
      log('Software trigger result: $result');
    } catch (e, stackTrace) {
      log(
        'Error triggering scanner',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> disposeScan() async {
    try {
      await _scanwedge?.disableScanner();
      log('Scanner disabled');
    } catch (e, stackTrace) {
      log(
        'Error disposing ScanWedge',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      _initialized = false;
    }
  }
}
