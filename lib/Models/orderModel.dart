class Order {
  final String customerName;
  final String id;
  final String status;
  final DateTime? lastScanDate;
  final String? currentScanInternalID;
  final int? statusId;
  final String lastModifiedBy;

  Order({
    required this.customerName,
    required this.id,
    required this.status,
    required this.lastScanDate,
    required this.currentScanInternalID,
    required this.statusId,
    required this.lastModifiedBy
  });

}