import 'package:decimal/decimal.dart';

class OrderDetail {
  final String id;
  final String partNumber;
  final Decimal quantity;
  final String serial;
  final String master;
  final DateTime? date;
  final String akiSerial;

  OrderDetail({
    required this.id,
    required this.partNumber,
    required this.quantity,
    required this.serial,
    required this.master,
    required this.date,
    required this.akiSerial
  });
}