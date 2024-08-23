import '../Helpers/ProgressBar.dart';
import '../Models/orderModel.dart';
import 'package:flutter/material.dart';
import '../Services/ordersService.dart';

class OrderInquiryPage extends StatefulWidget {
  final Function callback;

  const OrderInquiryPage({super.key, required this.callback});

  @override
  _OrderInquiryPageState createState() => _OrderInquiryPageState();
}

class _OrderInquiryPageState extends State<OrderInquiryPage> {
  List<Order> _orders = [];

  Future<void> getOrders(filter) async {
    List<Order> response = [];
    var o = await OrdersService.getOrders();
    if (filter.toString().isNotEmpty) {
      response = o
          .where((e) => (e.id.toUpperCase().contains(filter.toString().toUpperCase()) ||
              e.customerName.toUpperCase().contains(filter.toString().toUpperCase()) ||
              e.status.toUpperCase().contains(filter.toString().toUpperCase()) ||
              e.lastScanDate.toString().toUpperCase().contains(filter.toString().toUpperCase())))
          .toList();
    } else {
      response = o.where((e) => e.statusId == null || e.statusId == 1 || e.statusId == 2).toList();
    }

    setState(() {
      _orders = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrders("");
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
                    getOrders(text);
                    ProgressBar.instance.hide();
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Buscar',
                  ),
                ),
                const Text(''),
                for (int x = 0; x < _orders.length; x++) ...[
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pedido: ${_orders[x].id}'),
                              Text('${_orders[x].status}',
                                  style: TextStyle(
                                    color: _orders[x].statusId == null
                                        ? Colors.amber
                                        : _orders[x].statusId == 0
                                            ? Colors.red
                                            : _orders[x].statusId == 1
                                                ? Colors.grey
                                                : _orders[x].statusId == 2
                                                    ? Colors.green
                                                    : Colors.blue,
                                  ))
                            ],
                          ),
                          subtitle: Text('Fecha de captura: ${_orders[x].lastScanDate ?? ''}'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.only(left: 17.0),
                                child: Text(
                                  'Cliente: ${_orders[x].customerName}',
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: _orders[x].statusId != null,
                          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                            TextButton(
                              child: const Text('VER DTALLES'),
                              onPressed: () => {
                                widget.callback(4, _orders[x], 0),
                              },
                            ),
                            const SizedBox(width: 8),
                          ]),
                        ),
                        Visibility(
                          visible: _orders[x].statusId == null,
                          child: Text(""),
                        ),
                      ],
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
