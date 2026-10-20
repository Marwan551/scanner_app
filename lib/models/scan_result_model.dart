class ScanResultNormalized {
  final dynamic code;
  final dynamic symbology;
  final DateTime timestamp;
  final dynamic scanService;

  ScanResultNormalized({
    required this.code,
    required this.symbology,
    required this.timestamp,
    required this.scanService
  });
  //add scanner provider

  factory ScanResultNormalized.fromMap(Map<String, dynamic> map) {
    return ScanResultNormalized(
      code: map['code'] ?? '',
      symbology: map['symbology'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      scanService: map['scanService'] ?? '',
    );
  }
}