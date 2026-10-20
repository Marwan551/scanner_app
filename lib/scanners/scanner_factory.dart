import 'package:scanner_app/scanners/scanner_service.dart';
import 'package:scanner_app/scanners/scanwedge_scanner_service.dart';
import 'package:scanner_app/scanners/honeywell_scanner_service.dart';
import 'package:scanner_app/scanners/pointmobile_scanner_service.dart';

enum ScannerType { scanwedge, honeywell, pointmobile}

class ScannerFactory {
  static ScannerService createScanner(ScannerType type) {
    switch (type) {
      case ScannerType.scanwedge:
        return ScanWedgeService();
      case ScannerType.honeywell:
        return HoneywellScannerService();
      case ScannerType.pointmobile:
        return PointMobileScannerService();
    }
  }
}
