import 'package:scanner_app/models/scan_result_model.dart';

abstract class ScannerService {
  Future<void> initScan({required void Function(ScanResultNormalized) onScan});
  Future<void> triggerScan();
  Future<void> disposeScan();
}
