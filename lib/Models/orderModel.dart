class Order {
  final String customerName;
  final String id;
  final String status;
  final DateTime? lastScanDate;
  final String? currentScanInternalID;
  final int? statusId;
  final String lastModifiedBy;
  final String partNumber;
  final String internalPartNumber;
  final String clientCode;
  final int? quantity;
  final List<String>? serials;

  Order({
    this.customerName = '',
    this.id = '',
    this.status = '',
    this.lastScanDate = null,
    this.currentScanInternalID = null,
    this.statusId = null,
    this.lastModifiedBy = '',
    this.partNumber = '',
    this.internalPartNumber = '',
    this.quantity = null,
    this.serials = null,
    this.clientCode = ''
  });

}