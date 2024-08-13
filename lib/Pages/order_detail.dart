import 'package:flutter/material.dart';
import '../Helpers/ProgressBar.dart';
import '../Models/orderDetailModel.dart';
import '../Models/orderModel.dart';
import '../Services/ordersService.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<OrderDetail> _orderDetails = [];

  Future<void> getOrderDetails(filter) async {
    List<OrderDetail> response = [];
    var o = await OrdersService.getOrderDetailsByOrder(widget.order);
    if (filter.toString().isNotEmpty) {
      response = o
          .where((e) => (
              e.partNumber.toUpperCase().contains(filter.toString().toUpperCase()) ||
              e.quantity.toString().toUpperCase().contains(filter.toString().toUpperCase()) ||
              e.serial.toUpperCase().contains(filter.toString().toUpperCase()) ||
              e.master.toUpperCase().contains(filter.toString().toUpperCase()) ||
              e.date.toString().toUpperCase().contains(filter.toString().toUpperCase())))
          .toList();
    } else {
      response = o;
    }

    setState(() {
      _orderDetails = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrderDetails("");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextFormField(
                  onChanged: (text) {
                    ProgressBar.instance.show(context);
                    getOrderDetails(text);
                    ProgressBar.instance.hide();
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Buscar',
                  ),
                ),
                Text(''),
                for (int x = 0; x < _orderDetails.length; x++) ...[
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                            title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(''),
                              Text('# Parte: ${_orderDetails[x].partNumber}'),
                            ]),
                            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(''),
                              Text('Cantidad: ${_orderDetails[x].qty}'),
                              Text('Master: ${_orderDetails[x].master}'),
                              Text('Fecha: ${_orderDetails[x].date}'),
                              Text(''),
                            ]))
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
