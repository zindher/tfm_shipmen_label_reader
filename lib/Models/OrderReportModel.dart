import 'package:decimal/decimal.dart';

class OrderReport {
  final String partNumber;
  final String description;
  final Decimal quantityPlan;
  final Decimal quantityReal;
  final Decimal quantityDiff;

  OrderReport({
    required this.partNumber,
    required this.description,
    required this.quantityPlan,
    required this.quantityReal,
    required this.quantityDiff,
  });
}